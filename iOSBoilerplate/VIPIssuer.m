//
//  VIPIssuer.m
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "VIPIssuer.h"
#import "XMLParser.h"
#import "Constants.h"

@implementation VIPIssuer {
    
    XMLParser *parser;
}

-(id) init {
    if(self = [super init]){
        parser = [[XMLParser alloc] init];
    }
    return self;
}

#pragma mark VIP Issuer web methods

-(NSString *) requestActivationCodeUsingCredentials:(NSString *) aUsername password:(NSString *) aPassword
{
    NSString *authenticationResponse = @"";
    NSString *activationCodeResponse = @"";
    
    NSMutableURLRequest *postRequest = nil;
    NSError *parseError = nil;
    NSURL *url = [NSURL URLWithString:VIP_ISSUER_PROVISIONING_ENDPOINT_URL];
    
    postRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *requestData = [NSMutableData data];
	[requestData appendData:[[NSString stringWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.anzen.com.mx/vipserverissuer/validate/schema\">"]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    
	[requestData appendData:[[NSString stringWithString:@"<soapenv:Header/>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[requestData appendData:[[NSString stringWithString:@"<soapenv:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[requestData appendData:[[NSString stringWithString:@"<sch:AuthenticateUserRequest>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"<sch:userName>%@</sch:userName>",aUsername] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"<sch:password>%@</sch:password>",aPassword] dataUsingEncoding:NSUTF8StringEncoding]];
	[requestData appendData:[[NSString stringWithString:@"</sch:AuthenticateUserRequest>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[requestData appendData:[[NSString stringWithString:@"</soapenv:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[requestData appendData:[[NSString stringWithString:@"</soapenv:Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[postRequest setHTTPBody:requestData];
	
    NSData *responseData = [self requestResponseFrom:requestData usingHTTP:postRequest];
    
    authenticationResponse = [parser parseAuthenticationReponse:responseData parseError:&parseError]; //@TODO corregir
    activationCodeResponse = [parser parseActivationCodeResponse:responseData parseError:&parseError];

    
	return activationCodeResponse;
}

- (NSString *) requestValidationUsingCredential:(Credential *)aCredential
{
    NSString *validationResponse = @"";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:VIP_ISSUER_VALIDATION_ENDPOINT_URL ]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *requestData = [NSMutableData data];
    
    NSMutableString *requestString = [NSMutableString string];
    [requestString appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.anzen.com.mx/vipserverissuer/validate/schema\">"];
    [requestString appendString:@"<soapenv:Header/>"];
    [requestString appendString:@"<soapenv:Body>"];
    [requestString appendString:@"<sch:ValidateCredentialRequest>"];
    [requestString appendString:@"<sch:Credential>"];
    [requestString appendFormat:@"<sch:tokenId>%@</sch:tokenId>", aCredential.credId];
    [requestString appendFormat:@"<sch:otp>%@</sch:otp>", aCredential.getSecurityCode];
    [requestString appendString:@"</sch:Credential>"];
    [requestString appendString:@"</sch:ValidateCredentialRequest>"];
    [requestString appendString:@"</soapenv:Body>"];
    [requestString appendString:@"</soapenv:Envelope>"];

    NSLog(@"request message : %@", requestString);
    [requestData appendData:[[NSString stringWithString:requestString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:requestData];
    
    NSData *responseData = [self requestResponseFrom:requestData usingHTTP:request];
    NSError *parseError = nil;
    NSLog(@"validation  response %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    
    validationResponse = [parser parseCredentialValidationResponse:responseData parseError:&parseError];

    return validationResponse;
}
-(NSData *) requestResponseFrom:(NSData *)data usingHTTP:(NSMutableURLRequest *)requestMethod
{
    NSString *postRequestAsString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Request : %@", postRequestAsString);
    
    NSURLResponse *theresponse = nil;
	NSError* theerror=nil;
	
	return [NSURLConnection sendSynchronousRequest:requestMethod returningResponse:&theresponse error:&theerror];
}

@end
