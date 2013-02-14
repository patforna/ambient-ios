@protocol LoginProtocol <NSObject>

@optional
- (void)loginSuccessful:(id)sender;

@optional
- (void)loginFailed:(NSError *)error;

@end