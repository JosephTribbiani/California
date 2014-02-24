//
//  CRPopoverTableController.m
//  California
//
//  Created by Igor Bogatchuk on 2/23/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRSelectLayoutTableViewController.h"

@interface CRSelectLayoutTableViewController ()

@end

@implementation CRSelectLayoutTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
	{
		[self.delegate horizontalLayoutDidSelect];
	}
	else
	{
		[self.delegate verticalLayoutDidSelect];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
