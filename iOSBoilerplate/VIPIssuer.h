//
//  VIPIssuer.h
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Credential.h"

@interface VIPIssuer : NSObject

- (id) init;
- (NSDictionary *) requestActivationCodeUsingCredentials:(NSString *) aUsername password:(NSString *) aPassword;
- (NSString *) requestValidationUsingCredential:(Credential *)aCredential;
- (NSString *) requestRegisterCredential: (Credential *) aCredential;
- (NSString *)requestHashRegistryForCredential: (NSString *)sha1;
@end
