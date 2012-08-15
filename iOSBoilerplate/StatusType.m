//
//  StatusType.m
//  iOSBoilerplate
//
//  Created by Gabriel on 14/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import "StatusType.h"


@implementation StatusType

@synthesize statusMessage;
@synthesize errorDetail;

-(id) initWithStatus:(NSString *)aStatusMessage errorDetail:(NSString *)theErrorDetail {
    
    if (self = [super init]) {
        self.statusMessage = aStatusMessage;
        self.errorDetail = theErrorDetail;
    }
    return self;
}

@end
