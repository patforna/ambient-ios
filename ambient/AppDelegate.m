#import "AppDelegate.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

// handle FB login callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

// handle activation of app
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSession.activeSession handleDidBecomeActive];
}

// handle termination of app
- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
}

@end
