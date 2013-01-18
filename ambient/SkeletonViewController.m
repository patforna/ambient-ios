//
//  ViewController.m
//  ambient
//
//  Created by Patric Fornasier on 18/01/2013.
//  Copyright (c) 2013 Patric Fornasier. All rights reserved.
//

#import "SkeletonViewController.h"
#import "AFJSONRequestOperation.h"

@interface SkeletonViewController()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SkeletonViewController

@synthesize skeletons = _skeletons;
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
    
    NSURL *url = [NSURL URLWithString:@"http://ambient-api.herokuapp.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.skeletons = [JSON valueForKey:@"name"];
        [self.tableView reloadData];
    } failure:nil];
    
    [operation start];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.skeletons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SkeletonCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.skeletons objectAtIndex:indexPath.row];
    return cell;
}

@end
