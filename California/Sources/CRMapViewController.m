//
//  CLMapViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/22/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRMapViewController.h"
#import "CRAnnotation.h"

#define OCEAN_PLAZA_LATITUDE 50.412316
#define OCEAN_PLAZA_LONGITUDE 30.522562

@interface CRMapViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation CRMapViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
	
	self.mapView.delegate = self;
	[self updateMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMapView
{
	CRAnnotation *oceanPlasaAnnotation = [[CRAnnotation alloc] initWithLatitude:OCEAN_PLAZA_LATITUDE longitude:OCEAN_PLAZA_LONGITUDE title:@"Ocean Plasa" subtitle:@"Welcome to Ocean Plasa"];
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self.mapView addAnnotations:@[oceanPlasaAnnotation]];
	
	[self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

@end
