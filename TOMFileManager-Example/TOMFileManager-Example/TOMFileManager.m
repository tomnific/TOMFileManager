//
//  TOMFileManager.m
//  TOMFileManager-Example
//
//  Created by Tom Metzger on 12/19/18.
//  Copyright © 2018 Tom. All rights reserved.
//

#import "TOMFileManager.h"





@implementation TOMFileManager
{
	BOOL debugMode;
}




- (id)init
{
	debugMode = false;
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	_documentsDirectory = [paths objectAtIndex:0];
	
	
	_resourcesDirectory = [[NSBundle mainBundle]resourcePath];
	
	
	paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	_libraryDirectory = [paths objectAtIndex:0];
	
	
	_tempDirectory = [[[NSFileManager defaultManager] temporaryDirectory] path];
	
	
	return self;
}




- (BOOL)createDirectoryAtPath:(nonnull NSString *)newDirectoryPath
{
	NSError *error;
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectoryPath])
	{
		if (debugMode)
		{
			NSLog(@"[TOMFileManager] INFO: Creating directory: '%@'.", newDirectoryPath);
		}
		
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error];
		
		if (error)
		{
			NSLog(@"[TOMFileManager] ERROR: Could not create directory: '%@'.", newDirectoryPath);
			NSLog(@"   RESULTING ERROR: %@", error);
			
			return NO;
		}
		
		return YES;
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not create directory: '%@'.", newDirectoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: Directory already exists.");
		}
		
		return NO;
	}
	
	
	return NO;
}




- (BOOL)createSubdirectoryNamed:(nonnull NSString *)subdirectoryName in:(nonnull NSString *)existingDirectoryPath
{
	NSString *correctedSubdirectoryName;
	
	
	correctedSubdirectoryName = subdirectoryName;
	if ([correctedSubdirectoryName hasPrefix:@"/"])
	{
		correctedSubdirectoryName = [correctedSubdirectoryName substringFromIndex:1];
	}
	
	
	NSString *newDirectoryPath = [existingDirectoryPath stringByAppendingPathComponent:correctedSubdirectoryName];
	
	
	return [self createDirectoryAtPath:newDirectoryPath];
}




- (BOOL)copyDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath
{
	return [self copyDirectoryFrom:sourceDirectoryPath to:destinationDirectoryPath regardlessOfType:NO];
}




- (BOOL)copyDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = false;
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:sourceDirectoryPath isDirectory:&sourceIsDirectory])
	{
		if (sourceIsDirectory)
		{
			if (debugMode)
			{
				NSLog(@"[TOMFileManager] INFO: Copying contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
			}
			
			[[NSFileManager defaultManager] copyItemAtPath:sourceDirectoryPath toPath:destinationDirectoryPath error:&error];
			
			if (error)
			{
				NSLog(@"[TOMFileManager] ERROR: Could not copy directory: '%@'.", sourceDirectoryPath);
				NSLog(@"   RESULTING ERROR: %@", error);
				
				return NO;
			}
			
			return YES;
		}
		else
		{
			if (ignoreType)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Copying contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
				}
				
				[[NSFileManager defaultManager] copyItemAtPath:sourceDirectoryPath toPath:destinationDirectoryPath error:&error];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not copy directory: '%@'.", sourceDirectoryPath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not copy directory: '%@'.", sourceDirectoryPath);
				
				if (debugMode)
				{
					NSLog(@"   MOST LIKELY REASON: Source is not a directory.");
				}
				
				return NO;
			}
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not copy directory: '%@'.", sourceDirectoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: Directory does not exist.");
		}
		
		return NO;
	}
}




- (BOOL)moveDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath
{
	return [self moveDirectoryFrom:sourceDirectoryPath to:destinationDirectoryPath regardlessOfType:NO];
}




- (BOOL)moveDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = false;
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:sourceDirectoryPath isDirectory:&sourceIsDirectory])
	{
		if (sourceIsDirectory)
		{
			if (debugMode)
			{
				NSLog(@"[TOMFileManager] INFO: Moving contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
			}
			
			[[NSFileManager defaultManager] moveItemAtPath:sourceDirectoryPath toPath:destinationDirectoryPath error:&error];
			
			if (error)
			{
				NSLog(@"[TOMFileManager] ERROR: Could not move directory: '%@'.", sourceDirectoryPath);
				NSLog(@"   RESULTING ERROR: %@", error);
				
				return NO;
			}
			
			return YES;
		}
		else
		{
			if (ignoreType)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Moving contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
				}
				
				[[NSFileManager defaultManager] moveItemAtPath:sourceDirectoryPath toPath:destinationDirectoryPath error:&error];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not move directory: '%@'.", sourceDirectoryPath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not move directory: '%@'.", sourceDirectoryPath);
				
				if (debugMode)
				{
					NSLog(@"   MOST LIKELY REASON: Source is not a directory.");
				}
				
				return NO;
			}
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not move directory: '%@'.", sourceDirectoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: Directory does not exist.");
		}
		
		return NO;
	}
}




