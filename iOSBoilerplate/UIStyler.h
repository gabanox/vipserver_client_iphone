//
//  UIStyler.h
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 13/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIStyler : NSObject

+ (UILabel *) styleLabel:(UILabel *) aLabel withColor:(UIColor *) aColor;

+ (UITextField *)styleTextFieldForLoginTableWithTableCell: (UITableViewCell *)aCell textIndicator: (NSString *)aLabel;
@end
