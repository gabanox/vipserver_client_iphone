#import "Provisioner.h"
#import "Credential.h"
#import "XMLParser.h"
#import "Constants.h"

@implementation Provisioner
@synthesize provisionURL;

NSString *kSuccessCode =  @"0000";


- (id)initWithURL: (NSString *)theURL{
	if(self == [super init]){
		self.provisionURL = theURL;
	}
	return self;
}

/*
 * Method to fetch credential.
 *
 * Credential object should be released in case we get from the server.
 * Otherwise, it would cause memory leaks. 
 */
- (Status *)getCredential: (NSString *)tokenPrefix activationCode: (NSString *)activationCode credential:(Credential **)credential{
	
	Status *status = nil;	
	
	if(provisionURL == nil){
		status = [[Status alloc] initWithStatusCode: @"-1" message:@"Provision URL is nil. Aborting request."];
	}
	
    NSURL *provision_url = [NSURL URLWithString:self.provisionURL];
	NSMutableURLRequest *postRequest = nil;
	postRequest = [NSMutableURLRequest requestWithURL:provision_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	//adding header information:
	[postRequest setHTTPMethod:@"POST"];
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/xml"];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//setting up the body:
	NSMutableData *postBody = [NSMutableData data];
  
//    [postBody appendData:[[NSString stringWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:vip=\"http://www.verisign.com/2006/08/vipservice\">"] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postBody appendData:[[NSString stringWithString:@"<soapenv:Header/>"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithString:@"<soapenv:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithString:@"<vip:GetSharedSecret Version=\"2.0\" Id=\"1234\">"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithFormat:@"<vip:TokenModel>%@</vip:TokenModel>",tokenPrefix] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithFormat:@"<vip:ActivationCode>%@</vip:ActivationCode>",activationCode] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithString:@"<vip:OtpAlgorithm type=\"HMAC-SHA1-TRUNC-6DIGITS\"/>"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithString:@"</vip:GetSharedSecret>"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithString:@"</soapenv:Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithString:@"</soapenv:Envelope>"] dataUsingEncoding:NSUTF8StringEncoding]];    

	[postBody appendData:[[NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<GetSharedSecret xmlns=\"http://www.verisign.com/2006/08/vipservice\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.verisign.com/2006/08/vipserviceuaservice.xsd\" Id=\"1234567890Anu\" Version=\"2.0\">\n<TokenModel>%@</TokenModel>\n",tokenPrefix] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"<ActivationCode>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:activationCode] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"</ActivationCode>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"<OtpAlgorithm type=\"HMAC-SHA1-TRUNC-6DIGITS\"/>\n<SharedSecretDeliveryMethod>HTTPS</SharedSecretDeliveryMethod>\n<SupportedEncryptionAlgorithm>NONE</SupportedEncryptionAlgorithm>\n</GetSharedSecret>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postRequest setHTTPBody:postBody];
	

	// create the connection with the request and start loading the data
	NSURLResponse *theresponse = nil;
	NSData *thedata = nil;
	NSError* theerror=nil;
	
	thedata = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&theresponse error:&theerror];
	
//    NSLog(@"response data : %@", [[NSString alloc]initWithData:thedata encoding:NSASCIIStringEncoding]);
    
	if(thedata && [theresponse isKindOfClass:[NSHTTPURLResponse class]] && ([(NSHTTPURLResponse*)theresponse statusCode] == 200)) {
        
        NSString *postRequestAsString = [[NSString alloc] initWithData:thedata encoding:NSASCIIStringEncoding];
        
//        NSLog(@"Request : %@", postRequestAsString);
        
		XMLParser *parser = [[XMLParser alloc] init];
		NSError *parseError = nil;
		Credential *temp = nil;
		NSString *reasonCode = [parser parseXMLFile:thedata parseError:&parseError credential:&temp];
		
		if(reasonCode == nil || parseError!= nil){
			/*
			 * Parser has returned with an exception. 
			 */
			status = [[Status alloc] initWithStatusCode: @"-1" message:@"Parser has returned with exception. "];
			
		}
		else{
			/*
			 * We did get the response. Return the reason code
			 */
			if([reasonCode isEqualToString:kSuccessCode]){
				*credential = [[Credential alloc] initWithCredential:temp];
				status = [[Status alloc] initWithStatusCode: reasonCode message:@"VIP Services has returned with success."];
				
			}else{
				status = [[Status alloc] initWithStatusCode: reasonCode message:@"VIP Services has returned with an exception."];
			}
		}
		[parser release];
				
	}else{
		status = [[Status alloc] initWithStatusCode: @"-1" message:@"Failed to establish connection."];
	}
	return status;
	
}

- (void)dealloc {
	[super dealloc];
    [provisionURL release];
}

#pragma mark NSURLConnectionDelegate 


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    NSLog(@"");
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end

@implementation Status
@synthesize statusMessage,statusCode;

- (id)initWithStatusCode:(NSString *)code message:(NSString *)message{
	if(self == [super init]){
		self.statusCode = code; 
		self.statusMessage = message;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
	[statusCode release];
    [statusMessage release];
}

@end