- (BOOL)renameDirectoryAtPath:(nonnull NSString *)directoryPath to:(nonnull NSString *)newName
{
	return [self renameDirectoryAtPath:directoryPath to:newName regardlessOfType:NO];
}




- (BOOL)renameDirectoryAtPath:(nonnull NSString *)directoryPath to:(nonnull NSString *)newName regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = false;
	
	NSString *pathOfNewName;
	
	
	
	if (![newName hasPrefix:@"/"])
	{
		pathOfNewName = [[directoryPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
	}
	else
	{
		pathOfNewName = [[directoryPath stringByDeletingLastPathComponent] stringByAppendingString:newName];
	}
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:pathOfNewName isDirectory:&sourceIsDirectory])
	{
		if (sourceIsDirectory)
		{
			if (debugMode)
			{
				NSLog(@"[TOMFileManager] INFO: Renaming directory: '%@'.\nTo: '%@'.", directoryPath, pathOfNewName);
			}
			
			[self createDirectoryAtPath:pathOfNewName];
			[self moveDirectoryFrom:directoryPath to:pathOfNewName];
			
			if (error)
			{
				NSLog(@"[TOMFileManager] ERROR: Could not rename directory: '%@'.", directoryPath);
				NSLog(@"   RESULTING ERROR: %@", error);
				
				return NO;
			}
			
			return YES;
		}
		else
		{
			if (ignoreType)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Renaming directory: '%@'.\nTo: '%@'.", directoryPath, pathOfNewName);
				}
				
				[self createDirectoryAtPath:pathOfNewName];
				[self moveDirectoryFrom:directoryPath to:pathOfNewName];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not rename directory: '%@'.", directoryPath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not rename directory: '%@'.", directoryPath);
				
				if (debugMode)
				{
					NSLog(@"   MOST LIKELY REASON: Source is not a directory.");
				}
				
				return NO;
			}
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not rename directory: '%@'.", directoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: Directory does not exist.");
		}
		
		return NO;
	}
}




- (BOOL)deleteDirectory:(nonnull NSString *)directoryPath
{
	return [self deleteDirectory:directoryPath regardlessOfType:NO];
}




- (BOOL)deleteDirectory:(nonnull NSString *)directoryPath regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = false;
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&sourceIsDirectory])
	{
		if (sourceIsDirectory)
		{
			if (debugMode)
			{
				NSLog(@"[TOMFileManager] INFO: Deleting directory: '%@'.\n", directoryPath);
			}
			
			[[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
			
			if (error)
			{
				NSLog(@"[TOMFileManager] ERROR: Could not delete directory: '%@'.", directoryPath);
				NSLog(@"   RESULTING ERROR: %@", error);
				
				return NO;
			}
			
			return YES;
		}
		else
		{
			if (ignoreType)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Deleting directory: '%@'.\n", directoryPath);
				}
				
				[[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not delete directory: '%@'.", directoryPath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not delete directory: '%@'.", directoryPath);
				
				if (debugMode)
				{
					NSLog(@"   MOST LIKELY REASON: It is not a directory.");
				}
				
				return NO;
			}
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not move directory: '%@'.", directoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: Directory does not exist.");
		}
		
		return NO;
	}
}




- (NSString *)getPathForFileNamed:(NSString *)filename inDirectory:(NSString *)directoryPath
{
	BOOL fileFound = false;
	NSURL *directoryURL = [NSURL fileURLWithPath:directoryPath ]; // URL pointing to the directory you want to browse
	NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
	
	
	BOOL isDirectory = false;
	if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory])
	{
		if (!isDirectory)
		{
			NSLog(@"[TOMFileManager] ERROR: Search Location is not a directory.");
			return nil;
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Search Location does not exist.");
		return nil;
	}
	
	
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
										 enumeratorAtURL:directoryURL
										 includingPropertiesForKeys:keys
										 options:0
										 errorHandler:^(NSURL *url, NSError *error)
										 {
											 // Handle the error.
											 // Return YES if the enumeration should continue after the error.
											 return YES;
										 }];
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Retrieving file: '%@'.\nFrom directory: '%@'.", filename, directoryPath);
	}
	
	
	for (NSURL *url in enumerator)
	{
		NSError *error;
		if (![url resourceValuesForKeys:keys error:&error])
		{
			if (!error)
			{
				if([[url absoluteString] hasSuffix:filename])
				{
					fileFound = true;
					return url.path;
				}
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not check resource value for key.");
				NSLog(@"   RESULTING ERROR: %@", [error localizedDescription]);
			}
		}
	}
	
	
	if (!fileFound)
	{
		NSLog(@"ERROR: File Not Found In Directory");
		return NULL;
	}
	else
	{
		NSLog(@"ERROR: File Found But Not Returned");
		return NULL;
	}
}




