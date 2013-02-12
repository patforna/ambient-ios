#import "FBLoginService.h"
#import "UserService.h"
#import "FBSession.h"
#import "NSError+NSErrorExtensions.h"

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

+ (BOOL)isLoggedIn {
    return FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded;
}

- (void)login {
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChangedState:state error:error];
    }];
}

- (void)logout {
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
    [self handleLoginFailed:[NSError error:@"Facebook Login failed."]];
}

- (void)handleSessionError:(NSError *)error {
    NSLog(@"FB Session state changed error: %@", error);
    [self handleLoginFailed:error];
}

- (void)handleLoginSuccessful:(NSString *)user {
    [self.delegate loginSuccessful:user];
}

- (void)handleLoginFailed:(NSError *)error {
    [self logout];
    [self.delegate loginFailed:error];
}

# pragma mark LoadUserProtocol
- (void)userLoaded:(NSString *)user {
    [self handleLoginSuccessful:user];
}

- (void)failedToLoadUser:(NSError *)error {
    [self handleLoginFailed:error];
}

@end