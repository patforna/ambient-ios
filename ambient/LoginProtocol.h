@protocol LoginProtocol <NSObject>

@optional
- (void)loginSuccessful:(NSString *)user;

@optional
- (void)loginFailed:(NSError *)error;

@end