//
//  UIStyler.m
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 13/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "UIStyler.h"

@implementation UIStyler

+ (UILabel *) styleLabel:(UILabel *) aLabel withColor:(UIColor *) aColor
{
    aLabel.textColor = aColor;
    return aLabel;
}

+ (UITextField *)styleTextFieldForLoginTableWithTableCell: (UITableViewCell *)aCell textIndicator: (NSString *)aLabel
{
CGRect position = CGRectMake(8, 3, aCell.bounds.size.width -80, aCell.bounds.size.height - 10);
UITextField *tf = [[[UITextField alloc] initWithFrame:position] autorelease];
tf.textAlignment = UITextAlignmentLeft;
tf.text = aLabel;
tf.textColor = [UIColor lightGrayColor];
tf.clearsOnBeginEditing = YES;
tf.borderStyle = UITextBorderStyleNone;

return tf;
}


@end
