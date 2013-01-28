//
//  NearbyTableViewController.h
//  ambient
//
//  Created by Patric Fornasier on 23/01/2013.
//  Copyright (c) 2013 Patric Fornasier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyTableViewController : UITableViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray * nearby;
@end
