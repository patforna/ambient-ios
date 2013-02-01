#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate()
- (BOOL) isLoggedIn;
@end

@implementation AppDelegate

#pragma mark UIApplicationDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setNetworkActivityIndicatorVisible:true];
    
    if ([self isLoggedIn]) {
        NSLog(@"Already logged in");
        [self handleLoginSuccess];
    }
    return YES;
}

// handle the facebook login callback
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

// handle activation of app
- (void) applicationDidBecomeActive:(UIApplication *)application	{
    // TODO: need to properly handle activation of the application with regards to SSO
    [FBSession.activeSession handleDidBecomeActive];
}

#pragma mark Facebook Login

- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"Login successful.");
            [self handleLoginSuccess];
        } break;
        case FBSessionStateClosed:
            NSLog(@"Session closed.");
            break;
        case FBSessionStateClosedLoginFailed:
            NSLog(@"Login failed.");
            [FBSession.activeSession closeAndClearTokenInformation];            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];        
    }
}

- (void) loginUsingFacebook {
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

- (void) handleLoginSuccess {    
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    [navigationController.topViewController performSegueWithIdentifier:@"NearbySegue" sender:self];
}

#pragma mark private

- (BOOL) isLoggedIn {
    return FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded;
}

@end
