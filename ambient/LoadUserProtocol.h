@class User;

@protocol LoadUserProtocol <NSObject>

@optional
- (void)userLoaded:(User *)user;

@optional
- (void)failedToLoadUser:(NSError *)error;

@end