//
//  ViewController.m
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 11/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BackgroundLayer.h"
#import "UIStyler.h"
#import "VIPIssuer.h"
#import "Constants.h"
#import "Provisioner.h"
#import "SecondViewController.h"
#import "PersistenceFilesPathsProvider.h"
#import "ConfirmPersonalInformationViewController.h"

#define CELL_HEIGHT 40
#define CELL_NUMBER_OF_ROWS 2
#define RESIZE_DISTANCE_FACTOR 50
#define OK_ALERT_BUTTON 0

#define EMPTY_STRING = @"";

typedef enum {
    USER_NAME,
    PASSWORD
} TEXTFIELDS;

typedef enum {
    USERNAME_TAG = 1,
    PASSWORD_TAG = 2
} TAGS;

@interface ViewController () {
    TEXTFIELDS EditedTextField;
    TAGS Tag;
    UIActivityIndicatorView *_spinner;
    IBOutlet UIButton *resetButton;
}

- (BOOL) validate: (UITextField *)aTextField field: (TEXTFIELDS) aField;

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UITableView *loginTable;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, copy) NSString *tableHeader;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIAlertView *statusMessage;
@property (nonatomic, copy) NSString *activationCodeResponse;
@property (nonatomic, copy) NSString *authenticationStatusResponse;
@property (nonatomic, copy) NSString *validationResult;
@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) UIButton *resetButton;

@end

@implementation ViewController

@synthesize appDelegate;
@synthesize loginTable = _loginTable;
@synthesize logo = _logo;
@synthesize headerView = _headerView;
@synthesize tableHeader = _tableHeader;
@synthesize loginButton = _loginButton;
@synthesize username  = _username, password = _password;
@synthesize tapGesture  = _tapGesture;
@synthesize statusMessage = _statusMessage;
@synthesize processStatusLabel = _processStatusLabel;
@synthesize activationCodeResponse = _activationCodeResponse;
@synthesize authenticationStatusResponse = _authenticationStatusResponse;
@synthesize validationResult = _validationResult;
@synthesize status = _status;
@synthesize provisionedCredential;
@synthesize spinner;
@synthesize resetButton;

#pragma mark Encapsulation

#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView = [[UIView alloc] init];
    self.headerView.bounds = self.loginTable.bounds;
    return self.headerView;
}

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CELL_NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == nil){
     
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if(indexPath.row == 0){
        self.username = [UIStyler styleTextFieldForLoginTableWithTableCell:cell textIndicator:@"Usuario"];
        [self.username setTag:USERNAME_TAG];
        [self.username setSpellCheckingType:UITextSpellCheckingTypeNo];
        
        self.username.textColor = [UIColor lightGrayColor];  
        self.username.delegate = self;        
        
        [cell.contentView addSubview:self.username];
        [self.username release];
        
    }else if(indexPath.row == 1){
        
        self.password = [[UIStyler styleTextFieldForLoginTableWithTableCell:cell textIndicator:@"Contraseña"] autorelease];
        [self.password setTag:PASSWORD_TAG];

        self.password.textColor = [UIColor lightGrayColor];
        self.password.delegate = self;
        
        [cell.contentView addSubview:self.password];
    }

    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    return cell;
}

