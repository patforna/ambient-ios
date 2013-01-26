//
//  NearbyTableViewController.m
//  ambient
//
//  Created by Patric Fornasier on 23/01/2013.
//  Copyright (c) 2013 Patric Fornasier. All rights reserved.
//

#import "NearbyTableViewController.h"
#import "AFJSONRequestOperation.h"

#define BASE_URL @"http://api.discoverambient.com"

@implementation NearbyTableViewController

@synthesize nearby = _nearby;

- (void)setNearby:(NSArray *)nearby
{
    _nearby = nearby;
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"/search/nearby?location=51.515874,-0.125613"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.navigationItem.rightBarButtonItem = sender;
        self.nearby = [JSON objectForKey:@"nearby"];
    } failure:nil];
    
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nearby count];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nearby Cell"];
    
    NSDictionary *item = [self.nearby objectAtIndex:indexPath.row];
    cell.textLabel.text = [[item objectForKey:@"user"] valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m away", [item objectForKey:@"distance"]];
    return cell;
}

@end
