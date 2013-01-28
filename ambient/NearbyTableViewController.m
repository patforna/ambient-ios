//
//  NearbyTableViewController.m
//  ambient
//
//  Created by Patric Fornasier on 23/01/2013.
//  Copyright (c) 2013 Patric Fornasier. All rights reserved.
//

#import "NearbyTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "CoreLocation/CoreLocation.h"

#define BASE_URL @"http://api.discoverambient.com"

@interface NearbyTableViewController()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation NearbyTableViewController

- (void)setNearby:(NSArray *)nearby {
    _nearby = nearby;
    [self.tableView reloadData];
}

- (CLLocationManager *)locationManager {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager startUpdatingLocation];
}

- (void)refresh:(CLLocationCoordinate2D) location {
    [self.spinner startAnimating];
    
    NSString *path = [NSString stringWithFormat:@"/search/nearby?location=%+.6f,%+.6f", location.latitude, location.longitude];
    NSLog(@"Calling %@\n", path);
    
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:path]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            self.nearby = [JSON objectForKey:@"nearby"];
            [self.spinner stopAnimating];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Unable to retrieve data from %@: %@", url, error);
        }];
    
    [operation start];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nearby count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nearby Cell"];
    
    NSDictionary *item = [self.nearby objectAtIndex:indexPath.row];
    cell.textLabel.text = [[item objectForKey:@"user"] valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m away", [item objectForKey:@"distance"]];
    return cell;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self refresh:manager.location.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Unable to retrieve location: %@\n", error);
}
@end






