- (void) hideKeyboardAction:(id) sender
{
    [self performSelectorOnMainThread:@selector(tapAnyWhereAction:) withObject:self.username waitUntilDone:YES];
    [self performSelector:@selector(loginButtonAction:)];
}
- (void) loginButtonAction:(id)sender
{
    NSLog(@"user name count : %i %s" , [self.username retainCount], __PRETTY_FUNCTION__ );
    
    [self.loginButton addSubview:self.spinner];
    [self.spinner setCenter:CGPointMake(self.loginButton.bounds.size.width - 30, self.loginButton.bounds.size.height / 2)];
    [self.spinner startAnimating];
    
    BOOL valid = NO;
    NSString *msg = nil;
   
    
    if([self validate:self.username field:USER_NAME]){
        valid = NO;
        msg = @"El usuario no puede estar vacío";
        EditedTextField = USER_NAME;
        
    }else if([self validate:self.password field:PASSWORD]) {
        valid = NO;
        msg  = @"El password no puede estar vacío";
        EditedTextField = PASSWORD;
        
    }else {
        valid = YES;
        [self.appDelegate setUserName:self.username.text];
        [self.appDelegate setPassword:self.password.text];
    }
    
    if(valid){ //OKAY

        VIPIssuer *issuer = [[VIPIssuer alloc] init];
        [sender setTitle:@"Autenticando.." forState:UIControlStateNormal];        
        
        NSString *provisionedCredentialsPropertyListFilePath = [PersistenceFilesPathsProvider getVIPServicesSettingsFilePath];
        
        NSDictionary *savedDictionary = [NSDictionary dictionaryWithContentsOfFile:provisionedCredentialsPropertyListFilePath];
        
        NSString *savedCredentialId = [savedDictionary valueForKey:@"CredentialID"];
        NSString *savedSecret = [savedDictionary valueForKey:@"SharedSecret"];
        
        if(savedCredentialId && savedSecret){
            
//            @TODO CORREGIR ESTE FLUJO VALIDAR CREDENCIALES
//            NSDictionary *activationAuthenticationResponse = [issuer
//                                                              requestActivationCodeUsingCredentials:self.username.text password:self.password.text];
//            
//            if([[activationAuthenticationResponse valueForKey:ACTIVATION_CODE_KEY] isEqualToString:@"-1"]){
//                
//                msg = @"Error de autenticación";
//                
//                self.statusMessage = [[UIAlertView alloc]
//                                      initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Corregir" otherButtonTitles:nil];
//                
//                [self.statusMessage show];
//            }else { //valid user
//                [self.appDelegate setUserName:self.username.text];
//                [self.appDelegate setPassword:self.password.text];
//                
//                SecondViewController *scv = [[SecondViewController alloc]
//                                             initWithNibName:SECOND_VIEW_NIB_FILENAME bundle:nil];
//                
//                [self presentViewController:scv animated:YES completion:nil];
//            }
            


//            Credential *cred = [[Credential alloc]init];
//            [cred setCredId:savedCredentialId];
//            [cred setSecurityCode:[cred getSecurityCodeWithActivatedCredential]];
            
//            NSLog(@"setCredId (secret) %@", cred.credId);
//            NSLog(@"otp %@", cred.securityCode);
//            
//            NSLog(@"");
            
            
        }else {
            
            [self performSelectorOnMainThread:@selector(tapAnyWhereAction:) withObject:self.username waitUntilDone:YES];
            
            NSDictionary *activationAuthenticationResponse = [issuer
                                                              requestActivationCodeUsingCredentials:self.username.text password:self.password.text];
            
            if([[activationAuthenticationResponse valueForKey:ACTIVATION_CODE_KEY] isEqualToString:@"-1"]){
                
                msg = @"Error de autenticación";
                
                self.statusMessage = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Corregir" otherButtonTitles:nil];
                
                [self.statusMessage show];
            }else { //valid user
                [self.appDelegate setUserName:self.username.text];
                [self.appDelegate setPassword:self.password.text];
                [self showConfirmPersonalInformationViewController];
            }
        }
        
    }else {
        
        msg = @"Verificar campos";
        
        self.statusMessage = [[UIAlertView alloc]
                              initWithTitle:@"Advertencia" message:msg delegate:self cancelButtonTitle:@"Corregir" otherButtonTitles:nil];
        
        [self.statusMessage show];

    }


}

- (IBAction)resetApplicationValues:(id)sender
{
    NSString* settingsFilePath = [PersistenceFilesPathsProvider getVIPServicesSettingsFilePath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:settingsFilePath];
    
    if(prefs != nil && [prefs count] > 0){
        [prefs removeAllObjects];
    }
    
}

#pragma mark ViewController lifecicle

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
        
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.logo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 250, 256, 37)];
    [self.loginButton setTitle:@"Ingresar" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIColor *color = [UIColor colorWithRed:20.0f/255.0f green:87.0f/255.0f blue:121.0f/255.0f alpha:1.0];
    
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]]; 
    [self.loginButton setBackgroundColor:color];

    [self.loginButton.layer setBorderWidth:1.0f];
    [self.loginButton.layer setBorderColor:color.CGColor];
    [self.loginButton.layer setCornerRadius:4.0f];
    [self.loginButton.layer setBorderWidth:1.0f];
    
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];

    [self.processStatusLabel setText:@"adsfasdf"];
    [self.processStatusLabel setTextColor:[UIColor whiteColor]];
    [self.processStatusLabel setFont:[UIFont systemFontOfSize:12]];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnyWhereAction:)];

    self.tapGesture.delegate = self;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.username = nil;
}

