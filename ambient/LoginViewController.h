#import <UIKit/UIKit.h>
#import "LoadUserProtocol.h"
#import "LoginProtocol.h"

@interface LoginViewController : UIViewController <LoginProtocol>
@property(weak) id <LoginProtocol> delegate;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;

- (void)resetView;
@end
