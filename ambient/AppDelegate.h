#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// must implement this in order to use storyboard
@property(strong, nonatomic) UIWindow *window;

// the logged in user
@property(strong, nonatomic) NSString *user;

@end
