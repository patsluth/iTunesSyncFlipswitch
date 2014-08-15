@protocol AirTrafficSettingsDataSourceDelegate <NSObject>

@optional

- (void)dataSource:(id)arg1 updatedSyncingState:(BOOL)arg2;
- (void)dataSource:(id)arg1 updatedConnectedState:(BOOL)arg2;
- (void)dataSource:(id)arg1 updatedProgress:(id)arg2;

@end




