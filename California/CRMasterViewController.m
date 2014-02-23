//
//  CLMasterViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/21/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRMasterViewController.h"

@interface CRMasterViewController()
@property (nonatomic, retain) UIViewController *detailViewConroller;
@end

@implementation CRMasterViewController

- (void)awakeFromNib
{
	self.splitViewController.delegate = self;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.preferredContentSize = CGSizeMake(320.0, 600.0);
	}
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSDictionary *)tableViewMap
{
	return @{@(0): @"Table",
				@(1): @"Collection",
				@(2): @"Map"};
}

- (UIViewController *)detailViewConroller
{
	return [[[self.splitViewController viewControllers] lastObject] topViewController];
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self tableViewMap] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasteViewControlerCell" forIndexPath:indexPath];
	cell.textLabel.text = NSLocalizedString([[self tableViewMap] objectForKey:@(indexPath.row)], @"");
	return cell;
}

#pragma mark - TableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIBarButtonItem *navigationButton = [[self.detailViewConroller navigationItem] leftBarButtonItem];
	
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:nil];
	[self performSegueWithIdentifier:[[self tableViewMap] objectForKey:@(indexPath.row)] sender:self];
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:navigationButton];
}

#pragma mark - SplitView Delegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
	barButtonItem.title = NSLocalizedString(@"Master", @"Master");
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[[self.detailViewConroller navigationItem] setLeftBarButtonItem:nil animated:YES];
}

@end
