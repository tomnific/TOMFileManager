//
//  TOMFileManager.h
//  TOMFileManager-Example
//
//  Created by Tom Metzger on 12/19/18.
//  Copyright © 2018 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>





NS_ASSUME_NONNULL_BEGIN
/*!
 @class TOMFileManager
 
 @brief The @c TOMFileManager class
 
 @discussion This class was developed to make file management in iOS easier and intuitive, with less lines of code and more control.
 
 @author Tom Metzger
 @version 2.0
 @copyright © 2019, Tom Metzger
 */
@interface TOMFileManager : NSObject

/*! @brief This readonly property holds the string path of the app's Documents Directory. */
@property (readonly, nonatomic) NSString *documentsDirectory;

/*! @brief This readonly property holds the string path of the app's Resources Directory. */
@property (readonly, nonatomic) NSString *resourcesDirectory;

/*! @brief This readonly property holds the string path of the app's Library Directory. */
@property (readonly, nonatomic) NSString *libraryDirectory;

/*! @brief This readonly property holds the string path of the app's Temp Directory. */
@property (readonly, nonatomic) NSString *tempDirectory;




/*!
 @brief Initializes the `TOMFileManager` object.
 
 @discussion Assigns the correct paths to `documentsDirectory`, `resourcesDirectory`, `libraryDirectory`, and `tempDirectory`.
 
 It also initializes `debugMode` to `false`, but this can be changed later.
 
 @code
 TOMFileManager *manager = [[TOMFileManager alloc] init];
 @endcode
 
 @return `id` - After initializing the paths, it returns itself (or `nil` if it could not be initialized).
 */
- (id)init;




/*!
 @brief Creates a new directory at @c newDirectoryPath.
 
 @discussion Creates a new directory at @c newDirectoryPath, if it doesn't already exist.
 
 @code
 NSString *newDirectory = [manager.documentsDirectory stringByAppendingPathComponent:@"NewDirectory"]];
 [manager createDirectoryAtPath:newDirectory];
 @endcode
 
 @warning The path must be a valid path that is accessible in the app's sandbox.
 
 @param newDirectoryPath The full path for the directory you wish to create.
 
 @return @c BOOL - @c YES if the directory was created, and @c NO if an error occured.
 */
- (BOOL)createDirectoryAtPath:(nonnull NSString *)newDirectoryPath;


/*!
 @brief Creates a new directory at @c newDirectoryPath.
 
 @discussion Creates a new directory at @c newDirectoryPath, if it doesn't already exist.
 
 @code
 [manager createSubdirectoryNamed:@"Subdirectory" in:manager.documentsDirectory];
 @endcode
 
 @note
 • If @c subdirectoryName does not contain "/" at the beginning, it will automatically be added.
 
 • Under the hood, this function builds a path by appending @c subdirectoryName to @c existingDirectoryPath as a path component, and then calls @c createDirectory() using this new path.
 
 @warning @c existingDirectoryPath must be a valid path that is accessible in the app's sandbox.
 
 @param subdirectoryName The name of the subdirectory you wish to create.
 @param existingDirectoryPath The path of the directory in which you wish to make a subdirectory.
 
 @return @c BOOL - @c YES if the subdirectory was created, and @c NO if an error occured.
 */
- (BOOL)createSubdirectoryNamed:(nonnull NSString *)subdirectoryName in:(nonnull NSString *)existingDirectoryPath;



/*!
 @brief Copies the contents of one directory into another synchronously.
 
 @discussion Synchronously performs a shallow copy of the contents of @c sourceDirectoryPath into @c destinationDirectoryPath.
 
 @code
 [manager copyDirectoryFrom:manager.resourcesDirectory to:manager.documentsDirectory];
 @endcode
 
 @note
 • If @c destinationDirectoryPath does not exist, it will be created.
 
 • It does not copy the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does copy other hidden files (files that begin with a period character).
 
 @param sourceDirectoryPath The path of the directory who's contents you'd like to copy.
 @param destinationDirectoryPath The path of the directory into which you'd like the contents of @c directoryPath to be copied.
 
 @return @c BOOL - @c YES if the directory was copied, and @c NO if an error occured.
 */
