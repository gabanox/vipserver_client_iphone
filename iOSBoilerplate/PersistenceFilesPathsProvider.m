//
//  PersistenceFilesPathsProvider.m
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//


#import "PersistenceFilesPathsProvider.h"

#define PERSISTENCE_DIRECTORY									@"Persistence"
#define VIP_SERVICES_CONFIGURATION_FILE                         @"VIPServices.plist"

@interface PersistenceFilesPathsProvider()

+ (NSString*) getDocumentsDirPath;

@end


@implementation PersistenceFilesPathsProvider

+ (void) createDirectoryStructure {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSString* auxDir = [[PersistenceFilesPathsProvider getDocumentsDirPath] stringByAppendingPathComponent: PERSISTENCE_DIRECTORY];
	
	if ([fileManager fileExistsAtPath: auxDir] == NO)
	{
        NSError *error = nil;
        NSDictionary *attribs;
        NSURL *newDir = [NSURL fileURLWithPath:auxDir];
        BOOL createdDirectory = [fileManager createDirectoryAtURL:newDir withIntermediateDirectories:YES attributes:nil error:&error];
//		BOOL createdDirectory = [fileManager createDirectoryAtPath: auxDir withIntermediateDirectories: YES attributes: nil error: &error];
        
        if(createdDirectory){
            
            attribs = [fileManager attributesOfItemAtPath: auxDir error: NULL];
            
            NSLog (@"Created on %@", [attribs objectForKey: NSFileCreationDate]);
            NSLog (@"File type %@", [attribs objectForKey: NSFileType]);
            NSLog (@"POSIX Permissions %@", [attribs objectForKey: NSFilePosixPermissions]);
            
        }else {
            NSLog(@"Failed to create directory structure");
        }

	}
}

+ (NSString*) getDocumentsDirPath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	return [paths objectAtIndex: 0];
}

+ (NSString*) getVIPServicesSettingsFilePath {
    return [[[PersistenceFilesPathsProvider getDocumentsDirPath] stringByAppendingPathComponent:PERSISTENCE_DIRECTORY]
            stringByAppendingPathComponent:VIP_SERVICES_CONFIGURATION_FILE];
}

@end
