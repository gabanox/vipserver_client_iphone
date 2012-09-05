#import "Credential.h"
#import "challres.h"
#import "base64.h"
#import "PersistenceFilesPathsProvider.h"

@implementation Credential
@synthesize credId,sharedSecret;
@synthesize creationTime;
@synthesize securityCode;

- (id)initWithCredential: (Credential *)credential{
	if(self == [super init]){
		self.credId = credential.credId;
		self.sharedSecret = credential.sharedSecret;
		self.creationTime = credential.creationTime;
	}
	
	return self;
}

- (id)initWithValues: (NSString *)credentialId secret:(NSString *)secret creationTime: (NSTimeInterval)time{
	if(self == [super init]){
		
		self.credId =credentialId;
		self.sharedSecret = secret;
		self.creationTime = time;
	}
	
	return self;
}

/*
 * Method to generate the securityCode
 */
-(NSString *)getSecurityCode{
	NSString *securityCode = nil;
	char response[10];
	if(sharedSecret != nil){
    
        const char *temp = [sharedSecret UTF8String];
		int secretSize = strlen(temp);
		ITEM input,output;
		input.data = (unsigned char *)temp;
		input.len = secretSize;
		output.data = NULL;
		output.len = 0;
		if(UnBase64Alloc(&output, input) != 0)
			return nil;
		temp = NULL;
		NSTimeInterval curTime = [[NSDate date]timeIntervalSince1970];
		get_hotp(0x306, (char *)output.data, 20, curTime, 30, response, sizeof response);
		securityCode = [NSString stringWithUTF8String:response];
        self.securityCode = securityCode;
		return securityCode;
	}
	else
		return nil;
	
}

- (void)dealloc {
	[super dealloc];
    [credId release];
	[sharedSecret release];
}

@end
