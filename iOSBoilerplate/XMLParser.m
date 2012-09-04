#import "XMLParser.h"


@implementation XMLParser
@synthesize response = _response;
@synthesize contentOfSharedResponse = _contentOfSharedResponse;
@synthesize reasonCode = _reasonCode;

- (NSString *)parseXMLFile:(NSData *)theData parseError:(NSError **)error credential:(Credential **)credential{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:theData];

    Credential *res = [[Credential alloc] init];
    self.response = res;
    
    [parser setDelegate:self];

    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		return nil;
    }
    
	*credential = self.response;
	return self.reasonCode;
}

- (NSString *)parseAuthenticationReponse: (NSData *) theData parseError:(NSError **)error;
{
    
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:theData];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		return nil;
    }
    
    [parser release];
    
    return self.contentOfSharedResponse;
}

- (NSString *)parseActivationCodeResponse: (NSData *) theData parseError:(NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:theData];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		return nil;
    }
    
    [parser release];
    
    return self.contentOfSharedResponse;
}

- (NSString *)parseCredentialValidationResponse:(NSData *) theData parseError: (NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:theData];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if(parseError && error){
        *error = parseError;
        return nil;
    }
    return self.contentOfSharedResponse;
}

- (NSString *)parseCredentialRegistrationResponse:(NSData *) theData parseError: (NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:theData];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if(parseError && error){
        *error = parseError;
        return nil;
    }
    return self.contentOfSharedResponse;
}

- (NSString *)parseHashRegistrationResponse:(NSData *) theData parseError: (NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:theData];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if(parseError && error){
        *error = parseError;
        return nil;
    }
    return self.contentOfSharedResponse;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
	
	if([elementName isEqualToString:@"GetSharedSecretResponse"]){
        
        self.contentOfSharedResponse = [NSMutableString string];
        
	}else if([elementName isEqualToString:@"ns2:AuthenticateUserResponse"]){
        
        self.contentOfSharedResponse = [NSMutableString string];
    }else if([elementName isEqualToString:@"ns2:activationCode"]){
        
        self.contentOfSharedResponse = [NSMutableString string];
    }
	else if([elementName isEqualToString:@"ReasonCode"]){
		self.contentOfSharedResponse = [NSMutableString string];
	}
	else if([elementName isEqualToString:@"Secret"]){
		self.response.credId = [attributeDict valueForKey:@"Id"];
	}
	else if([elementName isEqualToString:@"Cipher"]){
		self.contentOfSharedResponse = [NSMutableString string];
        
	}else if([elementName isEqualToString:@"ns2:sessionToken"]){
        self.contentOfSharedResponse = [NSMutableString string];
        
    }else if([elementName isEqualToString:@"ns2:status"]){
        self.contentOfSharedResponse = [NSMutableString string];

    }else if([elementName isEqualToString:@"<sch:sha1>"]){
        self.contentOfSharedResponse = [NSMutableString string];
    
    }else{
		self.contentOfSharedResponse = nil;
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if (qName) {
		elementName = qName;
	}
	
	if([elementName isEqualToString:@"ReasonCode"]){
		self.reasonCode = self.contentOfSharedResponse;
		self.contentOfSharedResponse = nil;
	}
	else if([elementName isEqualToString:@"Cipher"]){
		self.response.sharedSecret = self.contentOfSharedResponse;
		self.contentOfSharedResponse = nil;
	}
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(self.contentOfSharedResponse){
		[self.contentOfSharedResponse appendString:string];
	}
}

- (void)dealloc{
	[_response release];
	[_contentOfSharedResponse release];
	[_reasonCode release];
	[super dealloc];
}


@end
