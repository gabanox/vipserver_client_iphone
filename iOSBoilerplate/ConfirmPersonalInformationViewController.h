//
//  ConfirmPersonalInformationViewController.h
//  iOSBoilerplate
//
//  Created by Gabriel on 28/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface ConfirmPersonalInformationViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIAlertViewDelegate> {
    UITextField *txtActiveField;
    UIDatePicker *datePicker;
}

@property (nonatomic, retain) IBOutlet UITextField *fullCreditCardNumber;
@property (nonatomic, retain) IBOutlet UITextField *creditCardSecurityCode;
@property (nonatomic, retain) IBOutlet UITextField *postalCode;
@property (nonatomic, retain) UITextField *birthDate;
@property (retain, nonatomic) IBOutlet UILabel *fullCreditCardNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *confirmationMessage;
@property (retain, nonatomic) IBOutlet UILabel *creditCardSecurityCodeLabel;
@property (retain, nonatomic) IBOutlet UILabel *postalCodeLabel;
@property (retain, nonatomic) IBOutlet UILabel *birthDateLabel;
@property (nonatomic, retain) IBOutlet UIView *keyboardToolbar;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
