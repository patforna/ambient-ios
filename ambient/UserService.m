#import "UserService.h"
#import "AFNetworking.h"
#import "FBGraphUser.h"
#import "FBRequestConnection.h"
#import "FBRequest.h"
#import "FBSession.h"
#import "Constants.h"
#import "NSError+Extensions.h"
#import "AFHTTPClient+Extensions.h"
#import "NSString+Extensions.h"
#import "User.h"

@interface UserService ()
@property(strong, nonatomic) AFHTTPClient *httpClient;
@end

@implementation UserService

- (AFHTTPClient *)httpClient {
    if (_httpClient == nil) _httpClient = [AFHTTPClient forAmbient];
    return _httpClient;
}

- (void)loadUser {
    [self loadFBUserDetails]; // this bootstraps a chain of async calls and callbacks (see handleXXX)
}

- (void)loadFBUserDetails {
    if (!FBSession.activeSession.isOpen) {
        [self handleFailure:[NSError error:@"No active open session =("]];
        return;
    }

    NSLog(@"About to fetch user details...");
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *fbUser, NSError *error) {
        if (error) [self handleFailure:error]; else [self handleFBUserDetailsLoaded:fbUser];
    }];
}

- (void)loadUserFrom:(NSDictionary <FBGraphUser> *)fbUser {
    NSString *path = [NSString urlPath:USERS_SEARCH params:@{FBID : fbUser.id}];
    [self.httpClient get:path success:^(id json) {
        [self handleUserLoaded:[User from:json]];
    } failure:^(NSInteger *status, NSError *error) {
        if (status == NOT_FOUND) [self handleUserNotFound:fbUser]; else [self handleFailure:error];
    }];
}

- (void)createUserFrom:(NSDictionary <FBGraphUser> *)fbUser {
    NSString *path = [NSString urlPath:USERS params:@{FIRST : fbUser.first_name, LAST : fbUser.last_name, FBID : fbUser.id}];
    [self.httpClient post:path success:^(id json) {
        [self handleUserCreated:[User from:json]];
    } failure:^(NSInteger *status, NSError *error) {
        [self handleFailure:error];
    }];
}

#pragma callbacks

- (void)handleFBUserDetailsLoaded:(NSDictionary <FBGraphUser> *)fbUser {
    NSLog(@"Got some data from FB: user.firstName = %@, user.lastName = %@, user.id = %@", fbUser.first_name, fbUser.last_name, fbUser.id);
    [self loadUserFrom:fbUser];
}

- (void)handleUserLoaded:(User *)user {
    NSLog(@"Successfully loaded user");
    [self.delegate userLoaded:user];
}

- (void)handleUserCreated:(User *)user {
    NSLog(@"Successfully created user.");
    [self.delegate userLoaded:user];
}

- (void)handleUserNotFound:(NSDictionary <FBGraphUser> *)fbUser {
    NSLog(@"Unable to load user with fbid %@", fbUser.id);
    [self createUserFrom:fbUser];
}

- (void)handleFailure:(NSError *)error {
    [self.delegate failedToLoadUser:error];
}

@end