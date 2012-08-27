//
//  PersistenceFilesPathsProvider.h
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistenceFilesPathsProvider : NSObject

+ (void) createDirectoryStructure;
+ (NSString*) getVIPServicesSettingsFilePath;

@end
