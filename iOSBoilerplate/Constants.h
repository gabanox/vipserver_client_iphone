//
//  Constants.h
//  iOSBoilerplate
//
//  Created by Gabriel Ramirez on 19/07/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString * const MyGlobalConstant;

#define VIP_SERVICES_AUTHENTICATION_URL                 @"https://pilot-vipservices.verisign.com/prov"
//#define VIP_ISSUER_ENDPOINT_URL                         @"http://ec2-50-112-12-152.us-west-2.compute.amazonaws.com:8080/vipserverendpoint/Validation.wsdl".
//#define VIP_ISSUER_ENDPOINT_URL                         @"http://184.169.148.145:8089/vipserverendpoint/Validation.wsdl"
#define VIP_ISSUER_ENDPOINT_URL                         @"http://192.168.0.245:8080/vipserverendpoint/Validation.wsdl"
#define VIP_ISSUER_PROVISIONING_ENDPOINT_URL            @"http://192.168.0.245:8080/vipserverendpoint/Validation.wsdl"
//#define CREDENTIAL_PREFIX                               @"QATP"
#define CREDENTIAL_PREFIX                               @"QAMT"
#define CREDENTIAL_PROVISIONED_SUCCESSSFULLY            @"0000"
#define CREDENTIAL_ID                                   @"CredentialID"
#define SHARED_SECRET_KEY                               @"SHARED_SECRET"
#define ACTIVATION_CODE_KEY                             @"activationCode"
#define AUTHENTICATION_RESPONSE_KEY                     @"authenticationResponse"
#define AUTHENTICATION_SUCCESS_STATUS_KEY               @"AUTHENTICATION_PERFORMED_PENDING_VALIDATION"

//NIBS

#define FIRST_VIEW_NIB_FILENAME                         @"ViewController"
#define SECOND_VIEW_NIB_FILENAME                        @"SecondViewController"
#define CONFIRM_PERSONAL_NIB_FILENAME                   @"ConfirmPersonalInformationViewController"
@end
