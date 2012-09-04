//
//  AppDelegate.h
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 02/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provisioner.h"
#import "ConfirmPersonalInformationViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    ConfirmPersonalInformationViewController *_confirmViewController;
}
	
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) ConfirmPersonalInformationViewController *confirmViewController;
@property (nonatomic,retain) NSString *credentialId;
@property (nonatomic,retain) NSString *secret;
@property NSTimeInterval creationTime;
@property (nonatomic,retain) Credential *credential;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

- (Status *) getCredentialStatusWithCredentialPrefix:(NSString *) prefix activationCode:(NSString *) activationCode;
@end
