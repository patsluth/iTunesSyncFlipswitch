#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"

#import <dlfcn.h>

#import "AirTrafficSettingsDataSource.h"
#import "AirTrafficSettingsDataSourceDelegate.h"

#import <Preferences/Preferences.h>

@interface iTunesSyncSwitch : NSObject <FSSwitchDataSource, AirTrafficSettingsDataSourceDelegate>
{
}

@property (readwrite, nonatomic) NSInteger syncAttempts;
@property (strong, nonatomic) NSTimer *attemptToSyncTimer;

@end

@implementation iTunesSyncSwitch

#pragma mark Init

- (id)init
{
    self = [super init];

    if (self){
        [self killAttempToSyncTimer];
    }
    
    return self;
}

#pragma mark Flipswitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
    AirTrafficSettingsDataSource *controller = [self airTrafficSettingsDataSource];
    
    if (controller){
        if ([controller waitingToSync] || [controller syncing] || self.attemptToSyncTimer){
            return FSSwitchStateOn;
        }
    }

	return FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
    AirTrafficSettingsDataSource *controller = [self airTrafficSettingsDataSource];
    
    if (controller){

        [controller scanWakeableLibraries];
        
        //handle new state
        if (newState == FSSwitchStateOff){

            [self killAttempToSyncTimer];
            
            [controller unregisterForProgress];
            [controller cancelSync];

        } else if (newState == FSSwitchStateOn){

            if (![controller syncing] && ![controller waitingToSync]){
                if (!self.attemptToSyncTimer){
                    self.attemptToSyncTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(attemptToSync)
                                               userInfo:nil
                                                repeats:YES];
                }
            }

        }
    }
}

#pragma mark AirTrafficSettingsDataSource

- (void)attemptToSync
{
    AirTrafficSettingsDataSource *controller = [self airTrafficSettingsDataSource];
    self.syncAttempts++;
    
    if (self.syncAttempts > 10){
        [self killAttempToSyncTimer];
        
        [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[self class]].bundleIdentifier];
        
        [[[UIAlertView alloc] initWithTitle:@"Couldn't Sync"
                                message:@"There was a problem trying to sync to iTunes. Please ensure you are connected to your iTunes library"
                               delegate:self
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil] show];

        return;
    }

    if (controller){
        if ([controller waitingToSync] || [controller syncing]){
            [self killAttempToSyncTimer];
        } else {
            if (controller){

                for (id identifier in [controller hostIdentifiers]){
                    [controller registerForProgressWithLibraryIdentifier:identifier];
                    [controller requestSync];
                }
                
                [controller requestSync];
            }
        }
    }
}

- (void)killAttempToSyncTimer
{
    self.syncAttempts = 0;
    
    if (self.attemptToSyncTimer){
        [self.attemptToSyncTimer invalidate];
        self.attemptToSyncTimer = nil;
    }
}

- (AirTrafficSettingsDataSource *)airTrafficSettingsDataSource
{
    dlopen("/System/Library/PreferenceBundles/AirTrafficSettings.bundle/AirTrafficSettings", RTLD_LAZY);
    
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

%ctor
{
}