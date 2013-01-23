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

@synthesize skeletons = _skeletons;

- (void)setSkeletons:(NSArray *)skeletons
{
    _skeletons = skeletons;
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.navigationItem.rightBarButtonItem = sender;
        self.skeletons = JSON;
    } failure:nil];
    
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.skeletons count];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nearby Cell"];
    
    NSDictionary *skeleton = [self.skeletons objectAtIndex:indexPath.row];
    cell.textLabel.text = [skeleton valueForKey:@"name"];
    cell.detailTextLabel.text = [skeleton valueForKey:@"job"];
    return cell;
}

@end