- (BOOL)copyDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath;


/*!
 @brief Copies the contents of one directory into another synchronously.
 
 @discussion Synchronously performs a shallow copy of the contents of @c sourceDirectoryPath into @c destinationDirectoryPath.
 
 @code
 [manager copyDirectoryFrom:manager.mainBundleDirectory to:manager.documentsDirectory regardlessOfType:NO];
 @endcode
 
 @note
 • If @c destinationDirectoryPath does not exist, it will be created.
 
 • It does not copy the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does copy other hidden files (files that begin with a period character).
 
 @warning Ignoring the type if not recommended. Do so at your own risk.
 
 @param sourceDirectoryPath The path of the directory who's contents you'd like to copy.
 @param destinationDirectoryPath The path of the directory into which you'd like the contents of @c directoryPath to be copied.
 @param ignoreType If @c YES, continue with copying even if @c sourceDirectoryPath is not a directory
 
 @return @c BOOL - @c YES if the directory was copied, and @c NO if an error occured.
 */
- (BOOL)copyDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Moves the contents of one directory into another synchronously.
 
 @discussion Synchronously performs a shallow move of the contents of @c sourceDirectoryPath into @c destinationDirectoryPath.
 
 @code
 [manager moveDirectoryFrom:manager.mainBundleDirectory to:manager.documentsDirectory];
 @endcode
 
 @note
 • If @c destinationDirectoryPath does not exist, it will be created.
 
 • It does not move the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does move other hidden files (files that begin with a period character).
 
 @param sourceDirectoryPath The path of the directory who's contents you'd like to move.
 @param destinationDirectoryPath The path of the directory into which you'd like the contents of @c directoryPath to be moved.
 
 @return @c BOOL - @c YES if the directory was moved, and @c NO if an error occured.
 */
- (BOOL)moveDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath;


/*!
 @brief Moves the contents of one directory into another synchronously.
 
 @discussion Synchronously performs a shallow move of the contents of @c sourceDirectoryPath into @c destinationDirectoryPath.
 
 @code
 [manager moveDirectoryFrom:manager.resourcesDirectory to:manager.documentsDirectory regardlessOfType:NO];
 @endcode
 
 @note
 • If @c destinationDirectoryPath does not exist, it will be created.
 
 • It does not move the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does move other hidden files (files that begin with a period character).
 
 @warning Ignoring the type if not recommended. Do so at your own risk.
 
 @param sourceDirectoryPath The path of the directory who's contents you'd like to move.
 @param destinationDirectoryPath The path of the directory into which you'd like the contents of @c directoryPath to be moved.
 @param ignoreType If @c YES, continue with moving even if @c sourceDirectoryPath is not a directory
 
 @return @c BOOL - @c YES if the directory was moved, and @c NO if an error occured.
 */
