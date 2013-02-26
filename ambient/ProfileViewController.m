#import "ProfileViewController.h"
#import "UIImageView+Extensions.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.name;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.imageView loadImage:[self.user pictureOfSize:self.imageView.bounds.size] finally:^{[self.spinner stopAnimating];}];
}

@end
