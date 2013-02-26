#import "User.h"
#import "Constants.h"
#import "FBSession.h"
#import "NSString+Extensions.h"

@implementation User
+ (User *)from:(id)json {
    User *user = [[User alloc] init];
    user.id = [[json objectForKey:USER] valueForKey:ID];
    user.first = [[json objectForKey:USER] valueForKey:FIRST];
    user.last = [[json objectForKey:USER] valueForKey:LAST];
    user.picture = [[json objectForKey:USER] valueForKey:PICTURE];

    return user;
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.first, self.last];
}

- (NSString *)pictureOfSize:(CGSize)size {
    NSNumber * width = [NSNumber numberWithInt:size.width * [UIScreen mainScreen].scale];
    NSNumber * height = [NSNumber numberWithInt:size.height * [UIScreen mainScreen].scale];
    NSString * accessToken = FBSession.activeSession.accessToken;

    return [NSString urlPath:self.picture params:@{WIDTH : width, HEIGHT : height, ACCESS_TOKEN : accessToken}];
}

@end