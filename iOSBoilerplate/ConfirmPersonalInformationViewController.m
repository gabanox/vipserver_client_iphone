//
//  ConfirmPersonalInformationViewController.m
//  iOSBoilerplate
//
//  Created by Gabriel on 28/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfirmPersonalInformationViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ViewController.h"
#import "Constants.h"
#import "SecurityDigest.h"
#import "Provisioner.h"
#import "VIPIssuer.h"
#import "PersistenceFilesPathsProvider.h"
#import "SecondViewController.h"

typedef enum {
    FULLCREDITCARDNUMBER = 1,
    CREDITCARDSECURITYCODE = 2,
    POSTALCODE = 3,
    BIRTHDATE = 4
} TEXTFIELD_BEING_EDITED_TAG;

@interface ConfirmPersonalInformationViewController () {
    TEXTFIELD_BEING_EDITED_TAG textfieldLastEdited;
    NSString *hashSecret;
}

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) Status *status;
@property (nonatomic, copy) NSString *activationCodeResponse;
@property (nonatomic, copy) NSString *validationResult;
@property (nonatomic, retain) UIAlertView *statusMessage;
@property (nonatomic, copy) NSString *hashSecret;

@end

@implementation ConfirmPersonalInformationViewController

@synthesize appDelegate;
@synthesize fullCreditCardNumberLabel;
@synthesize confirmationMessage;
@synthesize creditCardSecurityCodeLabel;
@synthesize postalCodeLabel;
@synthesize birthDateLabel;
//@synthesize birthdateButton;
@synthesize fullCreditCardNumber, creditCardSecurityCode, birthDate, postalCode;
@synthesize keyboardToolbar;
@synthesize scrollView;
@synthesize datePicker;
@synthesize navigationBar;
@synthesize hashSecret;

