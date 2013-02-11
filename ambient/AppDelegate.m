#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

#define BASE_URL @"http://api.discoverambient.com"

@implementation AppDelegate

- (AFHTTPClient*) httpClient {
    if (_httpClient == nil) {
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [_httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return _httpClient;
}


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
            [self handleSessionOpen];
        } break;
        case FBSessionStateClosed:
            NSLog(@"FB Session closed.");
            break;
        case FBSessionStateClosedLoginFailed:
            [self handleLoginFailed:@"Login failed"];
            break;
        default:
            break;
    }
    
    if (error) {
        [self handleLoginFailed:error.localizedDescription];
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

- (void) handleSessionOpen {
    [self fetchUserDetails]; // FIXME move    
}

- (void) handleLoginSuccessful:(NSString *)user {
    self.user = user;
    NSLog(@"Login successful. Userid: %@", user);
    [self segueTo:@"NearbySegue"];
}

- (void) handleLoginFailed:(NSString *)errorMessage {
    [FBSession.activeSession closeAndClearTokenInformation];
    NSLog(@"Login failed. Error: %@", errorMessage);
    [self showLoginScreen];
}

- (void) showLoginScreen {
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    [navigationController popToRootViewControllerAnimated:false];
}

- (void) showError:(NSString *)errorMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops..." message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void) segueTo:(NSString *)segueId {
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    [navigationController.topViewController performSegueWithIdentifier:segueId sender:nil];
}


#pragma mark FB personalisation

- (void) fetchUserDetails {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"About to fetch user details...");
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
             if (!error) {
                 NSLog(@"Got some data from FB: user.firstName = %@, user.lastName = %@, user.id = %@", fbUser.first_name, fbUser.last_name, fbUser.id);
                 [self loadOrCreateUserFrom:fbUser];
             } else {
                [self handleLoginFailed:[NSString stringWithFormat:@"Error retrieving user details: %@", error.localizedDescription]];
             }
         }];
    } else {
        [self handleLoginFailed:@"No active open session =("];
    }
}

- (void) loadOrCreateUserFrom:(NSDictionary<FBGraphUser> *)fbUser {
    NSString* path = [NSString stringWithFormat:@"/users/search?fbid=%@", fbUser.id];
    NSLog(@"About to call: %@\n", path);

    [self.httpClient getPath:path parameters:nil
        success:^(AFHTTPRequestOperation* operation, id json) {
            NSLog(@"Successfully loaded user");
            NSString *user = [[json objectForKey:@"user"] valueForKey:@"id"];
            [self handleLoginSuccessful:user];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            // TODO check for 404
            NSLog(@"Unable to load user: %@. Will try to create next.", error.localizedDescription);
            [self createUserFrom:fbUser];
        }
     ];
}

- (void) createUserFrom:(NSDictionary<FBGraphUser> *)fbUser {
    NSString *path = [NSString stringWithFormat:@"/users?first=%@&last=%@&fbid=%@", fbUser.first_name, fbUser.last_name, fbUser.id];
    NSLog(@"About to call: %@\n", path);
  
    [self.httpClient postPath:path parameters:nil
        success:^(AFHTTPRequestOperation* operation, id json) {
            NSLog(@"Successfully created user.");
            NSString *user = [[json objectForKey:@"user"] valueForKey:@"id"];
            [self handleLoginSuccessful:user];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [self handleLoginFailed:[NSString stringWithFormat:@"Unable to create user: %@", error.localizedDescription]];
        }
    ];
}


@end
