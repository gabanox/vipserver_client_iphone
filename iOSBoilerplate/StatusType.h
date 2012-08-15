//
//  StatusType.h
//  iOSBoilerplate
//
//  Created by Gabriel on 14/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusType : NSObject {
    NSString *_statusMessage;
    NSString *_errorDetail;
}

@property(nonatomic, copy) NSString *statusMessage;
@property(nonatomic, copy) NSString *errorDetail;

-(id) initWithStatus:(NSString *)aStatusMessage errorDetail:(NSString *)theErrorDetail;

@end
