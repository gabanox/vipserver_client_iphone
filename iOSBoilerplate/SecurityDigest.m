//
//  SecurityDigest.m
//  iOSBoilerplate
//
//  Created by Gabriel on 02/09/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "SecurityDigest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SecurityDigest

+ (NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

@end