- (NSString *)findAndGetPathForFileNamed:(NSString *)filename
{
	BOOL fileFound = false;
	NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[self documentsDirectory]];
	NSURL *resourcesDirectoryURL = [NSURL fileURLWithPath:[self resourcesDirectory]];
	NSURL *libraryDirectoryURL = [NSURL fileURLWithPath:[self libraryDirectory]];
	NSURL *tempDirectoryURL = [NSURL fileURLWithPath:[self tempDirectory]];
	NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
	
	
	NSDirectoryEnumerator *documentsEnumerator = [[NSFileManager defaultManager]
										 enumeratorAtURL:documentsDirectoryURL
										 includingPropertiesForKeys:keys
										 options:0
										 errorHandler:^(NSURL *url, NSError *error)
										 {
											 // Handle the error.
											 // Return YES if the enumeration should continue after the error.
											 return YES;
										 }];
	
	NSDirectoryEnumerator *resourcesEnumerator = [[NSFileManager defaultManager]
												  enumeratorAtURL:resourcesDirectoryURL
												  includingPropertiesForKeys:keys
												  options:0
												  errorHandler:^(NSURL *url, NSError *error)
												  {
													  // Handle the error.
													  // Return YES if the enumeration should continue after the error.
													  return YES;
												  }];
	
	NSDirectoryEnumerator *libraryEnumerator = [[NSFileManager defaultManager]
												  enumeratorAtURL:libraryDirectoryURL
												  includingPropertiesForKeys:keys
												  options:0
												  errorHandler:^(NSURL *url, NSError *error)
												  {
													  // Handle the error.
													  // Return YES if the enumeration should continue after the error.
													  return YES;
												  }];
	
	NSDirectoryEnumerator *tempEnumerator = [[NSFileManager defaultManager]
												  enumeratorAtURL:tempDirectoryURL
												  includingPropertiesForKeys:keys
												  options:0
												  errorHandler:^(NSURL *url, NSError *error)
												  {
													  // Handle the error.
													  // Return YES if the enumeration should continue after the error.
													  return YES;
												  }];
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Searching Documents Directory for file: '%@'.", filename);
	}
	
	for (NSURL *url in documentsEnumerator)
	{
		NSError *error;
		if (![url resourceValuesForKeys:keys error:&error])
		{
			if (!error)
			{
				if([[url absoluteString] hasSuffix:filename])
				{
					fileFound = true;
					return url.path;
				}
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not check resource value for key.");
				NSLog(@"   RESULTING ERROR: %@", [error localizedDescription]);
			}
		}
	}
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Searching Resources Directory for file: '%@'.", filename);
	}
	
	for (NSURL *url in resourcesEnumerator)
	{
		NSError *error;
		if (![url resourceValuesForKeys:keys error:&error])
		{
			if (!error)
			{
				if([[url absoluteString] hasSuffix:filename])
				{
					fileFound = true;
					return url.path;
				}
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not check resource value for key.");
				NSLog(@"   RESULTING ERROR: %@", [error localizedDescription]);
			}
		}
	}
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Searching Library Directory for file: '%@'.", filename);
	}
	
	for (NSURL *url in libraryEnumerator)
	{
		NSError *error;
		if (![url resourceValuesForKeys:keys error:&error])
		{
			if (!error)
			{
				if([[url absoluteString] hasSuffix:filename])
				{
					fileFound = true;
					return url.path;
				}
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not check resource value for key.");
				NSLog(@"   RESULTING ERROR: %@", [error localizedDescription]);
			}
		}
	}
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Searching Temp Directory for file: '%@'.", filename);
	}
	
	for (NSURL *url in tempEnumerator)
	{
		NSError *error;
		if (![url resourceValuesForKeys:keys error:&error])
		{
			if (!error)
			{
				if([[url absoluteString] hasSuffix:filename])
				{
					fileFound = true;
					return url.path;
				}
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not check resource value for key.");
				NSLog(@"   RESULTING ERROR: %@", [error localizedDescription]);
			}
		}
	}
	
	
	if (!fileFound)
	{
		NSLog(@"ERROR: File Not Found In Directory");
		return NULL;
	}
	else
	{
		NSLog(@"ERROR: File Found But Not Returned");
		return NULL;
	}
}




