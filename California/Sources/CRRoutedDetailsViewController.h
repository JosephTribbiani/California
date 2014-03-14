//
//  CRRoutedDetailsViewController.h
//  California
//
//  Created by Igor Bogatchuk on 2/26/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRRoutedDetailsViewController : UIViewController

@property (nonatomic, copy) NSString *expectedTime;

@property (weak, nonatomic) IBOutlet UILabel *expectedTimeLabel;

@end
