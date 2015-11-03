




#import "AirTrafficSettingsDataSource.h"
#import "AirTrafficSettingsDataSourceDelegate.h"

#import "FlipSwitch/FSSwitchDataSource.h"
#import "FlipSwitch/FSSwitchPanel.h"

#import <dlfcn.h>





@interface iTunesSyncSwitch : NSObject <FSSwitchDataSource, AirTrafficSettingsDataSourceDelegate>
{
}

@end





@implementation iTunesSyncSwitch

#pragma mark Init

- (id)init
{
    self = [super init];
    
    if (self){
        
        AirTrafficSettingsDataSource *controller = [self airTrafficSettingsDataSource];
        
        if (controller){
            [controller setDelegate:self];
            [controller scanWakeableLibraries];
            
            for (id identifier in [controller hostIdentifiers]){
                [controller registerForProgressWithLibraryIdentifier:identifier];
            }
        }
    }
    
    return self;
}

#pragma mark Flipswitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
    AirTrafficSettingsDataSource *controller = [self airTrafficSettingsDataSource];
    
    if (controller){
        
        if ([controller syncing]){
            return FSSwitchStateOn;
        }
        
    }
    
    return FSSwitchStateIndeterminate;
}

- (void)applyActionForSwitchIdentifier:(NSString *)switchIdentifier
{
    AirTrafficSettingsDataSource *controller = [self airTrafficSettingsDataSource];
    
    if (controller){
        
        if (![controller syncing]){
            
            [controller scanWakeableLibraries];
            
            for (id identifier in [controller hostIdentifiers]){
                [controller registerForProgressWithLibraryIdentifier:identifier];
            }
            
            [controller requestSync];
            
        }
    }
    
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[self class]].bundleIdentifier];
}

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier
{
    return @"iTunes Sync";
}

#pragma mark AirTrafficSettingsDataSource

- (AirTrafficSettingsDataSource *)airTrafficSettingsDataSource
{
    dlopen("/System/Library/PreferenceBundles/AirTrafficSettings.bundle/AirTrafficSettings", RTLD_NOW);
    
    AirTrafficSettingsDataSource *controller = [%c(AirTrafficSettingsDataSource) sharedDataSource];
    
    if (!controller){
        controller = [[%c(AirTrafficSettingsDataSource) alloc] init];
    }
    
    [controller setDelegate:self];
    
    return controller;
}

#pragma mark AirTrafficSettingsDataSourceDelegate

- (void)dataSource:(id)arg1 updatedSyncingState:(BOOL)arg2
{
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[self class]].bundleIdentifier];
}

- (void)dataSource:(id)arg1 updatedConnectedState:(BOOL)arg2
{
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[self class]].bundleIdentifier];
}

- (void)dataSource:(id)arg1 updatedProgress:(id)arg2
{
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[self class]].bundleIdentifier];
}

@end