- (BOOL)copyFileAtPath:(NSString *)filePath to:(NSString *)destinationDirectoryPath
{
	return [self copyFileAtPath:filePath to:destinationDirectoryPath regardlessOfType:NO];
}



- (BOOL)copyFileAtPath:(NSString *)filePath to:(NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = true;
	BOOL destinationIsDirectory = true;
	NSString *correctedDestinationDirectoryPath;
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath isDirectory:&destinationIsDirectory])
	{
		[self createDirectoryAtPath:destinationDirectoryPath];
		correctedDestinationDirectoryPath = [destinationDirectoryPath stringByAppendingPathComponent:[filePath lastPathComponent]];
	}
	else
	{
		if (destinationIsDirectory)
		{
			correctedDestinationDirectoryPath = [destinationDirectoryPath stringByAppendingPathComponent:[filePath lastPathComponent]];
		}
		else
		{
			correctedDestinationDirectoryPath = destinationDirectoryPath;
		}
	}
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Full path of file copy: '%@'.", correctedDestinationDirectoryPath);
	}
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&sourceIsDirectory])
	{
		if ([[NSFileManager defaultManager] isReadableFileAtPath:filePath])
		{
			if (!sourceIsDirectory)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Copying file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
				}
				
				[[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destinationDirectoryPath error:&error];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not copy file: '%@'.", filePath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				if (ignoreType)
				{
					if (debugMode)
					{
						NSLog(@"[TOMFileManager] INFO: Copying file: '%@'.\nTo directory: '%@'.", filePath, destinationDirectoryPath);
					}
					
					[[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destinationDirectoryPath error:&error];
					
					if (error)
					{
						NSLog(@"[TOMFileManager] ERROR: Could not copy file: '%@'.", filePath);
						NSLog(@"   RESULTING ERROR: %@", error);
						
						return NO;
					}
					
					return YES;
				}
				else
				{
					NSLog(@"[TOMFileManager] ERROR: Could not copy file: '%@'.", filePath);
					
					if (debugMode)
					{
						NSLog(@"   MOST LIKELY REASON: Source is not a file.");
					}
					
					return NO;
				}
			}
		}
		else
		{
			NSLog(@"[TOMFileManager] ERROR: Could not copy file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
			
			if (debugMode)
			{
				NSLog(@"   MOST LIKELY REASON: Permissions Error.");
			}
			
			return NO;
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not copy file: '%@'.", filePath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: File does not exist.");
		}
		
		return NO;
	}
}




- (BOOL)findAndCopyFileNamed:(NSString *)filename to:(NSString *)destinationDirectoryPath
{
	NSString *pathOfFile = [self findAndGetPathForFileNamed:filename];
	
	if (pathOfFile != nil)
	{
		return [self copyFileAtPath:pathOfFile to:destinationDirectoryPath];
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not find and copy file: '%@'.\nTo: '%@'.", filename, destinationDirectoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: File was not found.");
		}
		
		return NO;
	}
}




- (BOOL)moveFileAtPath:(NSString *)filePath to:(NSString *)destinationDirectoryPath
{
	return [self moveFileAtPath:filePath to:destinationDirectoryPath regardlessOfType:NO];
}



- (BOOL)moveFileAtPath:(NSString *)filePath to:(NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = true;
	BOOL destinationIsDirectory = true;
	NSString *correctedDestinationDirectoryPath;
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath isDirectory:&destinationIsDirectory])
	{
		[self createDirectoryAtPath:destinationDirectoryPath];
		correctedDestinationDirectoryPath = [destinationDirectoryPath stringByAppendingPathComponent:[filePath lastPathComponent]];
	}
	else
	{
		if (destinationIsDirectory)
		{
			correctedDestinationDirectoryPath = [destinationDirectoryPath stringByAppendingPathComponent:[filePath lastPathComponent]];
		}
		else
		{
			correctedDestinationDirectoryPath = destinationDirectoryPath;
		}
	}
	
	
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Full path of file move: '%@'.", correctedDestinationDirectoryPath);
	}
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&sourceIsDirectory])
	{
		if ([[NSFileManager defaultManager] isReadableFileAtPath:filePath])
		{
			if (!sourceIsDirectory)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Moving file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
				}
				
				[[NSFileManager defaultManager] moveItemAtPath:filePath toPath:destinationDirectoryPath error:&error];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not move file: '%@'.", filePath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				if (ignoreType)
				{
					if (debugMode)
					{
						NSLog(@"[TOMFileManager] INFO: Moving file: '%@'.\nTo directory: '%@'.", filePath, destinationDirectoryPath);
					}
					
					[[NSFileManager defaultManager] moveItemAtPath:filePath toPath:destinationDirectoryPath error:&error];
					
					if (error)
					{
						NSLog(@"[TOMFileManager] ERROR: Could not move file: '%@'.", filePath);
						NSLog(@"   RESULTING ERROR: %@", error);
						
						return NO;
					}
					
					return YES;
				}
				else
				{
					NSLog(@"[TOMFileManager] ERROR: Could not move file: '%@'.", filePath);
					
					if (debugMode)
					{
						NSLog(@"   MOST LIKELY REASON: Source is not a file.");
					}
					
					return NO;
				}
			}
		}
		else
		{
			NSLog(@"[TOMFileManager] ERROR: Could not move file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
			
			if (debugMode)
			{
				NSLog(@"   MOST LIKELY REASON: Permissions Error.");
			}
			
			return NO;
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not move file: '%@'.", filePath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: File does not exist.");
		}
		
		return NO;
	}
}




