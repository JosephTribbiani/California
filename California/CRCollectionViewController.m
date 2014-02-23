//
//  CLCollectionViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/21/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRCollectionViewController.h"
#import "CRCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CRCollectionViewController() <UISplitViewControllerDelegate>
{
	NSArray *_images;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectLayoutButton;
@property (nonatomic, retain, readonly) NSArray *images;
@property (nonatomic, retain) UIPopoverController *selectLayoutPopover;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end

@implementation CRCollectionViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setHorizontalLayoutAnimated:NO];
	self.splitViewController.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSArray *)images
{
	if (_images == nil)
	{
		NSArray *urls = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"urls" ofType:@"plist"]];
		NSMutableArray *mutableURLs = [NSMutableArray new];
		for (NSUInteger i = 0; i < 20; i++)
		{
			[mutableURLs addObjectsFromArray:urls];
		}
		_images = [NSArray arrayWithArray:mutableURLs];
	}
	return _images;
}

#pragma mark - Collection View Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
	[cell.imageView setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"Placeholder.jpg"]];
	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
	if ([[segue identifier]isEqualToString:@"SelectLayout"])
	{
		[self.selectLayoutButton setEnabled:NO];
		CRSelectLayoutTableViewController *destinationViewController = [segue destinationViewController];
		destinationViewController.delegate = self;
		self.selectLayoutPopover = [(UIStoryboardPopoverSegue*)segue popoverController];
	}
}

#pragma mark - SelectLayout Delegate

- (void)horizontalLayoutDidSelect
{
	[self setHorizontalLayoutAnimated:YES];
	[self.selectLayoutPopover dismissPopoverAnimated:YES];
	[self.selectLayoutButton setEnabled:YES];
}

- (void)verticalLayoutDidSelect
{
	[self setVerticalLayoutAnimated:YES];
	[self.selectLayoutPopover dismissPopoverAnimated:YES];
	[self.selectLayoutButton setEnabled:YES];
}

#pragma mark - SplitView Delegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
	[self updateScrollLayout];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[self updateScrollLayout];
}

#pragma mark -

- (void)setHorizontalLayoutAnimated:(BOOL)animated
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	
	if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
	{
		layout.itemSize = CGSizeMake(360, 220);
	}
	else
	{
		layout.itemSize = CGSizeMake(365, 225);
	}
	
	layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	[self.collectionView setCollectionViewLayout:layout animated:animated];
	self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)setVerticalLayoutAnimated:(BOOL)animated
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	
	if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
	{
		layout.itemSize = CGSizeMake(335, 195);
	}
	else
	{
		layout.itemSize = CGSizeMake(365, 225);
	}
	
	layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	[self.collectionView setCollectionViewLayout:layout animated:animated];
	self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (void)updateScrollLayout
{
	if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
	{
		[self setVerticalLayoutAnimated:NO];
	}
	else
	{
		[self setHorizontalLayoutAnimated:NO];
	}
}

@end
