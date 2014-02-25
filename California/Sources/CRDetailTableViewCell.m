//
//  CLDetailTableViewCell.m
//  California
//
//  Created by Igor Bogatchuk on 2/22/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRDetailTableViewCell.h"

@implementation CRDetailTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.imageView setFrame:CGRectMake(0, 0, 768, 370)];
	[self.textView setFrame:CGRectMake(0, 371, 768, 46)];
}

+ (CGFloat)rowHeightForText:(NSString*)text
{
	NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};
    
    if (IS_IOS7_AND_UP)
    {
       CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(760, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)  attributes:attributes context:nil];
        return boundingRect.size.height + 370 + 20;
    }
    else
    {
       CGSize boundingSize = [text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(760.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return boundingSize.height + 370 + 30;
       
    }
}

@end
