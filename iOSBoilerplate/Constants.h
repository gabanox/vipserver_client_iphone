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
#define VIP_ISSUER_VALIDATION_ENDPOINT_URL              @"http://localhost:8080/vipserverendpoint/Validation.wsdl"
#define VIP_ISSUER_PROVISIONING_ENDPOINT_URL            @"http://localhost:8080/vipserverendpoint/Validation.wsdl"
//#define CREDENTIAL_PREFIX                               @"QATP"
#define CREDENTIAL_PREFIX                               @"QAMT"
@end
