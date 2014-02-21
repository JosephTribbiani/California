//
//  CLDetailViewController.h
//  California
//
//  Created by Igor Bogatchuk on 2/21/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
