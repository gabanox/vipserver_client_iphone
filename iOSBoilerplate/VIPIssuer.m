//
//  VIPIssuer.m
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "VIPIssuer.h"
#import "XMLParser.h"

@implementation VIPIssuer {
    
    NSURL *provisioningURL;
    NSURL *validationURL;
}

-(id) init {
    if(self = [super init]){
        provisioningURL = [[NSURL alloc] initWithString:@"http://localhost:8080/vipserverendpoint/Validation.wsdl"];
        validationURL = [[NSURL alloc] initWithString:@"http://localhost:8080/vipserverendpoint/Validation.wsdl"];
    }
    return self;
}

-(NSString *) authenticateWithUsernameThenRequestAnActivationCode: (NSString *) aUsername password:(NSString *) aPassword
{
    NSString *activationCode = nil;
    
    NSMutableURLRequest *postRequest = nil;
    postRequest = [NSMutableURLRequest requestWithURL:provisioningURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.anzen.com.mx/vipserverissuer/validate/schema\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[postBody appendData:[[NSString stringWithString:@"<soapenv:Header/>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"<soapenv:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[postBody appendData:[[NSString stringWithString:@"<sch:AuthenticateUserRequest>"] dataUsingEncoding:NSUTF8StringEncoding]];
	   [postBody appendData:[[NSString stringWithFormat:@"<sch:userName>%@</sch:userName>",aUsername] dataUsingEncoding:NSUTF8StringEncoding]];
	   [postBody appendData:[[NSString stringWithFormat:@"<sch:password>%@</sch:password>",aPassword] dataUsingEncoding:NSUTF8StringEncoding]];     
	[postBody appendData:[[NSString stringWithString:@"</sch:AuthenticateUserRequest>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[postBody appendData:[[NSString stringWithString:@"</soapenv:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"</soapenv:Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
	
    
    NSString *postRequestAsString = [[NSString alloc] initWithData:postBody encoding:NSASCIIStringEncoding];
    
	NSLog(@"Post Request %@", postRequestAsString);

    NSURLResponse *theresponse = nil;
	NSData *thedata = nil;
	NSError* theerror=nil;
	
	thedata = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&theresponse error:&theerror];
	
	if(thedata && [theresponse isKindOfClass:[NSHTTPURLResponse class]] && ([(NSHTTPURLResponse*)theresponse statusCode] == 200)) {
        
        NSString *rawDataAsText = [[NSString alloc] initWithData:thedata encoding:NSASCIIStringEncoding];
        NSLog(@"Response data => %@", rawDataAsText);
        
		XMLParser *parser = [[XMLParser alloc] init];
		NSError *parseError = nil;
    
		NSString *authenticationToken = [parser parseAuthenticationReponse:thedata parseError:parseError];
        
        if(authenticationToken){
            
        }else {
            
        }
	return activationCode;
    }
}
@end