- (BOOL)moveDirectoryFrom:(nonnull NSString *)sourceDirectoryPath to:(nonnull NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Renames the directory located at @c directoryPath to @c newName.
 
 @discussion Under the hood, what this really does is creates a new directory at the same level as @c directoryPath with the name of @c newName, then moves the contents of @c directoryPath to @c newName's directory.
 
 @code
 NSString *directoryToRename = [manager.documentsDirectory stringByAppendingPathComponent:@"Subdirectory"];
 [manager renameDirectoryAtPath:directoryToRename to:@"RenamedDirectory"];
 @endcode
 
 @warning Do not attempt to use this method to rename files
 
 @param directoryPath The path of the directory you'd like to rename.
 @param newName The new name you'd like to give the directory.
 
 @return @c BOOL - @c YES if the directory was renamed, and @c NO if an error occured.
 */
- (BOOL)renameDirectoryAtPath:(nonnull NSString *)directoryPath to:(nonnull NSString *)newName;


/*!
 @brief Renames the directory located at @c directoryPath to @c newName.
 
 @discussion Under the hood, what this really does is creates a new directory at the same level as @c directoryPath with the name of @c newName, then moves the contents of @c directoryPath to @c newName's directory.
 
 @code
 NSString *directoryToRename = [manager.documentsDirectory stringByAppendingPathComponent:@"SubDirectory"];
 [manager renameDirectoryAtPath:directoryToRename to:@"RenamedDirectory" regardlessOfType:NO];
 @endcode
 
 @warning Do not attempt to use this method to rename files
 
 @warning Ignoring the type if not recommended. Do so at your own risk.
 
 @param directoryPath The path of the directory you'd like to rename.
 @param newName The new name you'd like to give the directory.
 @param ignoreType If @c YES, continue with renaming even if `directoryPath` is not a directory
 
 @return @c BOOL - @c YES if the directory was renamed, and @c NO if an error occured.
 */
- (BOOL)renameDirectoryAtPath:(nonnull NSString *)directoryPath to:(nonnull NSString *)newName regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Deletes a directory and its contents.
 
 @discussion Deletes a directory and its contents.
 
 @code
 [manager deleteDirectory:manager.documentsDirectory];
 @endcode
 
 @param directoryPath The path of the directory you'd like to delete.
 
 @return @c BOOL - @c YES if the directory was deleted, and @c NO if an error occured.
 */
- (BOOL)deleteDirectory:(nonnull NSString *)directoryPath;


/*!
 @brief Deletes a directory and its contents.
 
 @discussion Deletes a directory and its contents.
 
 @code
 [manager deleteDirectory:manager.documentsDirectory regardlessOfType:NO];
 @endcode
 
 @param directoryPath The path of the directory you'd like to delete.
 @param ignoreType If @c YES, continue with deleting even if @c directoryPath is not a directory

 
 @return @c BOOL - @c YES if the directory was deleted, and @c NO if an error occured.
 */
- (BOOL)deleteDirectory:(nonnull NSString *)directoryPath regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Returns the filepath of a file located in the desired directory.
 
 @discussion Returns the filepath of a file named @c filename located in the directory @c directoryPath, therefore verifying it exists in the expected location.
 
 @code
 NSString *exampleFilePath = [manager getPathForFileNamed:@"example.png" inDirectory:manager.documentsDirectory];
 @endcode
 
 @warning @c directoryPath must be a directory, not a file.
 
 @param filename The name of the file who's full path you'd like to retrieve.
 @param directoryPath The path of the directory which contains the file @c filename.
 
 @return @c NSString - The full path for the desired file.
 */
- (NSString *)getPathForFileNamed:(NSString *)filename inDirectory:(NSString *)directoryPath;


/*!
 @brief Returns the filepath of a file located in an unknown directory.
 
 @discussion Recursively searches all accessible directories in the app's sandbox and returns the path to the first instance of a file named @ filename.
 
 @code
 NSString *exampleFilePath = [manager findAndGetPathForFileNamed:@"example.png"];
 @endcode
 
 @note For use when the directory the desired file is located in is not known.
 
 @param filename The name of the file you'd like to retrieve the path of, but don't know the directory of.
 
 @return @c NSString - The full path for the desired file.
 */
- (NSString *)findAndGetPathForFileNamed:(NSString *)filename;


/*!
 @brief Copies a file to a specified directory synchronously.
 
 @discussion Synchronously performs a shallow copy of the file with the path @c filePath to a directory with the path @c directoryPath.
 
 @code
 NSString *exampleFilePath = [manager.resourcesDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager copyFileAtPath:exampleFilePath to:manager.documentsDirectory];
 @endcode
 
 @note If @c directoryPath doesn't exist, it is created.
 
 @param filePath The path of the file you'd like to copy.
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be copied.
 
 @return @c BOOL - @c YES if the file was copied, and @c NO if an error occured.
 */
- (BOOL)copyFileAtPath:(NSString *)filePath to:(NSString *)destinationDirectoryPath;


/*!
 @brief Copies a file to a specified directory synchronously.
 
 @discussion Synchronously performs a shallow copy of the file with the path @c filePath to a directory with the path @c directoryPath.
 
 @code
 NSString *exampleFilePath = [manager.resourcesDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager copyFileAtPath:exampleFilePath to:manager.documentsDirectory regardlessOfType:NO];
 @endcode
 
 @note If @c directoryPath doesn't exist, it is created.
 
 @warning Ignoring the type if not recommended. Do so at your own risk.
 
 @param filePath The path of the file you'd like to copy.
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be copied.
 @param ignoreType If @c YES, continue with copying even if @c filePath is not a file.
 
 @return @c BOOL - @c YES if the file was copied, and @c NO if an error occured.
 */
- (BOOL)copyFileAtPath:(nonnull NSString *)filePath to:(nonnull NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Finds, then copies a file to a specified directory.
 
 @discussion Recursively searches all accessible directories for a file named @c filename, then copies the first found instance to a directory with the path @c directoryPath.
 
 @code
 [manager findAndCopyFileNamed:@"example.txt" to:manager.documentsDirectory];
 @endcode
 
 @note
 • If @c directoryPath doesn't exist, it is created.
 
 • Under the hood, this simply calls @c findAndGetPathForFile() then @c copyFile()
 
 @param filename The name of the file you'd like to find and copy.
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be copied, once found.
 
 @return @c BOOL - @c YES if the file was copied, and @c NO if an error occured.
 */
- (BOOL)findAndCopyFileNamed:(NSString *)filename to:(NSString *)destinationDirectoryPath;


/*!
 @brief Moves a file to a specified directory synchronously.
 
 @discussion Synchronously performs a shallow move of the file with the path @c filePath to a directory with the path @c directoryPath.
 
 @code
 NSString *exampleFilePath = [manager.mainBundleDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager moveFileAtPath:exampleFilePath to:manager.documentsDirectory];
 @endcode
 
 @note If @c directoryPath doesn't exist, it is created.
 
 @param filePath The path of the file you'd like to move.
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be moved.
 
 @return @c BOOL - @c YES if the file was moved, and @c NO if an error occured.
 */
- (BOOL)moveFileAtPath:(NSString *)filePath to:(NSString *)destinationDirectoryPath;


/*!
 @brief Moves a file to a specified directory synchronously.
 
 @discussion Synchronously performs a shallow move of the file with the path @c filePath to a directory with the path @c directoryPath.
 
 @code
 NSString *exampleFilePath = [manager.mainBundleDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager moveFileAtPath:exampleFilePath to:manager.documentsDirectory regardlessOfType:NO];
 @endcode
 
 @note If @c directoryPath doesn't exist, it is created.
 
 @warning Ignoring the type if not recommended. Do so at your own risk.
 
 @param filePath The path of the file you'd like to move.
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be moved.
 @param ignoreType If @c YES, continue with moving even if @c filePath is not a file.
 
 @return @c BOOL - @c YES if the file was moved, and @c NO if an error occured.
 */
- (BOOL)moveFileAtPath:(nonnull NSString *)filePath to:(nonnull NSString *)destinationDirectoryPath regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Finds, then moves a file to a specified directory.
 
 @discussion Recursively searches all accessible directories for a file named @c filename, then moves the first found instance to a directory with the path @c directoryPath.
 
 @code
 [manager findAndCopyFile:@"example.txt" to:manager.documentsDirectory];
 @endcode
 
 @note
 • If @c directoryPath doesn't exist, it is created.
 
 • Under the hood, this simply calls @c findAndGetPathForFile() then @c copyFile()
 
 @param filename The name of the file you'd like to find and move.
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be moved, once found.
 
 @return @c BOOL - @c YES if the file was moved, and @c NO if an error occured.
 */
- (BOOL)findAndMoveFileNamed:(NSString *)filename to:(NSString *)destinationDirectoryPath;



/*!
 @brief Deletes the file located at @c filePath.
 
 @discussion Deletes the file located at @c filePath.
 
 @code
 NSString *exampleFilePath = [manager.documentsDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager deleteFile:exampleFilePath];
 @endcode
 
 @param filePath The path of the file you'd like to delete.
 
 @return @c BOOL - @c YES if the file was deleted, and @c NO if an error occured.
 */
- (BOOL)deleteFileAtPath:(NSString *)filePath;


/*!
 @brief Deletes the file located at @c filePath.
 
 @discussion Deletes the file located at @c filePath.
 
 @code
 NSString *exampleFilePath = [manager.documentsDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager deleteFile:exampleFilePath regardlessOfType:NO];
 @endcode
 
 @param filePath The path of the file you'd like to delete.
 @param ignoreType If @c YES, continue with deleting even if @c filePath is not a file
 
 @return @c BOOL - @c YES if the file was deleted, and @c NO if an error occured.
 */
- (BOOL)deleteFileAtPath:(NSString *)filePath regardlessOfType:(BOOL)ignoreType;


/*!
 @brief Finds, then deletes a file named @c filename.
 
 @discussion Recursively searches all available directories for a file named @c filename, then deletes the first found instance.
 
 @code
 [manager findAndDeleteFile:@"example.txt"];
 @endcode
 
 @param filename The name of the file you'd like to delete, once found.
 
 @return @c BOOL - @c YES if the file was deleted, and @c NO if an error occured.
 */
- (BOOL)findAndDeleteFileNamed:(NSString *)filename;


/*!
 @brief Checks if a file exists at the given path.
 
 @discussion Checks if @c filePath is an existing file. Really, it's just a call through to @c NSFileManager, primarily provided for consistency.
 
 @code
 NSString *exampleFilePath = [manager.documentsDirectory stringByAppendingPathComponent:@"example.txt"];
 [manager fileExistsAtPath:exampleFilePath];
 @endcode
 
 @param filePath The path to the file you would like to verify the existence of.
 
 @return @c BOOL - @c YES if the file exists, and @c NO if it doesn't.
 */
- (BOOL)fileExistsAtPath:(NSString  *)filePath;


/*!
 @brief Returns the number of files in a directory.
 
 @discussion Returns the number of files in @c directoryPath.
 
 @code
 NSUInteger fileCount = [manager numberOfFilesInDirectoryAtPath:manager.documentsDirectory];
 @endcode
 
 @param directoryPath The path you'd like to count the contents of.
 
 @return @c NSUInteger - The number of files in the specified directory.
 */
- (NSUInteger)numberOfFilesInDirectoryAtPath:(NSString *)directoryPath;


/*!
 @brief Returns the data for the file at @c filePath.
 
 @discussion Creates a data object by reading every byte from the file at a @c filePath.
 
 @code
 NSString *exampleFilePath = [manager.documentsDirectory stringByAppendingPathComponent:@"example.txt"];
 NSData *fileData = [manager retrieveDataForFileAtPath:exampleFilePath];
 @endcode
 
 @param filePath The path to the file you'd like to get the data for.
 
 @return @c NSData - The data for the requested file - @c NULL if file doesn't exist.
 */
- (NSData*)retrieveDataForFileAtPath:(NSString *)filePath;


/*!
 @brief Sets the TOMFileManager object into Debug Mode.
 
 @discussion Sets the TOMFileManager object into Debug Mode. This will print all @c NSLog() statements, instead of just the ones containing errors. By default, Debug Mode is off.
 
 @code
 [manager setDebugMode:YES];
 @endcode
 
 @param debugMode If @c YES sets Debug Mode on, if @c NO sets Debug Mode off
 
 @return @c Void - there isn't anything to return.
 */
- (void)setDebugMode:(BOOL *)debugMode;




@end

NS_ASSUME_NONNULL_END
