@interface AirTrafficSettingsDataSource : NSObject {

	//ATConnection* _connection;
	//ATWakeupCall* _wakeupCall;
	NSString* _libraryIdentifier;
	NSMutableSet* _connectedLibraries;
	NSMutableSet* _wakeableLibraries;
	NSMutableSet* _wakingLibraries;
	NSMutableSet* _librariesWaitingToSync;
	NSMutableSet* _syncingLibraries;
	NSTimer* _waitingForSyncTimer;
	unsigned _backgroundTaskIdentifier;
	BOOL _registered;
	NSDictionary* _lastProgressDict;
}

+ (id)sharedDataSource;
- (id)hostIdentifiers;
- (BOOL)waitingToSync;
- (BOOL)syncing;
- (BOOL)waitingToWake;
- (id)hostForIdentifier:(id)arg1;
- (id)hostsWaitingToWake;
- (void)scanWakeableLibraries;
- (void)registerForProgressWithLibraryIdentifier:(id)arg1;
- (void)unregisterForProgress;
- (void)stopScanningWakeableLibraries;
- (void)unregisterConnectionIfUnused;
- (void)syncTimeoutExpired;
- (id)initWithLibraryIdentifier:(id)arg1;
- (BOOL)isWifiEnabled;
- (void)connection:(id)arg1 updatedProgress:(id)arg2;
- (void)dealloc;
- (void)setDelegate:(id)arg1;
- (id)init;
- (id)delegate;
- (id)connection;
- (void)cancelSync;
- (BOOL)connected;
- (void)connectionWasInterrupted:(id)arg1;
- (void)requestSync;

@end




