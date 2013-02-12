#import <Foundation/Foundation.h>
#import <FacebookSDK/FBGraphUser.h>
#import "LoadUserProtocol.h"

@interface UserService : NSObject

@property(weak) id <LoadUserProtocol> delegate;

- (void)loadUser;

@end