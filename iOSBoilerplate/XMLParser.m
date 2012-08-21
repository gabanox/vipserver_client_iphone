#import "XMLParser.h"


@implementation XMLParser

@synthesize response = _response;
@synthesize contentOfSharedResponse = _contentOfSharedResponse;
@synthesize reasonCode = _reasonCode;
@synthesize authenticationToken = _authenticationToken;
@synthesize parser = _parser;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.parser = nil;
    currentElement = nil;
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
}

- (NSString *)parseXMLFile:(NSData *)theData parseError:(NSError **)error credential:(Credential **)credential{
    
    self.parser = [[NSXMLParser alloc] initWithData:theData];
    [_parser parse];

    NSError *parseError = [self.parser parserError];
    if (parseError && error) {
        *error = parseError;
		return nil;
    }
    [self.parser release];
	*credential = self.response;
	return self.reasonCode;
}

- (NSString *)parseAuthenticationReponse: (NSData *) theData parseError:(NSError **)error;
{
    self.parser = [[NSXMLParser alloc]initWithData:theData];
        [_parser setDelegate:self];
    [self.parser parse];
    
    NSError *parseError = [self.parser parserError];
    if (parseError && error) {
        *error = parseError;
		return nil;
    }
    
    [self.parser release];
    
    return self.authenticationToken;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    [currentElement release];
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"AuthenticateUserResponse"]){
        [currentName release];
        currentName = [[NSMutableString alloc] init];
    }
    
    if (qName) {
        elementName = qName;
    }
	
	if([elementName isEqualToString:@"GetSharedSecretResponse"]){
		Credential *res = [[Credential alloc] init];
		self.response = res;
		[res release];
		return;
	}
	
	else if([elementName isEqualToString:@"ReasonCode"]){
		self.contentOfSharedResponse = [NSMutableString string];
	}
	else if([elementName isEqualToString:@"Secret"]){
		self.response.credId = [attributeDict valueForKey:@"Id"];
	}
	else if([elementName isEqualToString:@"Cipher"]){
		self.contentOfSharedResponse = [NSMutableString string];
        
	}else if([elementName isEqualToString:@"ns2:AuthenticateUserResponse"]){
        NSLog(elementName, nil);
        
        [self.contentOfSharedResponse release];
        self.contentOfSharedResponse = [[NSMutableString alloc] init];

	}else{
		self.contentOfSharedResponse = nil;
		
	}
}
			 
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	if (qName) {
		elementName = qName;
	}
	NSLog(@"end: element %@ uri %@ qualified name %@",
          elementName, namespaceURI, qName);
	if([elementName isEqualToString:@"ReasonCode"]){
		self.reasonCode = self.contentOfSharedResponse;
		self.contentOfSharedResponse = nil;
	}
	else if([elementName isEqualToString:@"Cipher"]){
		self.response.sharedSecret = self.contentOfSharedResponse;
		self.contentOfSharedResponse = nil;
        
	}else if([elementName isEqualToString:@"ns2:AuthenticateUserResponse"]){
//        self.authenticationToken = self.contentOfSharedResponse;
//        self.contentOfSharedResponse = nil;
    }
		
}
			 
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(self.contentOfSharedResponse){
		[self.contentOfSharedResponse appendString:string];
	}
    
    if ([currentElement isEqualToString:@"ns2:authenticationToken"])
    {
        self.authenticationToken = string;
    }
    
}

#pragma mark Error handling

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}


- (void)dealloc{
	[_response release];
	[_contentOfSharedResponse release];
	[_reasonCode release];
    [currentElement release];
    [currentName release];
	[super dealloc];
}
			 
			 
@end
