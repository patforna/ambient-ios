#import "AFNetworking.h"
#import "CoreLocation/CoreLocation.h"
#import "NearbyTableViewController.h"

#define BASE_URL @"http://api.discoverambient.com/"

@interface NearbyTableViewController()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) AFHTTPClient* httpClient;
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
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10; //movement threshold for new events
        _locationManager.activityType = CLActivityTypeFitness;
        _locationManager.pausesLocationUpdatesAutomatically = true;
    }
    return _locationManager;
}

- (AFHTTPClient*) httpClient {
    if (_httpClient == nil) {
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    }
    
    return _httpClient;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.locationManager startUpdatingLocation];
}

- (void) handleLocationUpdate:(CLLocationCoordinate2D) location {
    if (self.nearbyResults == nil) [self retrieveNearbyUsers:location];
    [self checkin:location];
}

- (void) retrieveNearbyUsers:(CLLocationCoordinate2D) location {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
    
    NSURL* url = [self urlFor:@"search/nearby":location];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSLog(@"About to retrieve nearby users from: %@\n", url);
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest* request, NSHTTPURLResponse* response, id JSON) {
            self.nearbyResults = [JSON objectForKey:@"nearby"];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
        }
        failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON) {
            NSLog(@"Unable to retrieve nearby users: %@", error.localizedDescription);
        }];
    
    [operation start];
}

- (void) checkin:(CLLocationCoordinate2D) location {
    NSURL* url = [self urlFor:@"checkins":location];
    NSLog(@"About to check in to: %@\n", url);
    
    [self.httpClient postPath:[url relativeString] parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {}
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
    cell.textLabel.text = [[item objectForKey:@"user"] valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m away", [item objectForKey:@"distance"]];
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






























