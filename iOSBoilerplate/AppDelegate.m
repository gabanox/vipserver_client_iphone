//
//  AppDelegate.m
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 02/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Credential.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize credentialId;
@synthesize secret;
@synthesize creationTime;
@synthesize credential;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

#pragma mark Aplication lifecicle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Application support methods

- (Status *) getCredentialStatusWithCredentialPrefix:(NSString *) prefix activationCode:(NSString *) activationCode
{

    Provisioner *provisioner = [[Provisioner alloc] initWithURL:VIP_SERVICES_AUTHENTICATION_URL];
    Credential *c = nil;
    Status *status = [provisioner getCredential:prefix activationCode:activationCode credential:&c];
    status.credential = c;
    [provisioner release];
    if(c != nil){
        self.credentialId = c.credId;
        self.secret = c.sharedSecret;
        self.creationTime = c.creationTime;
        
        [c release];
        [self generateSecurityCode];
        [self performSelector:@selector(generateSecurityCode) withObject:nil afterDelay:30];
        [self performSelector:@selector(generateSecurityCode) withObject:nil afterDelay:60];
        
    }
    else{
//        NSLog(@"Codigo del error: %@", status.statusCode);
//        NSLog(@"Mensaje de error: %@", status.statusMessage);
    }
    return status;
}

- (void)generateSecurityCode{
	if(self.credential == nil){
		Credential *temp =  [[Credential alloc] initWithValues:self.credentialId secret:self.secret creationTime:self.creationTime];
		self.credential = temp;
		[temp release];
		NSLog(@"Credential id :%@",credential.credId);
	}
	NSLog(@"Security Code : %@",[self.credential getSecurityCode]);
}


@end
