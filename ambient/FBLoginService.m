#import "FBLoginService.h"
#import "UserService.h"
#import "FBSession.h"
#import "NSError+Extensions.h"
#import "AppDelegate.h"

@interface FBLoginService ()
@property(nonatomic, strong) UserService *userService;
@end

@implementation FBLoginService

- (UserService *)userService {
    if (_userService == nil) {
        _userService = [[UserService alloc] init];
        _userService.delegate = self;
    }
    return _userService;
}

+ (BOOL)isAuthenticated {
    return (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded
            || FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended);
}

+ (User *)getLoggedInUser {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]).user;
}

- (void)login {
    if ([FBLoginService getLoggedInUser]) // skip login if we already loaded the user
        [self fireLoginSuccessful];
    else
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChangedState:state error:error];
        }];
}

- (void)logout {
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).user = nil;
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)sessionStateChangedState:(FBSessionState)state error:(NSError *)error {

    switch (state) {
        case FBSessionStateOpen:
            if (!error) [self handleSessionOpen];
            break;
        case FBSessionStateClosed:
            [self handleSessionStateClosed];
            break;
        case FBSessionStateClosedLoginFailed:
            [self handleSessionLoginFailed];
            break;
        default:
            break;
    }

    if (error) [self handleSessionError:error];
}

- (void)handleSessionOpen {
    NSLog(@"FB Session opened.");
    [self.userService loadUser];
}

- (void)handleSessionStateClosed {
    NSLog(@"FB Session closed.");
}

- (void)handleSessionLoginFailed {
    NSLog(@"FB Session Login failed");
    [self fireLoginFailed:[NSError error:@"Facebook Login failed."]];
}

- (void)handleSessionError:(NSError *)error {
    NSLog(@"FB Session state changed error: %@", error);
    [self fireLoginFailed:error];
}

- (void)fireLoginSuccessful {
    [self.delegate loginSuccessful:self];
}

- (void)fireLoginFailed:(NSError *)error {
    [self logout];
    [self.delegate loginFailed:error];
}

# pragma mark LoadUserProtocol
- (void)userLoaded:(User *)user {
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).user = user;
    [self fireLoginSuccessful];
}

- (void)failedToLoadUser:(NSError *)error {
    [self fireLoginFailed:error];
}

@end