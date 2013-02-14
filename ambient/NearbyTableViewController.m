#import "AFNetworking.h"
#import "CoreLocation/CoreLocation.h"
#import "NearbyTableViewController.h"
#import "Constants.h"
#import "FBLoginService.h"
#import "AFHTTPClient+Extensions.h"
#import "Location.h"
#import "NSString+Extensions.h"
#import "ProfileViewController.h"

@interface NearbyTableViewController ()
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) AFHTTPClient *httpClient;
@property(strong, nonatomic) FBLoginService *fbLoginService;

@property(strong, nonatomic) Location *location;
@property(strong, nonatomic) NSArray *nearbyResults;
@end

@implementation NearbyTableViewController

- (CLLocationManager *)locationManager {
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

- (AFHTTPClient *)httpClient {
    if (_httpClient == nil) _httpClient = [AFHTTPClient forAmbient];
    return _httpClient;
}

- (FBLoginService *)fbLoginService {
    if (_fbLoginService == nil) _fbLoginService = [[FBLoginService alloc] init];
    return _fbLoginService;
}

- (void)setNearbyResults:(NSArray *)nearbyResults {
    _nearbyResults = nearbyResults;
    [self.tableView reloadData];
}

- (IBAction)logout:(id)sender {
    [self.fbLoginService logout];
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = true;
    [self.locationManager startUpdatingLocation];
    [self.refreshControl addTarget:self action:@selector(retrieveNearbyUsers) forControlEvents:UIControlEventValueChanged];
}

- (void)handleLocationUpdate {
    if (self.nearbyResults == nil) [self retrieveNearbyUsers];
    [self checkin];
}

- (void)retrieveNearbyUsers {
    [self.refreshControl beginRefreshing]; // manually show spinner, because it might be the first time we load

    NSString *path = [NSString urlPath:NEARBY_SEARCH params:@{ LOCATION : self.location }];
    [self.httpClient get:path success:^(id json) {
        self.nearbyResults = [json objectForKey:NEARBY];
    } failure:nil finally:^{
        [self.refreshControl endRefreshing];
    }];
}

- (void)checkin {
    NSString *path = [NSString urlPath:CHECKINS params:@{ USER_ID : [FBLoginService getLoggedInUser], LOCATION : self.location }];
    [self.httpClient post:path success:nil failure:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PROFILE_SEGUE]) {
        ProfileViewController *profileViewController = (ProfileViewController *) segue.destinationViewController;

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        NSDictionary *item = [self.nearbyResults objectAtIndex:indexPath.row];
        NSString *first = [[item objectForKey:USER] valueForKey:FIRST];
        NSString *last = [[item objectForKey:USER] valueForKey:LAST];
        NSString *user = [NSString stringWithFormat:@"%@ %@", first, last];
        
        profileViewController.user = user;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nearbyResults count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nearby Cell"];

    NSDictionary *item = [self.nearbyResults objectAtIndex:indexPath.row];
    NSString *first = [[item objectForKey:USER] valueForKey:FIRST];
    NSString *last = [[item objectForKey:USER] valueForKey:LAST];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", first, last];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m away", [item objectForKey:DISTANCE]];
    return cell;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [Location from:manager.location.coordinate];
    [self handleLocationUpdate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unable to retrieve location: %@\n", error);
}

@end






























