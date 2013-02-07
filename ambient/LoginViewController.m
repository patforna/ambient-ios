#import "LoginViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation LoginViewController

- (IBAction) performLogin:(id)sender {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate loginUsingFacebook];
}

- (IBAction)performLogout:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void) loginFailed { // FIXME currently unused
    NSLog(@"Login failed.");
}

@end
