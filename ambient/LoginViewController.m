#import "LoginViewController.h"
#import "FBLoginService.h"

@interface LoginViewController ()
@property(strong, nonatomic) FBLoginService *fbLoginService;
@end

@implementation LoginViewController

- (FBLoginService *)fbLoginService {
    if (_fbLoginService == nil) {
        _fbLoginService = [[FBLoginService alloc] init];
        _fbLoginService.delegate = self;
    }
    return _fbLoginService;
}

- (IBAction)performLogin:(id)sender {
    [self.fbLoginService login];
}

# pragma mark LoginProtocol
- (void)loginSuccessful {
    NSLog(@"Login successful.");
    [self.delegate loginSuccessful];
}

- (void)loginFailed:(NSError *)error {
    NSLog(@"Login failed. Error: %@", error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops..." message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alertView show];
}

@end
