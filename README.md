# TOMFileManager
TOMFileManager is a simple tool to manage your iOS App's files, written in Objective-C. Instead of using NSFileManager and the lengthy amount of code needed for a simple operation, you can write it in just one line with TOMFileManager!
<br>To be perfectly honest, there's not much that is super special about it - except instead of writing this:

```obj-c
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0]; 
NSString *newDirectory = [documentsDirectory stringByAppendingPathComponent:@"newDirectory"];

if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory])
{
	[[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:NO attributes:nil error:nil];
}
```

You can simply write this:

```obj-c
TOMFileManager *manager = [[TOMFileManager alloc] init];
[manager createSubdirectoryNamed:@"NewDirectory" in:manager.documentsDirectory];
```

Sure, almost anyone could write something like this, but why bother when its already written for you - for free!

Plus, this is the only file manager on GitHub with [Appldoc](https://github.com/tomaz/appledoc) style documentation, which can be found [here](http://www.opensource.southernerd.us/projects/tomfilemanager/docs/) (online documentation to be updated soon).



## Features
* Built with NSFileManager, using all the methods you'd probably be using already <br>
* Smart file & directory searching - Don't know the exact path of a file or directory? Let TOMFileManager find it for you! (***Exclusive!***)<br>
* Copy file / directory to directory <br>
   * &#43; Find & Copy (***Exclusive!***)
* Move file / directory to directory <br>
   * &#43; Find & Move (***Exclusive!***)
* Delete file / directory <br>
   * &#43; Find & Delete (***Exclusive!***)
* Retrieve NSData from file <br>
* Install via CocoaPods (***Coming Soon!***)<br>



## Requirements
* ARC enabled
* iOS 5.0 or higher



## Installation
### Without CocoaPods
1) Simply copy `TOMFileManager.h` and `TOMFileManager.m` into your project's files. <br>

2) In the file in which you'd like to use TOMFileManager, add the following line to your import statements:

```obj-c
#import "TOMFileManager.h"
```


### With CocoaPods (***Coming Soon!***)
Simply add the following to your `podfile`:

```ruby
pod 'TOMFileManager', '~> 2.0'
```
Then run a `pod install` inside your terminal, or from CocoaPods.app.



## Usage
To create a new TOMFileManager object (named manager in this example), simply write:

```obj-c
TOMFileManager *manager = [[TOMFileManager alloc] init];
```
<br>
If, for some reason, you don't want to initialize it right away, you can simply write:

```obj-c
TOMFileManager *manager = [TOMFileManager alloc];
```
However, before you can use it, you ***MUST*** initialize the TOMFileManager object:

```obj-c
[manager init];
```

<br>
Now that you've created your TOMFileManager object, you're reading to begin managing your files:


### Creating A New Directory
TOMFileManager does ***NOT*** default to any specific directory, so when making a new directory you will need to specify the ***FULL*** path of your new directory. Luckily, this is easy as TKFileManager does provide easy access to the directories you're likely to use:

```obj-c
manager.documentsDirectory  // Path for the Documents Directory
manager.resourcesDirectory  // Path for the Resources Directory
manager.libraryDirectory    // Path for the Library Directory
manager.tempDirectory       // Path for the Temp Directory
```
So, to create a new directory in your app's Documents Directory, you simply need to say:

```obj-c
[manager createDirectoryAtPath:[manager.documentsDirectory stringByAppendingPathComponent:@"NewDirectory"]];

```
Alternatively, you can accomplish this by using the `createSubdirectory` method:

```obj-c
[manager createSubdirectoryNamed:@"NewDirectory" in:manager.documentsDirectory];

```

To make things easier for you, `createSubdirectory` is smart enough to add "/" in front of your subdirectory's name, should you forget to. <br>
When using `createDirectory` you will either need to have the "/" already included in your path's string, or you'll need to use `stringByAppendingPathComponent`.


### Copying A Directory
Copying a directory makes a copy of the directory's files in a new location, while leaving the files in the original directory intact. <br>
To copy a directory, you need to have the full path to the directory you wish to copy and the full path of the directory to wish you would like to copy it. If the destination directory does not exist, it will be created. For this example, we will copy the contents of the `resourcesDirectory` to the `documentsDirectory`:

