#import "ProfileViewController.h"
#import "AFNetworking.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.name;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"Loading pic: %@", [self.user pictureOfSize:self.image.bounds.size]);
    [self.image setImageWithURL:[NSURL URLWithString:[self.user pictureOfSize:self.image.bounds.size]]];
}

@end
