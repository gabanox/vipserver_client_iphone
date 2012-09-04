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

-(NSDictionary *) requestActivationCodeUsingCredentials:(NSString *) aUsername password:(NSString *) aPassword
{
    NSMutableDictionary *response = [[NSMutableDictionary alloc]init];
    
    NSMutableURLRequest *postRequest = nil;
    NSError *parseError = nil;
    NSURL *url = [NSURL URLWithString:VIP_ISSUER_ENDPOINT_URL];
    
    postRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *requestData = [NSMutableData data];
    
    NSMutableString *requestString = [NSMutableString string];
    [requestString appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.anzen.com.mx/vipserverissuer/validate/schema\">"];
    [requestString appendString:@"<soapenv:Header/>"];
    [requestString appendString:@"<soapenv:Body>"];
    [requestString appendString:@"<sch:AuthenticateUserRequest>"];
    [requestString appendFormat:@"<sch:userName>%@</sch:userName>",aUsername ];
    [requestString appendFormat:@"<sch:password>%@</sch:password>",aPassword ];
    [requestString appendString:@"</sch:AuthenticateUserRequest>"];
    [requestString appendString:@"</soapenv:Body>"];
    [requestString appendString:@"</soapenv:Envelope>"];

    
    [requestData appendData:[[NSString stringWithString:requestString] dataUsingEncoding:NSUTF8StringEncoding]];
    [postRequest setHTTPBody:requestData];

    NSData *responseData = [self requestResponseFrom:requestData usingHTTP:postRequest];
    NSLog(@"validation  response %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    
    NSString *activationCode = [parser parseActivationCodeResponse:responseData parseError:&parseError];
    
    [response setValue:activationCode forKey:ACTIVATION_CODE_KEY];
    return [[NSDictionary alloc]initWithDictionary:response];
}

- (NSString *) requestValidationUsingCredential:(Credential *)aCredential
{
    NSString *validationResponse = @"";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:VIP_ISSUER_ENDPOINT_URL ]];
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

- (NSString *) requestRegisterCredential: (Credential *) aCredential
{
    NSString *registrationStatus = @"";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:VIP_ISSUER_ENDPOINT_URL ]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *requestData = [NSMutableData data];
    
    NSMutableString *requestString = [NSMutableString string];
    [requestString appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.anzen.com.mx/vipserverissuer/validate/schema\">"];
    [requestString appendString:@"<soapenv:Header/>"];
    [requestString appendString:@"<soapenv:Body>"];
    [requestString appendString:@"<sch:RegisterCredentialRequest>"];
    [requestString appendFormat:@"<sch:credentialId>%@</sch:credentialId>", aCredential.credId];
    [requestString appendString:@"</sch:RegisterCredentialRequest>"];
    [requestString appendString:@"</soapenv:Body>"];
    [requestString appendString:@"</soapenv:Envelope>"];
    
    NSLog(@"request message : %@", requestString);
    [requestData appendData:[[NSString stringWithString:requestString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:requestData];
    
    NSData *responseData = [self requestResponseFrom:requestData usingHTTP:request];
    NSError *parseError = nil;
    NSLog(@"Registration response %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    
    registrationStatus = [parser parseCredentialRegistrationResponse:responseData parseError:&parseError];
    
    return registrationStatus;
}

- (NSString *)requestHashRegistryForCredential: (NSString *)sha1
{
    NSString *registrationStatus = @"";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:VIP_ISSUER_ENDPOINT_URL ]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *requestData = [NSMutableData data];
    
    NSMutableString *requestString = [NSMutableString string];
    [requestString appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.anzen.com.mx/vipserverissuer/validate/schema\">"];
    [requestString appendString:@"<soapenv:Header/>"];
    [requestString appendString:@"<soapenv:Body>"];
    [requestString appendString:@"<sch:RegisterHashValueForCredentialRequest>"];
    [requestString appendFormat:@"<sch:sha1>%@</sch:sha1>", sha1];
    [requestString appendString:@"</sch:RegisterHashValueForCredentialRequest>"];
    [requestString appendString:@"</soapenv:Body>"];
    [requestString appendString:@"</soapenv:Envelope>"];
    
    NSLog(@"request hash message : %@", requestString);
    [requestData appendData:[[NSString stringWithString:requestString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:requestData];
    
    NSData *responseData = [self requestResponseFrom:requestData usingHTTP:request];
    NSError *parseError = nil;
    NSLog(@"Registration response %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    
    registrationStatus = [parser parseHashRegistrationResponse:responseData parseError:&parseError];
    
    return registrationStatus;
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
