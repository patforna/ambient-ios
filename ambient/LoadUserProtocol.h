@protocol LoadUserProtocol <NSObject>

@optional
- (void)userLoaded:(NSString *)user;

@optional
- (void)failedToLoadUser:(NSError *)error;

@end