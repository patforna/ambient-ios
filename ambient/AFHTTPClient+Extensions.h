#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

typedef void (^SuccessBlock)(id response);
typedef void (^FailureBlock)(NSInteger *status, NSError *error);
typedef void (^FinallyBlock)();

@interface AFHTTPClient (Extensions)
+ (AFHTTPClient *)forAmbient;
- (void)get:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)get:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure finally:(FinallyBlock)finally;
- (void)post:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure;
@end