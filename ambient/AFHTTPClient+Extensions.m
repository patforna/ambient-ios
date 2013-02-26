#import "AFHTTPClient+Extensions.h"
#import "AFNetworking.h"
#import "Constants.h"

static NSString *const GET = @"GET";
static NSString *const POST = @"POST";

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
    [self execute:GET path:path success:success failure:failure finally:finally];
}

- (void)post:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self execute:POST path:path success:success failure:failure finally:nil];
}

#pragma private
- (void)execute:(NSString *)method path:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure finally:(FinallyBlock)finally {
    NSLog(@"%@: %@%@\n", method, BASE_URL, path);
    showNetworkActivityIndicator();

    NSURLRequest *request = [self requestWithMethod:method path:path parameters:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id json) {
        if (success) success(json);
        hideNetworkActivityIndicator();
        if (finally) finally();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@%@ failed: %@\n", method, BASE_URL, path, error.localizedDescription);
        hideNetworkActivityIndicator();
        if (failure) failure(operation.response.statusCode, error);
        if (finally) finally();
    }];

    [self enqueueHTTPRequestOperation:operation];
}

static void showNetworkActivityIndicator() {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
}

static void hideNetworkActivityIndicator() {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
}

@end