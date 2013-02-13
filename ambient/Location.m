#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@implementation Location

+ (Location *)from:(CLLocationCoordinate2D)coordinate {
    Location *location = [[Location alloc] init];
    location.latitude = coordinate.latitude;
    location.longitude = coordinate.longitude;
    return location;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%.6f,%.6f", self.latitude, self.longitude];
}

@end