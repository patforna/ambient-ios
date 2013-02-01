#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyTableViewController : UITableViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray * nearbyResults;
@end
