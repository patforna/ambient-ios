#import <UIKit/UIKit.h>
#import "LoadUserProtocol.h"
#import "LoginProtocol.h"

@interface LoginViewController : UIViewController <LoginProtocol>
@property(weak) id <LoginProtocol> delegate;
@end
