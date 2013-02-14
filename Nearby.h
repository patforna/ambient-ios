#import <Foundation/Foundation.h>
#import "User.h"

@interface Nearby : NSObject
+ (Nearby *)from:(id)json;

@property(strong, nonatomic) User *user;
@property(retain, nonatomic) NSNumber *distance;
@property(readonly, weak, nonatomic) NSString *distanceInWords;
@end