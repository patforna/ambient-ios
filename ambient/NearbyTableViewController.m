#import "AFNetworking.h"
#import "CoreLocation/CoreLocation.h"
#import "NearbyTableViewController.h"
#import "Constants.h"
#import "FBLoginService.h"

@interface NearbyTableViewController()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) AFHTTPClient* httpClient;
@property (strong, nonatomic) FBLoginService *fbLoginService;

@property (nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSArray * nearbyResults;
@end

@implementation NearbyTableViewController

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

- (FBLoginService *)fbLoginService {
    if (_fbLoginService == nil) _fbLoginService = [[FBLoginService alloc] init];
    return _fbLoginService;
}

- (void) setNearbyResults:(NSArray*) nearbyResults {
    _nearbyResults = nearbyResults;
    [self.tableView reloadData];
}

- (IBAction)logout:(id)sender {
    [self.fbLoginService logout];
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = true;
    [self.locationManager startUpdatingLocation];
    [self.refreshControl addTarget:self action:@selector(retrieveNearbyUsers) forControlEvents:UIControlEventValueChanged];
}

- (void) handleLocationUpdate {
    if (self.nearbyResults == nil) [self retrieveNearbyUsers];
    [self checkin];
}

- (void) retrieveNearbyUsers {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
    [self.refreshControl beginRefreshing]; // manually show spinner, because it might be the first time we load

    NSURL* url = [self urlFor:NEARBY_SEARCH:self.location];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSLog(@"About to retrieve nearby users error: %@\n", url);
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest* request, NSHTTPURLResponse* response, id json) {
            self.nearbyResults = [json objectForKey:NEARBY];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];  // FIXME DRY
            [self.refreshControl endRefreshing];   // FIXME DRY
        }
        failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id json) {
            NSLog(@"Unable to retrieve nearby users: %@", error.localizedDescription);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];  // FIXME DRY
            [self.refreshControl endRefreshing];   // FIXME DRY
        }];
    
    [operation start];
}

- (void) checkin {
    NSString *path = [NSString stringWithFormat:@"/checkins?user_id=%@&location=%+.6f,%+.6f", [FBLoginService getLoggedInUser], self.location.latitude, self.location.longitude];
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
    self.location = manager.location.coordinate;
    [self handleLocationUpdate];
}

- (void) locationManager:(CLLocationManager*) manager didFailWithError:(NSError*) error {
	NSLog(@"Unable to retrieve location: %@\n", error);
}
@end






























