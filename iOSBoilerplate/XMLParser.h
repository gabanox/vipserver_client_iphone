#import <Foundation/Foundation.h>
#import "Credential.h"

@interface XMLParser : NSObject<NSXMLParserDelegate> {
	
@private        
    Credential *_response;
	NSMutableString *_contentOfSharedResponse;
	NSString *_reasonCode;
//    NSString *_authenticationToken;
//    NSString *_activationCode;
//    NSString *currentElement;
//    NSMutableString *currentName;
//    NSString *_sharedSecret;
//    NSString *_requestId;
//    NSXMLParser *_parser;
}

@property (nonatomic,retain) Credential *response;
@property (nonatomic, retain) NSMutableString *contentOfSharedResponse;
@property (nonatomic,retain) NSString *reasonCode;
//@property (nonatomic, copy) NSString *authenticationToken;
//@property (nonatomic, retain) NSXMLParser *parser;
//@property (nonatomic, copy) NSString *activationCode;
//@property (nonatomic, copy) NSString *sharedSecret;
//@property (nonatomic, copy) NSString *requestId;

- (NSString *)parseXMLFile:(NSData *)theData  parseError:(NSError **)error credential:(Credential **)credential;
- (NSString *)parseAuthenticationReponse: (NSData *) theData parseError:(NSError **)error;
- (NSString *)parseActivationCodeResponse: (NSData *) theData parseError:(NSError **)error;
- (NSString *)parseCredentialValidationResponse:(NSData *) theData parseError: (NSError **)error;

@end