- (void) dealloc
{
    [_loginTable release];
    [_headerView release];
    [_logo release];
    [_tableHeader release];
    [_loginButton release];
    [_username release];
    [_password release];
    [_tapGesture release];
    [_statusMessage release];
    [_spinner release];
    [_processStatusLabel release];
    [_validationResult release];
    [_provisionedCredential release];
    [super dealloc];
}

-(void) viewWillAppear:(BOOL)animated 
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-red-320x480.png"]];
    [self resetState];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UI Events

- (void) keyboardWillShow: (NSNotification *)keyboardNotification
{
    [self.view addGestureRecognizer:self.tapGesture];
    
    CGRect tableFrame = self.loginTable.frame;
    CGRect loginButtonFrame = self.loginButton.frame;
    
    tableFrame.origin.y -= RESIZE_DISTANCE_FACTOR;
    loginButtonFrame.origin.y -= RESIZE_DISTANCE_FACTOR;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.loginTable.frame = tableFrame;
    self.loginButton.frame = loginButtonFrame;
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *)keyboardNotification
{
    [self.view removeGestureRecognizer:self.tapGesture];
    
    CGRect tableFrame = self.loginTable.frame;
    CGRect loginButtonFrame = self.loginButton.frame;
    
    tableFrame.origin.y += RESIZE_DISTANCE_FACTOR;
    loginButtonFrame.origin.y += RESIZE_DISTANCE_FACTOR;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.loginTable.frame = tableFrame;
    self.loginButton.frame = loginButtonFrame;
    
    [UIView commitAnimations];
    
}

- (void) tapAnyWhereAction: (UIGestureRecognizer *) gesture
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}


#pragma mark TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{  
    //textField.text = self.username.text;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""]){

        textField.textColor = [UIColor lightGrayColor];
        
        if(textField.tag == USERNAME_TAG){
            self.username.text = @"Usuario";
        }else if(textField.tag == PASSWORD_TAG){
            self.password.text = @"Contraseña";
        }
        
    }else {
        
        if(textField.tag == USERNAME_TAG){
            [textField retain];
        }else if(textField.tag == PASSWORD_TAG){

        }
        
        textField.textColor = [UIColor blackColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == OK_ALERT_BUTTON){
        
        switch (EditedTextField) {
            case USER_NAME:              
                [self.username becomeFirstResponder];               
                break;
                
            case PASSWORD:
                [self.password becomeFirstResponder];
                break;
                
            default:
                break;
        }
        [self.spinner stopAnimating];
    }
}

#pragma mark Validators

- (BOOL) validate: (UITextField *)aTextField field: (TEXTFIELDS) aField
{
    BOOL valid;  
    switch (aField) {
        case USER_NAME:
            valid = aTextField.text.length > 0 && ![aTextField.text isEqualToString:@"Usuario"] ? YES : NO;

            break;
            
        case PASSWORD:
            valid = aTextField.text.length > 0 && ![aTextField.text isEqualToString:@"Contraseña"] ? YES : NO;

            break;
            
        default:
            break;
    }
    return !valid;
}

- (void) showConfirmPersonalInformationViewController
{
    ConfirmPersonalInformationViewController *cpivc = [[ConfirmPersonalInformationViewController alloc]
                                                       initWithNibName:@"ConfirmPersonalInformationViewController" bundle:nil];
    
    [self presentViewController:cpivc animated:YES completion:nil];
}

- (void) showSecondViewController
{
    SecondViewController *svc = [[SecondViewController alloc]initWithNibName:SECOND_VIEW_NIB_FILENAME bundle:nil];
    
    [self presentModalViewController:svc animated:YES];
    
    NSMutableString *loginMessage = [[NSMutableString alloc]initWithString:@""];
    [loginMessage appendFormat:@"\nUUID \n%@\nCódigo de seguridad - %@ ",
        self.validationResult,
        [self.appDelegate.credential getSecurityCode] ];
    
    [svc.sessionToken setText:loginMessage];
}

- (void) resetState
{
    [self.username setText:@""];
    [self.password setText:@""];
    [self.processStatusLabel setText:@""];
    [self.loginButton setTitle:@"Ingresar" forState:UIControlStateNormal];
    
    if(self.spinner != nil && [self.spinner isAnimating]){
        [self.spinner stopAnimating];
    }
    
    self.username.text = @"Usuario";
    self.username.textColor = [UIColor grayColor];
    
    self.password.text = @"Contraseña";
    self.password.textColor = [UIColor grayColor];
}

@end
