//
//  CRPopoverTableController.h
//  California
//
//  Created by Igor Bogatchuk on 2/23/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRSelectLayoutTableViewControllerDelegate
- (void)horizontalLayoutDidSelect;
- (void)verticalLayoutDidSelect;
@end

@interface CRSelectLayoutTableViewController : UITableViewController

@property (nonatomic, weak) id<CRSelectLayoutTableViewControllerDelegate> delegate;

@end
