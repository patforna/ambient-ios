#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

#pragma mark UIApplicationDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([self isLoggedIn]) {
        NSLog(@"Already logged in.");
        [self loginUsingFacebook];
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

#pragma mark FB Login

- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"FB Session opened.");
            [self handleLoginSuccess];
        } break;
        case FBSessionStateClosed:
            NSLog(@"FB Session closed.");
            break;
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FB Login failed.");
            [self handleLoginFailure];
            break;
        default:
            break;
    }
    
    if (error) {
        [self showLoginScreen];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops..." message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];        
    }
}

- (void) loginUsingFacebook {
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

- (BOOL) isLoggedIn {
    return FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded;
}

- (void) handleLoginSuccess {
    [self fetchUserDetails]; // FIXME move
    [self segueTo:@"NearbySegue"];
}

- (void) handleLoginFailure {
    [FBSession.activeSession closeAndClearTokenInformation];
    [self showLoginScreen];
}

- (void) showLoginScreen {
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    [navigationController popToRootViewControllerAnimated:false];
}

- (void) segueTo:(NSString *)segueId {
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    [navigationController.topViewController performSegueWithIdentifier:segueId sender:self];
}


#pragma mark FB personalisation

- (void) fetchUserDetails {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"About to fetch user details...");
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                NSLog(@"user.firstName = %@, user.lastName = %@, user.id = %@", user.first_name, user.last_name, user.id);
             } else {
                NSLog(@"Error retrieving user details: %@", error.localizedDescription);
                [self handleLoginFailure];
             }
         }];
    } else {
        NSLog(@"No active open session =(");
        [self handleLoginFailure];        
    }
}

@end
