#import <Foundation/Foundation.h>
#import "Credential.h"

@interface XMLParser : NSObject<NSXMLParserDelegate> {
	
@private        
    Credential *_response;
	NSMutableString *_contentOfSharedResponse;
	NSString *_reasonCode;
    NSString *_authenticationToken;
    NSString *currentElement;
    NSMutableString *currentName;
    NSXMLParser *_parser;
}

@property (nonatomic,retain) Credential *response;
@property (nonatomic, retain) NSMutableString *contentOfSharedResponse;
@property (nonatomic,retain) NSString *reasonCode;
@property (nonatomic, copy) NSString *authenticationToken;
@property (nonatomic, retain) NSXMLParser *parser;

- (NSString *)parseXMLFile:(NSData *)theData  parseError:(NSError **)error credential:(Credential **)credential;
- (NSString *)parseAuthenticationReponse: (NSData *) theData parseError:(NSError **)error;

@end
