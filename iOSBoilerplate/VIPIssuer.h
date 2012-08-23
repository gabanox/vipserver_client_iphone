//
//  VIPIssuer.h
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPIssuer : NSObject

-(id) init;
-(NSString *) requestActivationCodeUsingCredentials:(NSString *) aUsername password:(NSString *) aPassword;
@end
