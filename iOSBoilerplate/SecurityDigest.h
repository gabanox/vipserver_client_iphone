//
//  SecurityDigest.h
//  iOSBoilerplate
//
//  Created by Gabriel on 02/09/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityDigest : NSObject

+ (NSString*) sha1:(NSString*)input;
@end