```obj-c
[manager copyDirectoryFrom:manager.resourcesDirectory to:manager.documentsDirectory];
```
***Note:*** that this does not create a "resourcesDirectory" subdirectory in the Documents Directory, but rather it copies the contents of `resourcesDirectory` directly to `documentsDirectory`. <br>
If you wish for the contents to be copied to a subdirectory of the Documents Directory, you will first need to create it and then copy into it:

```obj-c
NSString *resourcesInDocuments = [manager.documentsDirectory stringByAppendingPathComponent:@"ResourceFiles"];
[manager copyDirectoryFrom:manager.resourcesDirectory to: resourcesInDocuments];
```


### Moving A Directory
Moving a directory moves the a directory's files to a new location. The files are will no longer be able to be found the original directory, as they no longer exist there.  If the destination directory does not exist, it will be created. <br>
Like copying a directory, when moving a directory you must have the full path of the source directory and the destination directory:

```obj-c
NSString *resourcesInDocuments = [manager.documentsDirectory stringByAppendingPathComponent:@"ResourceFiles"];
[manager moveDirectoryFrom:manager.resourcesDirectory to: resourcesInDocuments];
```
***NOTE:*** It is NOT recommended that you actually move the contents of `resourcesDirectory` to any other directory.


### Deleting A Directory
Deleting a directory will delete it's contents and the directory itself from the parent directory. <br>
To delete a directory, you simple need to use the `deleteDirectory` method:

```obj-c
//(this example assumes "resourcesInDocuments" is a valid variable)
[manager deleteDirectory: resourcesInDocuments];
```
If the directory you are attempting to delete does not exist, nothing will happen.


### Copying A File
If you know a file's full path, you can copy it to a directory (if the destination directory doesn't exist, it will be created):

```obj-c
[manager copyFileAtPath:[manager.resourcesDirectory stringByAppendingPathComponent:@"default.n64skin"] to:manager.documentsDirectory];
```


### Moving A File
If you know a file's full path, you can move it to a directory (if the destination directory doesn't exist, it will be created):

```obj-c
[manager moveFileAtPath:[manager.resourcesDirectory stringByAppendingPathComponent:@"default.2600skin"] to:manager.documentsDirectory];
```
***Remember***: If you move a file, it will no longer be in the original directory


### Deleting A File
If you know a file's full path, you can delete it with the `deleteFileAtPath` method:

```obj-c
[manager deleteFileAtPath:[manager.documentsDirectory stringByAppendingPathComponent:@"testROM.z64"]];
```



### Getting A File's Path
If you know what directory a file is in, you can get it's full path be using the `getPathForFileNamed` method:

```obj-c
NSString *dogeMemePath = [manager getPathForFileNamed:@"doge.png" inDirectory:manager.documentsDirectory];
```
This will search through the directory & its subdirectories, and will return the full path for your file (handy if you don't know if its in a subdirectory or not). <br>

But, what if you don't know quite where a file's stored? Well, with TOMFileManager's exclusive `findAndGetPathForFileNamed` method, it will search all available directories (currently only Main Bundle & Documents) and all their subdirectories until it finds your file:

```obj-c
NSString *triggeredMemePath = [manager findAndGetPathForFileNamed:@"triggered.png"];
```
This feature also extends to moving, copying, and deleting a file, like so:

```obj-c
[manager findAndCopyFileNamed:@"repost.png" to:manager.documentsDirectory];
[manager findAndMoveFileNamed:@"moveItSomewhereElsePatrick.png" to:manager.documentsDirectory];
[manager findAndDeleteFileNamed:@"harambe.png"];
```



## License
TOMFileManager is licensed under the TOM Public License, which is reproduced in full in the [License](LICENSE) file. <br>
In short, attribution is encouraged and you assume full liability while using this software.



## Cool Projects That Use TOMFileManager
* Revera - A Nintendo 64 emulator for iOS devices



## Does Your Project Use TOMFileManager? 
If you've got an awesome project that uses TOMFileManager, contact me (info below) and I'll be sure to add your project to the list!



## Contact 
Please report all bugs to the "Issues" page here on GitHub. 
If you've got a cool project that uses TOMFileManager, need help figuring out how to use it (beyond what's provided in this guide), or you just want to say hi, you can contact me here: <br>

Twitter: <br>
[@tomnific](https://www.twitter.com/tomnific "Tom's Twitter") <br>

Email: <br>
[tom@southernderd.us](tom@southernderd.us "Tom's Email") <br>
