#import "ProfileViewController.h"
#import "AFNetworking.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.name;
    [self.image setImageWithURL:[NSURL URLWithString:self.user.picture]];
}

@end
