//
//  CLDetailTableViewCell.h
//  California
//
//  Created by Igor Bogatchuk on 2/22/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imageVIew;
@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (CGFloat)rowHeightForText:(NSString *)text;

@end
