#import <Foundation/Foundation.h>
#import "LoadUserProtocol.h"
#import "LoginProtocol.h"

@interface FBLoginService : NSObject <LoadUserProtocol>
@property(weak) id <LoginProtocol> delegate;
+ (BOOL)isLoggedIn;
+ (User *)getLoggedInUser;
- (void)login;
- (void)logout;
@end