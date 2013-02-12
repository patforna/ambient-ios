@protocol LoginProtocol <NSObject>

@optional
- (void)loginSuccessful;

@optional
- (void)loginFailed:(NSError *)error;

@end