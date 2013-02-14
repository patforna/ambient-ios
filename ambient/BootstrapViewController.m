#import "BootstrapViewController.h"
#import "Constants.h"
#import "FBLoginService.h"
#import "LoginViewController.h"

@interface BootstrapViewController()
@property(strong, nonatomic) FBLoginService *fbLoginService;
@end

@implementation BootstrapViewController

- (FBLoginService *)fbLoginService {
    if (_fbLoginService == nil) {
        _fbLoginService = [[FBLoginService alloc] init];
        _fbLoginService.delegate = self;
    }
    return _fbLoginService;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([FBLoginService isLoggedIn]) {
        NSLog(@"Already logged in.");
        [self.fbLoginService login];
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
    [self performSegueWithIdentifier:NEARBY_SEGUE sender:self];
}

@end
