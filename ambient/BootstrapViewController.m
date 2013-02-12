#import "BootstrapViewController.h"
#import "Constants.h"
#import "FBLoginService.h"
#import "LoginViewController.h"
#import "NearbyTableViewController.h"

@interface BootstrapViewController ()
@property(strong, nonatomic) FBLoginService *fbLoginService;
@property(strong, nonatomic) NSString *user;
@end

@implementation BootstrapViewController

- (FBLoginService *)fbLoginService {
    if (_fbLoginService == nil) {
        _fbLoginService = [[FBLoginService alloc] init];
        _fbLoginService.delegate = self;
    }
    return _fbLoginService;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([FBLoginService isLoggedIn]) {
        NSLog(@"Already logged in.");
        [self.fbLoginService login];
    } else {
        [self performSegueWithIdentifier:LOGIN_SEGUE sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:LOGIN_SEGUE]) {
        ((LoginViewController *) segue.destinationViewController).delegate = self;
    }

    if ([segue.identifier isEqualToString:NEARBY_SEGUE]) {
        ((NearbyTableViewController *) segue.destinationViewController).user = self.user;
    }
}

# pragma mark LoginProtocol
- (void)loginSuccessful:(NSString *)user {
    self.user = user;
    [self dismissViewControllerAnimated:false completion:nil];
    [self performSegueWithIdentifier:NEARBY_SEGUE sender:self];
}

@end
