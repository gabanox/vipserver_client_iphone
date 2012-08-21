//
//  PersistenceFilesPathsProvider.m
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//


#import "PersistenceFilesPathsProvider.h"

#define PERSISTENCE_DIRECTORY									@"Persistence"

@interface PersistenceFilesPathsProvider()

+ (NSString*) getDocumentsDirPath;

@end


@implementation PersistenceFilesPathsProvider

+ (void) createDirectoryStructure {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSString* auxDir = [[PersistenceFilesPathsProvider getDocumentsDirPath] stringByAppendingPathComponent: PERSISTENCE_DIRECTORY];
	
	if ([fileManager fileExistsAtPath: auxDir] == NO)
	{
		[fileManager createDirectoryAtPath: auxDir withIntermediateDirectories: YES attributes: nil error: nil];
	}
}

+ (NSString*) getDocumentsDirPath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	return [paths objectAtIndex: 0];
}

@end
