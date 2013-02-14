#import "BootstrapViewController.h"
#import "Constants.h"
#import "FBLoginService.h"
#import "LoginViewController.h"

@implementation BootstrapViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([FBLoginService isLoggedIn]) {
        NSLog(@"Already logged in.");
        [self performSegueWithIdentifier:NEARBY_SEGUE sender:self];
    } else {
        [self performSegueWithIdentifier:LOGIN_SEGUE sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:LOGIN_SEGUE]) {
        LoginViewController *loginViewController = (LoginViewController *) segue.destinationViewController;
        loginViewController.delegate = self;
        [loginViewController resetView];

    }
}

# pragma mark LoginProtocol
- (void)loginSuccessful {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
