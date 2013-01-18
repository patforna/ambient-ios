//
//  ViewController.h
//  ambient
//
//  Created by Patric Fornasier on 18/01/2013.
//  Copyright (c) 2013 Patric Fornasier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkeletonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSArray *skeletons;
@end
