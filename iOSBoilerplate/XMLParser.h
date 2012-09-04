#import <Foundation/Foundation.h>
#import "Credential.h"

@interface XMLParser : NSObject<NSXMLParserDelegate> {
	
@private        
    Credential *_response;
	NSMutableString *_contentOfSharedResponse;
	NSString *_reasonCode;
}

@property (nonatomic,retain) Credential *response;
@property (nonatomic, retain) NSMutableString *contentOfSharedResponse;
@property (nonatomic,retain) NSString *reasonCode;

- (NSString *)parseXMLFile:(NSData *)theData  parseError:(NSError **)error credential:(Credential **)credential;
- (NSString *)parseAuthenticationReponse: (NSData *) theData parseError:(NSError **)error;
- (NSString *)parseActivationCodeResponse: (NSData *) theData parseError:(NSError **)error;
- (NSString *)parseCredentialValidationResponse:(NSData *) theData parseError: (NSError **)error;
- (NSString *)parseCredentialRegistrationResponse:(NSData *) theData parseError: (NSError **)error;
- (NSString *)parseHashRegistrationResponse:(NSData *) theData parseError: (NSError **)error;

@end
