//
//  SecondViewController.m
//  iOSBoilerplate
//
//  Created by Gabriel on 24/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "SecondViewController.h"
#import "PersistenceFilesPathsProvider.h"
#import "Constants.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize mainLabel, backButton, sessionToken, credentialId;

- (void) dealloc
{
    [self.mainLabel release];
    [self.backButton release];
    [self.sessionToken release];
    [self.credentialId release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mainLabel setText:@"Acceso a recursos de la aplicación"];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 300, 256, 37)];
    [self.backButton setTitle:@"Salir" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIColor *color = [UIColor colorWithRed:20.0f/255.0f green:87.0f/255.0f blue:121.0f/255.0f alpha:1.0];
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    [self.backButton setBackgroundColor:color];
    
    [self.backButton.layer setBorderWidth:1.0f];
    [self.backButton.layer setBorderColor:color.CGColor];
    [self.backButton.layer setCornerRadius:4.0f];
    [self.backButton.layer setBorderWidth:1.0f];
    
    [self.backButton addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.backButton];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *provisionedCredentialsPropertyListFilePath = [PersistenceFilesPathsProvider getVIPServicesSettingsFilePath];
    
    if ([fileManager fileExistsAtPath: provisionedCredentialsPropertyListFilePath] == YES) {
     
        NSMutableDictionary *savedDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:provisionedCredentialsPropertyListFilePath];
        
        if(savedDictionary && [savedDictionary count] > 0){
            self.credentialId.text = [savedDictionary objectForKey:CREDENTIAL_ID];
        }
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-red-320x480.png"]];
}

-(void) logoutButtonAction: (id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
