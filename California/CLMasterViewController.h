//
//  CLMasterViewController.h
//  California
//
//  Created by Igor Bogatchuk on 2/21/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLDetailViewController;

@interface CLMasterViewController : UITableViewController

@property (strong, nonatomic) CLDetailViewController *detailViewController;

@end
