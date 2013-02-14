#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController
@property(nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
