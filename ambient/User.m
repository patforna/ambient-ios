#import "User.h"
#import "Constants.h"

@implementation User
+ (User *)from:(id)json {
    User *user = [[User alloc] init];
    user.id = [[json objectForKey:USER] valueForKey:ID];
    user.first = [[json objectForKey:USER] valueForKey:FIRST];
    user.last = [[json objectForKey:USER] valueForKey:LAST];

    return user;
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.first, self.last];
}

@end