//
//  ValidateResponseType.h
//  iOSBoilerplate
//
//  Created by Gabriel on 14/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusType.h"

@interface ValidateResponseType : NSObject {
    NSString *_version;
    NSString *_requestId;
    StatusType *_statusType;
}

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, retain) StatusType *statusType;

-(id) initWithVersion:(NSString *) anAPIVersion requestId:(NSString *) theTokenId statusType:(StatusType *) theStatusType;
@end
