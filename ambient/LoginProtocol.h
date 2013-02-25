@protocol LoginProtocol <NSObject>

- (void)loginSuccessful:(id)sender;
- (void)loginFailed:(NSError *)error;

@end