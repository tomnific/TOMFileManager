//
//  ViewController.m
//  TOMFileManager-Example
//
//  Created by Tom Metzger on 11/12/18.
//  Copyright © 2018 Tom. All rights reserved.
//

#import "ViewController.h"
#import "TOMFileManager.h"





@interface ViewController ()

@end





@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
	/*
	 * SECTION 1: The Basics
	 *    Note: The results will vary slightly based on if it is the initial intall/run of the app or not, as the file changes stay after the app finishes running
	 *          (i.e. there will be no need to copy 'example2.txt' into the documents directory, as it is already there after the first run)
	 */
	// Creates a new TOMFileManager object.
	TOMFileManager *manager = [[TOMFileManager alloc] init];
	
	// Creates a new directory named 'SampleNewDirectory' in the Documents Directory. (If the directory doesn't exist)
	[manager createDirectoryAtPath:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"]];
	
	// Creates a new subdirecotry in the Documents Directory named 'SampleSubdirectory'. (If it doesn't already exist)
	[manager createSubdirectoryNamed:@"SampleSubdriectory" in:manager.documentsDirectory];
	
	// Copies the file 'example.txt' to the previously created 'SampleNewDirectory'. (If 'SampleDirectory' didn't already exist, it would be created)
	[manager copyFileAtPath:[manager.resourcesDirectory stringByAppendingPathComponent:@"example.txt"] to:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"]];
	
	// Copies the contents of the previously created 'SampleNewDirectory' into a NEW directory named 'SampleDirectory2' in the Documents Directory.
	[manager copyDirectoryFrom:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"] to:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory2"]];
	
	// Moves the contents of the newly created 'SampleDirectory2' into the previously created 'SampleSubdirectory'. 'SampleDirectory2' is deleted as a result of this operation.
	[manager moveDirectoryFrom:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory2"] to:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleSubdriectory"]];
	
	// Deletes the previously created 'SampleSubdirectory'.
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleSubdriectory"]];
	
	
	/*
	 * SECTION 2: The Not-So Basics
	 */
	// WOW! That was a lot of moving around of files. I wonder where our 'example.txt' file is. Luckily our TOMFileManager can find it for us!
	NSString *exampleFilePath = [manager findAndGetPathForFileNamed:@"example.txt"];
	
	// Now that we've found the example file, lets move it over to a new location. Since we're moving a file and not a directory, the directory its located in remains in tact. Note that we are also creating a new directory by doing this
	[manager moveFileAtPath:exampleFilePath to:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile"]];
	
	// Actually, I don't like the directory name 'ExampleTextFile'. Lets rename it to something fitting for all example files, like 'ExampleFiles'
	[manager renameDirectoryAtPath:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile"] to:@"ExampleFiles"];
	
	
	/*
	 * SECTION 3: The Adanced Stuff
	 */
	// But, what if I told you that we could have done the last section with just one line of code? Well, you can!
	[manager findAndMoveFileNamed:@"example.txt" to:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile2"]];
	
	// We don't really need that file anymore, lets get rid of it.
	[manager findAndDeleteFileNamed:@"example.txt"];
	
	// In fact, we don't need the any of the subdirectoryies in the Documents Directory
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"]];
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile2"]];
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleFiles"]];
	
	// Now that we've cleaned all that up, lets copy 'example2.txt'. Wait, where is it? Documents or Main Bundle? Luckily, we can find and copy in one step too!
	[manager findAndCopyFileNamed:@"example2.txt" to:manager.documentsDirectory];
	
	
	/*
	 * SECTION 4: The New Stuff
	 */
	// Let's see what's inside 'example2.txt'
	// First, let's double check that it exists
	if ([manager fileExistsAtPath:[manager.documentsDirectory stringByAppendingPathComponent:@"example2.txt"]])
	{
		// Now, let's retrieve the data! (by the way, the above check is unnecessary because retrieveDataForFileAtPath checks if it exists for us)
		NSData *exampleData = [manager retrieveDataForFileAtPath:[manager.documentsDirectory stringByAppendingPathComponent:@"example2.txt"]];
	}
	
	// We don't really care to use the data of the file - but I wonder how many files are in the documents directory now...
	 NSUInteger fileCount = [manager numberOfFilesInDirectoryAtPath:manager.documentsDirectory]; // no, we won't actually use this for anything either
	
	
	/*
	 * SECTION 5: The Outroduction
	 */
	// That's All Folks! Now you're and expert with managing files with TOMFileManager.
	// Not all of the available methods were shown off here, but this should be enough for you to understand how this thing works.
	// More methods are being added, but for now, you should be able to perform any operation you may need with a combination of operations here
	// If you have an operation you'd like to be added, you can contact me on Twitter: @tomnific, or you can email me: tom@southernerd.us
	// Thanks for using TOMFileManager! Happy Managing!
}


@end
