//
//  AppDelegate.h
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 02/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provisioner.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

@property (nonatomic,retain) NSString *credentialId;
@property (nonatomic,retain) NSString *secret;
@property NSTimeInterval creationTime;
@property (nonatomic,retain) Credential *credential;

- (Status *) getCredentialStatusWithCredentialPrefix:(NSString *) prefix activationCode:(NSString *) activationCode;

@end
