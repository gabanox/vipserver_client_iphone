/*
 This object would hold getsharedsecret elements. Currently, only tokenID,reasonCode and cipher are stored.
 Others will be added as and when needed.
 
 */
#import <Foundation/Foundation.h>


@interface Credential : NSObject {
	
	NSString *credId;
	NSString *sharedSecret;
	NSTimeInterval creationTime;
    NSString *securityCode;
}

@property (nonatomic,retain) NSString *credId;
@property (nonatomic,retain) NSString *sharedSecret;
@property (nonatomic) NSTimeInterval creationTime;
@property (nonatomic, retain) NSString *securityCode;

- (id)initWithCredential: (Credential *)credential;
- (id)initWithValues: (NSString *)credentialId secret:(NSString *)secret creationTime: (NSTimeInterval)time;
- (NSString *)getSecurityCode;

@end
