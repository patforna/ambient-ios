@class User;

@protocol LoadUserProtocol <NSObject>

- (void)userLoaded:(User *)user;

- (void)failedToLoadUser:(NSError *)error;

@end