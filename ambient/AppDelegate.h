#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) AFHTTPClient* httpClient; // FIXME

- (void)loginUsingFacebook;

@end
