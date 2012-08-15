//
//  ViewController.m
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 11/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "ViewController.h"
#import "BackgroundLayer.h"
#import "UIStyler.h"
#import "Credential.h"

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
}

- (BOOL) validate: (UITextField *)aTextField field: (TEXTFIELDS) aField;


@property (nonatomic, retain) IBOutlet UITableView *loginTable;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, copy) NSString *tableHeader;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIAlertView *loginMessage;

@end

@implementation ViewController

@synthesize loginTable = _loginTable;
@synthesize headerView = _headerView;
@synthesize tableHeader = _tableHeader;
@synthesize loginButton = _loginButton;
@synthesize username  = _username, password = _password;
@synthesize tapGesture  = _tapGesture;
//@synthesize spinner = _spinner;
@synthesize loginMessage = _loginMessage;

#pragma mark Encapsulation

- (UIActivityIndicatorView *) spinner
{
    if(_spinner == nil){
        _spinner = [[[UIActivityIndicatorView alloc] 
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    }
    NSLog(@"spinner count : %i %s" , [_spinner retainCount], __PRETTY_FUNCTION__ );
    return _spinner;
}

- (void) setSpinner:(UIActivityIndicatorView *)spinner
{
    if(_spinner){
        [_spinner release];
        _spinner = [spinner retain];
    }
}

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
        self.username = [UIStyler styleTextFieldForLoginTableWithTableCell:cell textIndicator:@"Usuario"]; //rc 1
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

- (void) loginButtonAction:(id)sender
{
    NSLog(@"user name count : %i %s" , [self.username retainCount], __PRETTY_FUNCTION__ );

    [self.loginButton addSubview:self.spinner];
    [self.spinner setCenter:CGPointMake(self.loginButton.bounds.size.width - 30, self.loginButton.bounds.size.height / 2)];
    BOOL valid = NO;
    NSString *msg = @"";
    NSLog(@"%@", self.username.text);     
    
    if([self validate:self.username field:USER_NAME]){
        valid = NO;
        msg = [NSString stringWithString:@"El usuario no puede estar vacío"];
        EditedTextField = USER_NAME;
        
    }else if([self validate:self.password field:PASSWORD]) {
        valid = NO;
        msg = [NSString stringWithString:@"El password no puede estar vacío"];
        EditedTextField = PASSWORD;
        
    }else {
        valid = YES;
    }
    
    if(valid){ //OKAY
        NSLog(@"username count %i", [self.username retainCount]);        
        msg = [NSString stringWithFormat:@"\nUsuario : %@ Contraseña: %@", self.username.text, self.password.text];
        NSLog(@"username count %i", [self.username retainCount]);        
//       loginMessage = [[UIAlertView alloc] 
//                       initWithTitle:@"Login" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];        
//        
//        [loginMessage show];
        NSLog(@"%@", msg);
        
        NSString *oneTimePassword = @"1341234134";
        NSString *tokenId = @"XXX1341234";
        
        Credential *credential = [[Credential alloc]
                                  initCredentialWithToken:tokenId otp:oneTimePassword userName:self.username.text password:self.password.text];
        
        
        
        [self.spinner startAnimating];
    }else {
        self.loginMessage = [[UIAlertView alloc] 
                        initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Corregir" otherButtonTitles:nil];        
     
        [self.loginMessage show];
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
        
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 239, 256, 37)];
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
    [_tableHeader release];
    [_loginButton release];
    [_username release];
    [_password release];
    [_tapGesture release];
    [_loginMessage release];
    [_spinner release];
    [super dealloc];
}

-(void) viewWillAppear:(BOOL)animated 
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-red-320x480.png"]];
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
        NSLog(@"username count %i", [self.username retainCount]);    
    [self.username resignFirstResponder];
        NSLog(@"username count %i", [self.username retainCount]);    
    [self.password resignFirstResponder];
}


#pragma mark TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
        NSLog(@"username count %i", [self.username retainCount]);    
    textField.text = self.username.text;
        NSLog(@"username count %i", [self.username retainCount]);    
    NSLog(@"textFieldDidBeginEditing %@", textField.text);
    NSLog(@"%i", [textField retainCount]);
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];           
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
        NSLog(@"textFieldDidEndEditing %@", textField.text);
        NSLog(@"%i", [textField retainCount]);
    if([textField.text isEqualToString:@""]){

        textField.textColor = [UIColor lightGrayColor];
        
        if(textField.tag == USERNAME_TAG){
        NSLog(@"username count %i", [self.username retainCount]);            
            self.username.text = @"Usuario";   
        NSLog(@"username count %i", [self.username retainCount]);            
        }else if(textField.tag == PASSWORD_TAG){
            self.password.text = @"Contraseña";
        }
        
    }else {
        
//        if(textField.tag == USERNAME_TAG){
        NSLog(@"username count %i", [self.username retainCount]);        
            [textField retain];
        NSLog(@"username count %i", [self.username retainCount]);        
            
//        }else if(textField.tag == PASSWORD_TAG){
//            
//        }
        
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
        NSLog(@"username count %i", [self.username retainCount]);                
                [self.username becomeFirstResponder];
        NSLog(@"username count %i", [self.username retainCount]);                
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
        NSLog(@"username count %i", [self.username retainCount]);    
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

@end
