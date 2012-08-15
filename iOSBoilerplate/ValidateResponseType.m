//
//  ValidateResponseType.m
//  iOSBoilerplate
//
//  Created by Gabriel on 14/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "ValidateResponseType.h"

@implementation ValidateResponseType

@synthesize version;
@synthesize requestId;
@synthesize statusType;

-(id) initWithVersion:(NSString *) anAPIVersion requestId:(NSString *) theTokenId statusType:(StatusType *) theStatusType{
    
    if(self = [super init]){
        
        self.version = anAPIVersion;
        self.requestId = theTokenId;
        self.statusType = theStatusType;
    }
    return self;
}

@end
