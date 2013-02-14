#import "AFHTTPClient+Extensions.h"
#import "AFNetworking.h"
#import "Constants.h"

@implementation AFHTTPClient (Extensions)
+ (AFHTTPClient *)forAmbient {
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    return httpClient;
}

- (void)get:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self get:path success:success failure:failure finally:nil];
}

- (void)get:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure finally:(FinallyBlock)finally {
    NSLog(@"GET: %@%@\n", BASE_URL, path);
    [self showNetworkActivityIndicator];

    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
        [self hideNetworkActivityIndicator]; // FIXME DRY
        if (success) success(json);
        if (finally) finally();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"GET %@%@ failed: %@\n", BASE_URL, path, error.localizedDescription);
        [self hideNetworkActivityIndicator];
        if (failure) failure(operation.response.statusCode, error);
        if (finally) finally();
    }];
}

- (void)post:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSLog(@"POST: %@%@\n", BASE_URL, path);
    [self showNetworkActivityIndicator]; // FIXME DRY

    [self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
        if (success) success(json);
        [self hideNetworkActivityIndicator]; // FIXME DRY
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"POST %@%@ failed: %@\n", BASE_URL, path, error.localizedDescription);
        [self hideNetworkActivityIndicator]; // FIXME DRY
        if (failure) failure(operation.response.statusCode, error);
    }];
}

- (void) showNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
}

- (void) hideNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
}

@end