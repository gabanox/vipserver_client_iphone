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

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIView *_networkUnavailable;
    ConfirmPersonalInformationViewController *_confirmViewController;
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    BOOL connectivity;
}

@property (nonatomic, retain) UIView *networkUnavailable;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) ConfirmPersonalInformationViewController *confirmViewController;
@property (nonatomic,retain) NSString *credentialId;
@property (nonatomic,retain) NSString *secret;
@property NSTimeInterval creationTime;
@property (nonatomic,retain) Credential *credential;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) BOOL connectivity;

- (Status *) getCredentialStatusWithCredentialPrefix:(NSString *) prefix activationCode:(NSString *) activationCode;
@end
