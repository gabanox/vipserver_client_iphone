//
//  ViewController.h
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 11/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> 
{
    UIView *loginHeaderView;
}

@end
