//
//  PersistenceFilesPathsProvider.m
//  iOSBoilerplate
//
//  Created by Gabriel on 20/08/12.
//  Copyright (c) 2012 HipermediaSoft. All rights reserved.
//


#import "PersistenceFilesPathsProvider.h"
#import "Constants.h"

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
    return [[PersistenceFilesPathsProvider getDocumentsDirPath] stringByAppendingPathComponent:VIP_SERVICES_CONFIGURATION_FILE];
}

+ (BOOL) storeSharedSecret:(NSString *)newSecret
{
    BOOL saved = NO;
    
//    NSString *vipPersistencePath = [PersistenceFilesPathsProvider getVIPServicesSettingsFilePath];
    NSString *path = [self getVIPServicesSettingsFilePath];
    
    NSDictionary *savedDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *errorStr;
    if(savedDictionary && [savedDictionary count] > 0){
        
        NSString *storedSecret = [savedDictionary valueForKey:@"SharedSecret"];
        
        if(![storedSecret isEqualToString:newSecret]){
        
            [savedDictionary setValue:newSecret forKey:@"SharedSecret"];
            NSData *dataRep = [NSPropertyListSerialization dataFromPropertyList:savedDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorStr];
            
            saved = [dataRep writeToFile:path atomically:YES];
        }
        
    }else {
    
        NSDictionary *propList = @{@"SharedSecret" : newSecret};
    
        NSData *dataRep = [NSPropertyListSerialization dataFromPropertyList:propList
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                       errorDescription:&errorStr];
        
        saved = [dataRep writeToFile:path atomically:YES];
    }
    return saved;
}


+ (NSString *) retrieveStoredSharedSecret
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vip.plist"];
    NSDictionary *savedDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *savedSecret = [savedDict valueForKey:@"SharedSecret"];
    return savedSecret;
}

@end