#import "UserService.h"
#import "AFNetworking.h"
#import "FBGraphUser.h"
#import "FBRequestConnection.h"
#import "FBRequest.h"
#import "FBSession.h"
#import "Constants.h"

@interface UserService ()
@property(strong, nonatomic) AFHTTPClient *httpClient;
@end

@implementation UserService

- (AFHTTPClient *)httpClient {
    if (_httpClient == nil) {
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [_httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    }

    return _httpClient;
}

- (void)loadUser {
    [self loadFBUserDetails]; // this bootstraps a chain of async calls and callbacks (see handleXXX)
}

- (void)loadFBUserDetails {
    if (!FBSession.activeSession.isOpen) {
        [self handleFailure:[self error:@"No active open session =("]];
        return;
    }

    NSLog(@"About to fetch user details...");
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *fbUser, NSError *error) {
        if (error) {
            [self handleFailure:error];
            return;
        }

        [self handleFBUserDetailsLoaded:fbUser];
    }];
}

- (void)loadUserFrom:(NSDictionary <FBGraphUser> *)fbUser {
    NSString *path = [NSString stringWithFormat:@"/users/search?fbid=%@", fbUser.id];
    NSLog(@"About to call: %@\n", path);

    [self.httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
        [self handleUserLoaded:[self extractUserFrom:json]];
    }                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (true) // TODO only if 404
            [self handleUserNotFound:fbUser];
        else
            [self handleFailure:error];
    }];
}

- (void)createUserFrom:(NSDictionary <FBGraphUser> *)fbUser {
    NSString *path = [NSString stringWithFormat:@"/users?first=%@&last=%@&fbid=%@", fbUser.first_name, fbUser.last_name, fbUser.id];
    NSLog(@"About to call: %@\n", path);

    [self.httpClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
        [self handleUserCreated:[self extractUserFrom:json]];
    }                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailure:error];
    }];
}

#pragma callbacks

- (void)handleFBUserDetailsLoaded:(NSDictionary <FBGraphUser> *)fbUser {
    NSLog(@"Got some data from FB: user.firstName = %@, user.lastName = %@, user.id = %@", fbUser.first_name, fbUser.last_name, fbUser.id);
    [self loadUserFrom:fbUser];
}

- (void)handleUserLoaded:(NSString *)user {
    NSLog(@"Successfully loaded user");
    [self.delegate userLoaded:user];
}

- (void)handleUserCreated:(NSString *)user {
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

#pragma helpers

- (id)extractUserFrom:(id)json {
    return [[json objectForKey:USER] valueForKey:ID];
}

- (NSError *)error:(NSString *)message {
    NSString *domain = @"com.discoverambient";
    NSString *desc = NSLocalizedString(message, @"");
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc};

    return [NSError errorWithDomain:domain code:nil userInfo:userInfo];
}


@end