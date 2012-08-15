#import <Foundation/Foundation.h>
#import "Credential.h"

@interface XMLParser : NSObject {
	
@private        
    Credential *_response;
	NSMutableString *_contentOfSharedResponse;
	NSString *_reasonCode;
}

@property (nonatomic,retain) Credential *response;
@property (nonatomic, retain) NSMutableString *contentOfSharedResponse;
@property (nonatomic,retain) NSString *reasonCode;


- (NSString *)parseXMLFile:(NSData *)theData  parseError:(NSError **)error credential:(Credential **)credential;

@end
