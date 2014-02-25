//
//  CLTableViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/21/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRTableViewController.h"
#import "UIKit+AFNetworking.h"
#import "CRDetailTableViewCell.h"

@interface CRTableViewController ()
{
	NSArray* _images;
}
@property (nonatomic, readonly) NSArray* images;

@end

@implementation CRTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)images
{
	if (_images == nil)
	{
		NSArray* urls = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"urls" ofType:@"plist"]];
		NSMutableArray* mutableURLs = [NSMutableArray new];
		for (NSUInteger i = 0; i < 20; i++)
		{
			[mutableURLs addObjectsFromArray:urls];
		}
		_images = [NSArray arrayWithArray:mutableURLs];
	}
	return _images;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.images count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"DetailTableViewCell";
    CRDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	[cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
	cell.imageView.clipsToBounds = YES;
	[cell.imageView setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"Placeholder.jpg"]];
    
	NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};
	NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:self.images[indexPath.row] attributes:attributes];
	[cell.textView setAttributedText:attributedString];
    [cell setNeedsLayout];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return [CRDetailTableViewCell rowHeightForText:self.images[indexPath.row]];
}

@end
