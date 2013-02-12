#import "AFNetworking.h"
#import "CoreLocation/CoreLocation.h"
#import "NearbyTableViewController.h"
#import "Constants.h"

@interface NearbyTableViewController()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) AFHTTPClient* httpClient;
@property (strong, nonatomic) NSArray * nearbyResults;
@end

@implementation NearbyTableViewController

- (void) setNearbyResults:(NSArray*) nearbyResults {
    _nearbyResults = nearbyResults;
    [self.tableView reloadData];
}

- (CLLocationManager*) locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = 10; //movement threshold for new events
        _locationManager.activityType = CLActivityTypeFitness;
        _locationManager.pausesLocationUpdatesAutomatically = true;
    }
    return _locationManager;
}

- (AFHTTPClient*) httpClient {
    if (_httpClient == nil) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    
    return _httpClient;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    [self.locationManager startUpdatingLocation];
}

- (void) handleLocationUpdate:(CLLocationCoordinate2D) location {
    if (self.nearbyResults == nil) [self retrieveNearbyUsers:location];
    [self checkin:location];
}

- (void) retrieveNearbyUsers:(CLLocationCoordinate2D) location {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
    
    NSURL* url = [self urlFor:NEARBY_SEARCH:location];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSLog(@"About to retrieve nearby users error: %@\n", url);
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest* request, NSHTTPURLResponse* response, id json) {
            self.nearbyResults = [json objectForKey:NEARBY];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
        }
        failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id json) {
            NSLog(@"Unable to retrieve nearby users: %@", error.localizedDescription);
        }];
    
    [operation start];
}

- (void) checkin:(CLLocationCoordinate2D) location {
    NSString *path = [NSString stringWithFormat:@"/checkins?user_id=%@&location=%+.6f,%+.6f", self.user, location.latitude, location.longitude];
    NSLog(@"About to call: %@\n", path);

    [self.httpClient postPath:path parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {}
    failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Unable to check in: %@", error.localizedDescription);
    }];
}

- (NSURL*) urlFor:(NSString*) path :(CLLocationCoordinate2D) location {
    NSString* url = [NSString stringWithFormat:@"%@%@?location=%+.6f,%+.6f", BASE_URL, path, location.latitude, location.longitude];
    return [NSURL URLWithString:url];
}

#pragma mark - Table view data source
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.nearbyResults count];
}

#pragma mark - Table view delegate
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Nearby Cell"];
    
    NSDictionary* item = [self.nearbyResults objectAtIndex:indexPath.row];
    NSString *first = [[item objectForKey:USER] valueForKey:FIRST];
    NSString *last = [[item objectForKey:USER] valueForKey:LAST];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", first, last];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m away", [item objectForKey:DISTANCE]];
    return cell;
}

#pragma mark - CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager*) manager didUpdateLocations:(NSArray*) locations {
    [self handleLocationUpdate:manager.location.coordinate];
}

- (void) locationManager:(CLLocationManager*) manager didFailWithError:(NSError*) error {
	NSLog(@"Unable to retrieve location: %@\n", error);
}
@end






























