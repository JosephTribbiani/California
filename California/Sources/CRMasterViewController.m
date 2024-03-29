//
//  CLMasterViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/21/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRMasterViewController.h"
#import "CRUpdateUI.h"

@interface CRMasterViewController()

@property (nonatomic, strong) UIViewController* detailViewConroller;
@property (nonatomic, strong) UIPopoverController* popOverController;

@end

@implementation CRMasterViewController

- (void)awakeFromNib
{
	self.splitViewController.delegate = self;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
	    self.clearsSelectionOnViewWillAppear = NO;
        if (IS_IOS7_AND_UP)
        {
            self.preferredContentSize = CGSizeMake(320.0, 600.0);
        }   
	}
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    footerView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSDictionary*)tableViewMap
{
	return @{@(0): @"Table",
             @(1): @"Collection",
             @(2): @"Map"};
}

- (UIViewController*)detailViewConroller
{
	return [[[self.splitViewController viewControllers] lastObject] topViewController];
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self tableViewMap] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MasteViewControlerCell" forIndexPath:indexPath];
	cell.textLabel.text = NSLocalizedString([[self tableViewMap] objectForKey:@(indexPath.row)], @"");
	return cell;
}

#pragma mark - TableViewDelegate

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	UIBarButtonItem* navigationButton = [[self.detailViewConroller navigationItem] leftBarButtonItem];
	
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:nil];
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
	[self performSegueWithIdentifier:[[self tableViewMap] objectForKey:@(indexPath.row)] sender:self];
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:navigationButton];
}

#pragma mark - SplitView Delegate

- (void)splitViewController:(UISplitViewController*)splitController willHideViewController:(UIViewController*)viewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)popoverController
{
	barButtonItem.title = NSLocalizedString(@"Master", @"Master");
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
    
    if ([self.detailViewConroller conformsToProtocol:@protocol(CRUpdateUI)])
    {
        [(id<CRUpdateUI>)(self.detailViewConroller) updateUI];
    }
}

- (void)splitViewController:(UISplitViewController*)splitController willShowViewController:(UIViewController*)viewController invalidatingBarButtonItem:(UIBarButtonItem*)barButtonItem
{
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:nil animated:YES];
    
    if ([self.detailViewConroller conformsToProtocol:@protocol(CRUpdateUI)])
    {
        [(id<CRUpdateUI>)(self.detailViewConroller) updateUI];
    }
}

- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController*)aViewController
{
    self.popOverController = pc;
}

@end
