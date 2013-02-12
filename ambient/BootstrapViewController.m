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
        ((LoginViewController *) segue.destinationViewController).delegate = self;
    }
}

# pragma mark LoginProtocol
- (void)loginSuccessful {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
