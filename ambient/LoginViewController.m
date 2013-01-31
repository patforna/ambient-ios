#import "LoginViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccess:) name:@"LoginSuccessful" object:nil];
}

- (IBAction) performLogin:(id)sender {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (IBAction)performLogout:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void) handleLoginSuccess:(NSNotification *)pNotification {
    [self performSegueWithIdentifier: @"ShowNearbySegue" sender: self];
}

- (void) loginFailed { // FIXME currently unused
    NSLog(@"Login failed.");
}

@end
