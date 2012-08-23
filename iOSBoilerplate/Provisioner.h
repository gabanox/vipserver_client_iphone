#import <Foundation/Foundation.h>

@class Credential,Status;

@interface Provisioner : NSObject<NSURLConnectionDelegate> {
@private
	NSString *provisionURL;
}

@property (nonatomic,retain) NSString *provisionURL;

- (id)initWithURL: (NSString *)theURL;
- (Status *)getCredential: (NSString *)tokenPrefix activationCode: (NSString *)activationCode credential:(Credential **)credential;

@end

@interface Status : NSObject
{
@private
	NSString *statusMessage;
	NSString *statusCode;
}

- (id)initWithStatusCode:(NSString *)code message:(NSString *)message;

@property (nonatomic,retain) NSString *statusMessage;
@property (nonatomic,retain) NSString *statusCode;


@end
