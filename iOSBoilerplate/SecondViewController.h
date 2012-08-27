//
//  SecondViewController.h
//  iOSBoilerplate
//
//  Created by Gabriel on 24/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController {
    
    UILabel *_mainLabel;
    UIButton *_backButton;
    UILabel *_sessionToken;
    UILabel *_credentialId;
}

@property (nonatomic, retain) UILabel *mainLabel;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) IBOutlet UILabel *sessionToken;
@property (nonatomic, retain) IBOutlet UILabel *credentialId;

@end
