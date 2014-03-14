//
//  CRRoutedDetailsViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/26/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRRoutedDetailsViewController.h"

@interface CRRoutedDetailsViewController ()

@end

@implementation CRRoutedDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.expectedTimeLabel setText:self.expectedTime];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