- (BOOL)findAndMoveFileNamed:(NSString *)filename to:(NSString *)destinationDirectoryPath
{
	NSString *pathOfFile = [self findAndGetPathForFileNamed:filename];
	
	if (pathOfFile != nil)
	{
		return [self moveFileAtPath:pathOfFile to:destinationDirectoryPath];
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not find and move file: '%@'.\nTo: '%@'.", filename, destinationDirectoryPath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: File was not found.");
		}
		
		return NO;
	}
}




- (BOOL)deleteFileAtPath:(NSString *)filePath
{
	return [self deleteFileAtPath:filePath regardlessOfType:NO];
}




- (BOOL)deleteFileAtPath:(NSString *)filePath regardlessOfType:(BOOL)ignoreType
{
	NSError *error;
	BOOL sourceIsDirectory = false;
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&sourceIsDirectory])
	{
		if (!sourceIsDirectory)
		{
			if (debugMode)
			{
				NSLog(@"[TOMFileManager] INFO: Deleting file: '%@'.\n", filePath);
			}
			
			[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
			
			if (error)
			{
				NSLog(@"[TOMFileManager] ERROR: Could not delete directory: '%@'.", filePath);
				NSLog(@"   RESULTING ERROR: %@", error);
				
				return NO;
			}
			
			return YES;
		}
		else
		{
			if (ignoreType)
			{
				if (debugMode)
				{
					NSLog(@"[TOMFileManager] INFO: Deleting file: '%@'.\n", filePath);
				}
				
				[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
				
				if (error)
				{
					NSLog(@"[TOMFileManager] ERROR: Could not delete file: '%@'.", filePath);
					NSLog(@"   RESULTING ERROR: %@", error);
					
					return NO;
				}
				
				return YES;
			}
			else
			{
				NSLog(@"[TOMFileManager] ERROR: Could not delete directory: '%@'.", filePath);
				
				if (debugMode)
				{
					NSLog(@"   MOST LIKELY REASON: It is not a directory.");
				}
				
				return NO;
			}
		}
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not delete file: '%@'.", filePath);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: File does not exist.");
		}
		
		return NO;
	}
}




- (BOOL)findAndDeleteFileNamed:(NSString *)filename
{
	NSString *pathOfFile = [self findAndGetPathForFileNamed:filename];
	
	
	if (pathOfFile != nil)
	{
		return [self deleteFileAtPath:pathOfFile];
	}
	else
	{
		NSLog(@"[TOMFileManager] ERROR: Could not find and delte file: '%@'.", filename);
		
		if (debugMode)
		{
			NSLog(@"   MOST LIKELY REASON: File was not found.");
		}
		
		return NO;
	}
}




- (BOOL)fileExistsAtPath:(NSString *)filePath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}




- (NSUInteger)numberOfFilesInDirectoryAtPath:(NSString *)directoryPath
{
	return [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil] count];
}




- (NSData*)retrieveDataForFileAtPath:(NSString *)filePath
{
	if ([self fileExistsAtPath:filePath])
	{
		return [NSData dataWithContentsOfFile:filePath];
	}
	else
	{
		return NULL;
	}
}




- (void)setDebugMode:(BOOL *)debugMode
{
	if (debugMode)
	{
		NSLog(@"[TOMFileManager] INFO: Setting debug mode to: '%@'.", debugMode ? @"YES" : @"NO");
	}
	
	
	self.debugMode = debugMode;
}


@end