- (void) dealloc
{
    [fullCreditCardNumber release];
    [creditCardSecurityCode release];
    [birthDate release];
    [postalCode release];
    [confirmationMessage release];
    [fullCreditCardNumberLabel release];
    [confirmationMessage release];
    [creditCardSecurityCodeLabel release];
    [postalCodeLabel release];
    [birthDateLabel release];
//    [birthdateButton release];
    [keyboardToolbar release];
    [datePicker release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


#pragma mark View controller lifeciclle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   	self.confirmationMessage.text = @"Proporcionar la siguiente información";
    
    self.fullCreditCardNumberLabel.text = @"Su número de tarjeta";
    [self.fullCreditCardNumberLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    
    self.creditCardSecurityCodeLabel.text = @"Código de seguridad";
    [self.creditCardSecurityCodeLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    
    self.birthDateLabel.text = @"Seleccionar fecha de nacimiento";
    [self.birthDateLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    
    self.postalCodeLabel.text = @"C.P.";
    [self.postalCodeLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    navigationBar.tintColor = [UIColor clearColor];
    
    [self.view addSubview:navigationBar];
    

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Guardar"
                                                                    style:UIBarButtonSystemItemSave target:nil action:@selector(saveDataAction:)];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(cancelOperation:)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Ingresar"];
    
    item.rightBarButtonItem = rightButton;
    item.leftBarButtonItem = leftButton;

    [navigationBar pushNavigationItem:item animated:NO];
    [rightButton release];
    [leftButton release];
    
    [item release];

}

- (void)viewDidUnload
{
    [self setConfirmationMessage:nil];
    [self setFullCreditCardNumberLabel:nil];
    [self setConfirmationMessage:nil];
    [self setCreditCardSecurityCodeLabel:nil];
    [self setPostalCodeLabel:nil];
    [self setBirthDateLabel:nil];
//    [self setBirthdateButton:nil];
    [self setKeyboardToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [[[UIColor alloc]
                                  initWithPatternImage:[UIImage imageNamed:@"bg-red-320x480.png"]] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.keyboardToolbar setHidden:YES];
    
    self.fullCreditCardNumber.tag = FULLCREDITCARDNUMBER;
    self.creditCardSecurityCode.tag = CREDITCARDSECURITYCODE;
    self.postalCode.tag = POSTALCODE;
    self.birthDate.tag = BIRTHDATE;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Action listeners

- (void) confirmInformationAction: (id) sender
{
    NSLog(@"confirmInformationAction");
}

- (void) saveDataAction: (id) sender
{

    NSLocale *locale = [[[NSLocale alloc]
                           initWithLocaleIdentifier:@"es_ES"] autorelease];
    
    NSDate *pickerDate = [datePicker date];
    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@",
                                 [pickerDate descriptionWithLocale:locale]];
    
    NSTimeInterval when = [pickerDate timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%f", when];
    NSString *fullCreditCard = self.fullCreditCardNumber.text;
    NSString *securityCode = self.creditCardSecurityCode.text;
    NSString *postalCodeString = self.postalCode.text;
    
    NSMutableString *salt = [NSMutableString stringWithString:intervalString];
                             [salt appendString:fullCreditCard];
                             [salt appendString:securityCode];
                             [salt appendString:postalCodeString];
                            
                             NSLog(@"Generating salt for hashing %@", salt);
    
    [selectionString release];
    
    self.hashSecret = [SecurityDigest sha1:salt];
    UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Crear firma usando la informacion propocionada?"
                                                    message:hashSecret
                                                    delegate:self
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:@"Cancelar", nil];
    [msg show];
    
}

- (void) cancelOperation: (id)sender
{
    ViewController *vc = [[ViewController alloc]initWithNibName:FIRST_VIEW_NIB_FILENAME bundle:nil];
    [vc resetState];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)hideKeyboard:(id)sender
{
    for (UIView *subview in self.view.subviews)
    {
        if([subview isKindOfClass:[UITextField class]]){
            if ([subview isFirstResponder]) {
                [(UITextField *)subview resignFirstResponder];
            }
        }
        
        if([[(UIBarButtonItem *)sender title] isEqualToString:@"Ok"]){
            [self.fullCreditCardNumber becomeFirstResponder];
            [self.fullCreditCardNumber resignFirstResponder];
        }
    }    
}

- (IBAction)backButtonPressed:(id)sender
{
    switch (textfieldLastEdited) {
        case CREDITCARDSECURITYCODE:
            [self.fullCreditCardNumber becomeFirstResponder];
            break;
            
        case POSTALCODE:
            [self.creditCardSecurityCode becomeFirstResponder];
            break;
            
        case BIRTHDATE:
            [self.postalCode becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

- (IBAction)nextButtonPressed:(id)sender
{
    switch (textfieldLastEdited) {
        case FULLCREDITCARDNUMBER:
            [self.creditCardSecurityCode becomeFirstResponder];
            break;
            
        case CREDITCARDSECURITYCODE:
            [self.postalCode becomeFirstResponder];
            break;
            
        case POSTALCODE:
            [self.datePicker becomeFirstResponder];
            break;
            
        default:
            break;
    }
}


#pragma mark Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect frame = self.keyboardToolbar.frame;
	frame.origin.y = self.view.frame.size.height - 260.0;
	self.keyboardToolbar.frame = frame;
    [self.keyboardToolbar setHidden:NO];
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect frame = self.keyboardToolbar.frame;
	frame.origin.y = self.view.frame.size.height;
	self.keyboardToolbar.frame = frame;
	
	[UIView commitAnimations];
}

#pragma mark TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
        
    if(textField == self.fullCreditCardNumber){
        [self.fullCreditCardNumber becomeFirstResponder];
        textfieldLastEdited = FULLCREDITCARDNUMBER;
        
    }else if(textField == self.creditCardSecurityCode){
        
        [self.creditCardSecurityCode becomeFirstResponder];
        textfieldLastEdited = CREDITCARDSECURITYCODE;
    }else if(textField == self.postalCode){
        
        [self.postalCode becomeFirstResponder];
        textfieldLastEdited = POSTALCODE;
    }else if(textField == self.birthDate){
     
        [self.birthDate becomeFirstResponder];
        textfieldLastEdited = BIRTHDATE;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self requestActivationCodeAndValidateCredentialForTheFirstTime];
            VIPIssuer *issuer = [[VIPIssuer alloc]init];
            [issuer requestHashRegistryForCredential:self.hashSecret];
            
            SecondViewController *svc = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
            [self presentModalViewController:svc animated:YES];
            break;
            
        case 1:
            [self.fullCreditCardNumber becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

- (void) requestActivationCodeAndValidateCredentialForTheFirstTime
{
    
    VIPIssuer *issuer = [[VIPIssuer alloc] init];
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(
//                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
//    dispatch_async(queue, ^{
        NSLog(@"username : %@", self.appDelegate.userName);
        NSDictionary *activationAuthenticationResponse = [issuer
                                                          requestActivationCodeUsingCredentials:self.appDelegate.userName
                                                          password:self.appDelegate.password];
        
        self.activationCodeResponse = [activationAuthenticationResponse valueForKey:ACTIVATION_CODE_KEY];
        
        if(self.activationCodeResponse){
            
            NSLog(@"Codigo de activacion :%@", self.activationCodeResponse);
            
            Status *status = nil;
            status = [self.appDelegate
                      getCredentialStatusWithCredentialPrefix:CREDENTIAL_PREFIX activationCode:self.activationCodeResponse];
            
            self.status = status;
            NSLog(@"Cred id %@",status.credential.credId);
            NSLog(@"Credntial CreationTime %@", [NSDate dateWithTimeIntervalSince1970:status.credential.creationTime]);
            NSLog(@"\nCredntial Shared secret %@", status.credential.sharedSecret);
            if([status.statusCode isEqualToString:CREDENTIAL_PROVISIONED_SUCCESSSFULLY]){
                
                self.validationResult = [issuer requestValidationUsingCredential:self.appDelegate.credential];
                NSLog(@"validation Result : %@", self.validationResult);
                
                NSString *credentialRegistrationStatus = nil;
                credentialRegistrationStatus = [issuer requestRegisterCredential:self.status.credential];
                
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *path = [PersistenceFilesPathsProvider getVIPServicesSettingsFilePath];
                
                if(credentialRegistrationStatus){
                    
                    if(YES){
//                    if ([fileManager fileExistsAtPath: provisionedCredentialsPropertyListFilePath] == YES) {
                        
                        NSDictionary *savedDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
                        
                        if(savedDictionary && [savedDictionary count] > 0){
                            
                            [savedDictionary setValue:self.status.credential.credId forKey:CREDENTIAL_ID];
                            
                            NSString *errorStr;
                            NSData *dataRep = [NSPropertyListSerialization dataFromPropertyList:savedDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorStr];
                            
                            BOOL saved = NO;
                            saved = [dataRep writeToFile:path atomically:YES];
                            
                            if(saved){
                                NSLog(@"Credential succesfully saved with ID :%@", self.status.credential.credId);
                            }else {
                                NSLog(@"Could not store credential! ");
                            }

                        }
                    }else {
                        NSLog(@"filepath does not exists!");
                    }
                }
                
//                self.statusMessage = [[UIAlertView alloc]
//                                      initWithTitle:@"VIP Issuer" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            
        }else {
            NSLog(@"no activation code response!");
        }
        
//    });

}

- (void) showWelcomeViewController
{
    SecondViewController *scv = [[SecondViewController alloc]
                                                       initWithNibName:SECOND_VIEW_NIB_FILENAME bundle:nil];
    
    [self presentViewController:scv animated:YES completion:nil];
}


@end
