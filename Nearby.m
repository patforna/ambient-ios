#import "Nearby.h"
#import "Constants.h"

@implementation Nearby
+ (Nearby *)from:(id)json {
    Nearby *nearby = [[Nearby alloc] init];
    nearby.user = [User from:json];
    nearby.distance = [json objectForKey:DISTANCE];
    return nearby;
}

- (NSString *)distanceInWords {
    return [NSString stringWithFormat:@"%@m away", self.distance];
}
@end