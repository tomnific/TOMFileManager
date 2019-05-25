//
//  TOMFileManager.swift
//  TOMFileManager-Example
//
//  Created by Tom Metzger on 11/12/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import Foundation





/**
# TOMFileManager
This class was developed to make file management in iOS easier and intuitive, with less lines of code and more control.

- Author: Tom Metzger
- Version: 2.0
- Copyright: © 2019, Tom Metzger

---
seealso: [Documentation Site](https://opensource.southernerd.us/projects/tomfilemanager/)
*/
class TOMFileManager : NSObject
{
	/// This readonly property holds the string path of the app's Documents Directory.
	let documentsDirectory : String
	
	/// This readonly property holds the string path of the app's Resources Directory.
	let resourcesDirectory : String
	
	/// This readonly property holds the string path of the app's Library Directoy
	let libraryDirectory : String
	
	/// This readonly property holds the string path of the app's Temp Directory
	let tempDirectory : String
	
	
	/// This property enables or disables additional logging
	var debugMode : Bool
	
	
	
	
	
	/**
	Initializes the `TOMFileManager` object.
	
	Assigns the correct paths to `documentsDirectory`, `resourcesDirectory`, `libraryDirectory`, and `tempDirectory`.
	
	It also initializes `debugMode` to `false`, but this can be changed later.
	
	```
	let manager : TOMFileManager = TOMFileManager.init()
	```
	*/
	override init()
	{
		var paths : Array<Any>
		
		
		debugMode = false
		
		
		paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		documentsDirectory = paths[0] as! String
		
		
		resourcesDirectory = Bundle.main.resourcePath!
		
		
		paths =  NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
		libraryDirectory = paths[0] as! String
		
		
		tempDirectory = FileManager.default.temporaryDirectory.path
	}
	
	
	
	
	/**
	Creates a new directory at `newDirectoryPath`.
	
	Creates a new directory at `newDirectoryPath`, if it doesn't already exist.
	
	```
	var newDirectoryPath = (manager.documentsDirectory as NSString).appendingPathComponent("NewDirectory")
	manager.createDirectory(atPath: newDirectoryPath)
	```
	
	- Warning: The path must be a valid path that is accessible in the app's sandbox.
	
	- Parameter newDirectoryPath: The full path for the directory you wish to create.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func createDirectory(atPath newDirectoryPath : String) throws
	{
		if !FileManager.default.fileExists(atPath: newDirectoryPath)
		{
			if debugMode
			{
				print("[TOMFileManager] INFO: Creating directory: '%@'.", newDirectoryPath)
			}
			
			try FileManager.default.createDirectory(atPath: newDirectoryPath, withIntermediateDirectories: false, attributes: nil)
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not create directory: '%@'.", newDirectoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: Directory already exists.");
			}
		}
	}
	
	
	
	
	/**
	Creates a subdirectory named `subdirectoryName` in `directoryPath`.
	
	Creates a subdirectory named `subdirectoryName` in `directoryPath`, if it doesn't already exist.
	
	```
	manager.createSubdirectory(named: "Subdirectory", in: manager.documentsDirectory)
	```
	
	- Note: If `subdirectoryName` does not contain "/" at the beginning, it will automatically be added.
	
	- Remark: Under the hood, this function builds a path by appending `subdirectoryName` to `existingDirectoryPath` as a path component, and then calls `createDirectory()` using this new path.
	
	- Warning: `existingDirectoryPath` must be a valid path that is accessible in the app's sandbox.
	
	- Parameter subdirectoryName: The name of the subdirectory you wish to create.
	- Parameter existingDirectoryPath: The path of the directory in which you wish to make a subdirectory.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func createSubdirectory(named subdirectoryName : String, in existingDirectoryPath : String) throws
	{
		var correctedSubDirectoryName = subdirectoryName
		
		if correctedSubDirectoryName.hasPrefix("/")
		{
			correctedSubDirectoryName.removeFirst()
		}
		
		
		let newDirectoryPath = (existingDirectoryPath as NSString).appendingPathComponent(correctedSubDirectoryName)
		
		try createDirectory(atPath: newDirectoryPath)
	}
	
	
	
	
	/**
	Copies the contents of one directory into another synchronously.
	
	Synchronously performs a shallow copy of the contents of `sourceDirectoryPath` into `destinationDirectoryPath`.
	
	```
	manager.copyDirectory(from: manager.resourcesDirectory, to: manager.documentsDirectory)
	```
	
	- Note:
	- If `destinationDirectoryPath` does not exist, it will be created.
	- It does not copy the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does copy other hidden files (files that begin with a period character).
	
	- Parameter sourceDirectoryPath: The path of the directory who's contents you'd like to copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the contents of `directoryPath` to be copied.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func copyDirectory(from sourceDirectoryPath : String, to destinationDirectoryPath : String) throws
	{
		// For maintanence reasons, we'll just call through to the alternate copy function
		try copyDirectory(from: sourceDirectoryPath, to: destinationDirectoryPath, regardlessOfType: false)
	}
	
	
	
	
	/**
	Copies the contents of one directory into another synchronously.
	
	Synchronously performs a shallow copy of the contents of `sourceDirectoryPath` into `destinationDirectoryPath`.
	
	```
	manager.copyDirectory(from: manager.resourcesDirectory, to: manager.documentsDirectory, regardlessOfType: false)
	```
	
	- Note:
	- If `destinationDirectoryPath` does not exist, it will be created.
	- It does not copy the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does copy other hidden files (files that begin with a period character).
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter sourceDirectoryPath: The path of the directory who's contents you'd like to copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the contents of `directoryPath` to be copied.
	- Parameter ignoreType: If `true`, continue with copying, even if `sourceDirectoryPath` is not a directory
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func copyDirectory(from sourceDirectoryPath : String, to destinationDirectoryPath : String, regardlessOfType ignoreType : Bool) throws
	{
		var sourceIsDirectory : ObjCBool = false
		
		
		if FileManager.default.fileExists(atPath: sourceDirectoryPath, isDirectory: &sourceIsDirectory)
		{
			if sourceIsDirectory.boolValue
			{
				if debugMode
				{
					NSLog("[TOMFileManager] INFO: Copying contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath)
				}
				
				try FileManager.default.copyItem(atPath: sourceDirectoryPath, toPath: destinationDirectoryPath)
			}
			else
			{
				if ignoreType
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: Copying contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
					}
					
					try FileManager.default.copyItem(atPath: sourceDirectoryPath, toPath: destinationDirectoryPath)
				}
				else
				{
					NSLog("[TOMFileManager] ERROR: Could not copy directory: '%@'.", sourceDirectoryPath)
					
					if debugMode
					{
						NSLog("   MOST LIKELY REASON: Source is not a directory.")
					}
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not copy directory: '%@'.", sourceDirectoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: Directory does not exist.")
			}
		}
	}
	
	
	
	
	/**
	Moves the contents of one directory into another synchronously.
	
	Synchronously performs a shallow move of the contents of `sourceDirectoryPath` into `destinationDirectoryPath`.
	
	```
	manager.moveDirectory(from: manager.resourcesDirectory, to: manager.documentsDirectory)
	```
	
	- Note:
	- If `destinationDirectoryPath` does not exist, it will be created.
	- It does not move the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does move other hidden files (files that begin with a period character).
	
	- Parameter sourceDirectoryPath: The path of the directory who's contents you'd like to move.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the contents of `directoryPath` to be moved.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func moveDirectory(from sourceDirectoryPath : String, to destinationDirectoryPath : String) throws
	{
		// For maintanence reasons, we'll just call through to the alternate move function
		try moveDirectory(from: sourceDirectoryPath, to: destinationDirectoryPath, regardlessOfType: false)
	}
	
	
	
	
	/**
	Moves the contents of one directory into another synchronously.
	
	Synchronously performs a shallow move of the contents of `sourceDirectoryPath` into `destinationDirectoryPath`.
	
	```
	manager.moveDirectory(from: manager.resourcesDirectory, to: manager.documentsDirectory, regardlessOfType: false)
	```
	
	- Note:
	- If `destinationDirectoryPath` does not exist, it will be created.
	- It does not move the current directory (“.”), parent directory (“..”), or resource forks (files that begin with “._”) but it does move other hidden files (files that begin with a period character).
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter sourceDirectoryPath: The path of the directory who's contents you'd like to move.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the contents of `directoryPath` to be moved.
	- Parameter ignoreType: If `true`, continue with moving even if `sourceDirectoryPath` is not a directory
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func moveDirectory(from sourceDirectoryPath : String, to destinationDirectoryPath : String, regardlessOfType ignoreType : Bool) throws
	{
		var sourceIsDirectory : ObjCBool = false
		
		
		if FileManager.default.fileExists(atPath: sourceDirectoryPath, isDirectory: &sourceIsDirectory)
		{
			if sourceIsDirectory.boolValue
			{
				if (debugMode)
				{
					NSLog("[TOMFileManager] INFO: Moving contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
				}
				
				try FileManager.default.moveItem(atPath: sourceDirectoryPath, toPath: destinationDirectoryPath)
			}
			else
			{
				if ignoreType
				{
					if (debugMode)
					{
						NSLog("[TOMFileManager] INFO: Moving contents of directory: '%@'.\nTo directory: '%@'.", sourceDirectoryPath, destinationDirectoryPath);
					}
					
					try FileManager.default.moveItem(atPath: sourceDirectoryPath, toPath: destinationDirectoryPath)
				}
				else
				{
					NSLog("[TOMFileManager] ERROR: Could not move directory: '%@'.", sourceDirectoryPath)
					
					if debugMode
					{
						NSLog("   MOST LIKELY REASON: Source is not a directory.");
					}
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not move directory: '%@'.", sourceDirectoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: Directory does not exist.");
			}
		}
	}
	
	
	
	
	/**
	Renames the directory located at `directoryPath` to `newName`.
	
	Renames the directory located at `directoryPath` to `newName`.
	
	```
	let directoryToRename = (manager.documentsDirectory as NSString).appendingPathComponent("SubDirectory")
	manager.renameDirectory(atPath: directoryToRename, to: "RenamedDirectory");
	```
	
	- Warning: Do not attempt to use this method to rename files.
	
	- Parameter directoryPath: The path of the directory you'd like to rename.
	- Parameter newName: The new name you'd like to give the directory.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func renameDirectory(atPath directoryPath : String, to newName : String) throws
	{
		// For maintanence reasons, we'll just call through to the alternate rename function
		try renameDirectory(atPath: directoryPath, to: newName, regardlessOfType: false)
	}
	
	
	
	
	/**
	Renames the directory located at `directoryPath` to `newName`.
	
	Renames the directory located at `directoryPath` to `newName`.
	
	```
	let directoryToRename = (manager.documentsDirectory as NSString).appendingPathComponent("SubDirectory")
	manager.renameDirectory(atPath: directoryToRename, to: "RenamedDirectory", regardlessOfType: true);
	```
	
	- Remark: Under the hood, what this really does is creates a new directory at the same level as `directoryPath` with the name of `newName`, then moves the contents of `directoryPath` to `newName`'s directory.
	
	- Warning: Do not attempt to use this method to rename files.
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter directoryPath: The path of the directory you'd like to rename.
	- Parameter newName: The new name you'd like to give the directory.
	- Parameter ignoreType: If `true`, continue with renaming even if the `directoryPath` is not a directory
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func renameDirectory(atPath directoryPath : String, to newName : String, regardlessOfType ignoreType : Bool) throws
	{
		var sourceIsDirectory : ObjCBool = false
		var pathOfNewName : String
		
		
		if newName.hasPrefix("/")
		{
			pathOfNewName = ((directoryPath as NSString).deletingLastPathComponent as NSString).appending(newName)
		}
		else
		{
			pathOfNewName = ((directoryPath as NSString).deletingLastPathComponent as NSString).appendingPathComponent(newName)
		}
		
		
		
		if FileManager.default.fileExists(atPath: directoryPath, isDirectory: &sourceIsDirectory)
		{
			if sourceIsDirectory.boolValue
			{
				if debugMode
				{
					NSLog("[TOMFileManager] INFO: Renaming directory: '%@'.\nTo: '%@'.", directoryPath, pathOfNewName);
				}
				
				try createDirectory(atPath: pathOfNewName)
				try moveDirectory(from: directoryPath, to: pathOfNewName)
			}
			else
			{
				if ignoreType
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: Renaming directory: '%@'.\nTo: '%@'.", directoryPath, pathOfNewName);
					}
					
					try createDirectory(atPath: pathOfNewName)
					try moveDirectory(from: directoryPath, to: pathOfNewName, regardlessOfType: true)
				}
				else
				{
					NSLog("[TOMFileManager] ERROR: Could not rename directory: '%@'.", directoryPath)
					
					if debugMode
					{
						NSLog("   MOST LIKELY REASON: Path is not a directory.");
					}
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not rename directory: '%@'.", directoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: Directory does not exist.");
			}
		}
	}
	
	
	
	
	/**
	Deletes a diectory and its contents.
	
	Deletes a diectory and its contents.
	
	```
	let directoryToDelete = (manager.documentsDirectory as NSString).appendingPathComponent("Subdirectory")
	manager.deleteDirectory(atPath: directoryToDelete);
	```
	
	- Parameter directoryPath: The path of the directory you'd like to delete.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func deleteDirectory(atPath directoryPath : String) throws
	{
		// For maintanence reasons, we'll just call through to the alternate delete function
		try deleteDirectory(atPath: directoryPath, regardlessOfType: false)
	}
	
	
	
	
	/**
	Deletes a diectory and its contents.
	
	Deletes a diectory and its contents.
	
	```
	let directoryToDelete = (manager.documentsDirectory as NSString).appendingPathComponent("Subdirectory")
	manager.deleteDirectory(atPath: directoryToDelete)
	```
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter directoryPath: The path of the directory you'd like to delete.
	- Parameter ignoreType: If `true`, continue with renaming even if the `directoryPath` is not a directory
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func deleteDirectory(atPath directoryPath : String, regardlessOfType ignoreType : Bool) throws
	{
		var isDirectory : ObjCBool = false
		
		
		if FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
		{
			if isDirectory.boolValue
			{
				if debugMode
				{
					NSLog("[TOMFileManager] INFO: Deleting directory: '%@'.", directoryPath);
				}
				
				try FileManager.default.removeItem(atPath: directoryPath)
			}
			else
			{
				if ignoreType
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: Deleting directory: '%@'.", directoryPath);
					}
					
					try FileManager.default.removeItem(atPath: directoryPath)
				}
				else
				{
					NSLog("[TOMFileManager] ERROR: Could not delete directory: '%@'.", directoryPath)
					
					if debugMode
					{
						NSLog("   MOST LIKELY REASON: It is not a directory.");
					}
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not delete directory: '%@'.", directoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: Directory does not exist.");
			}
		}
	}
	
	
	
	
	/**
	Returns the filepath of a file located in the desired directory.
	
	Returns the filepath of a file named `filename` located in the directory `directoryPath`, therefore verifying it exists in the expected location.
	
	```
	let fullPath = manager.getPathForFile(named: "sample.png", inDirectory: manager.documentsDirectory)
	```
	
	- Warning: `directoryPath` must be a directory, not a file.
	
	- Parameter filename: The name of the file who's full path you'd like to retrieve.
	- Parameter directoryPath: The path of the directory which contains the file `filename`.
	
	- Returns: `String` - The full path of the desired file.
	*/
	func getPathForFile(named filename : String, inDirectory directoryPath : String) throws -> String?
	{
		var fileFound : Bool = false
		let directoryURL = URL.init(fileURLWithPath: directoryPath)
		let keys = [URLResourceKey.isDirectoryKey]
		
		
		var isDirectory : ObjCBool = false
		if FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
		{
			if !isDirectory.boolValue
			{
				NSLog("[TOMFileManager] ERROR: Search Location is not a directory.")
				return nil
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Search Location does not exist.")
			return nil
		}
		
		
		let enumerator = FileManager.default.enumerator(at: directoryURL, includingPropertiesForKeys: keys, options: [], errorHandler: {(url, error) -> Bool in
			return true
		})
		
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Retrieving file: '%@'.\nFrom directory: '%@'.", filename, directoryPath)
		}
		
		
		for case let url as URL in enumerator!
		{
			if !(try url.resourceValues(forKeys: Set(keys)).isDirectory!)
			{
				if url.absoluteString.hasSuffix(filename)
				{
					fileFound = true
					return url.path
				}
			}
		}
		
		
		if !fileFound
		{
			NSLog("[TOMFileManager] ERROR: File not found.")
			return nil
		}
		else
		{
			// This should never be the case - but just to be safe
			NSLog("[TOMFileManager] ERROR: File found, but not returned.")
			return nil
		}
	}
	
	
	
	
	/**
	Returns the filepath of a file located in an unknown directory.
	
	Recursively searches all accessible directories in the app's sandbox and returns the path to the first instance of a file named `filename`.
	
	```
	let exampleFilePath = manager.findAndGetFilePath(named: "sample.png")
	```
	
	- Note: For use when the directory the desired file is located in is not known.
	
	- Parameter filename: The name of the file you'd like to retrieve the path of, but don't know the directory of.
	
	- Returns: `String` - The full path of the desired file.
	*/
	func findAndGetPathForFile(named filename : String) throws -> String?
	{
		var fileFound : Bool = false
		let documentsDirectoryURL = URL.init(fileURLWithPath: self.documentsDirectory)
		let resourcesDirectoryURL = URL.init(fileURLWithPath: self.resourcesDirectory)
		let libraryDirectoryURL = URL.init(fileURLWithPath: self.libraryDirectory)
		let tempDirectoryURL = URL.init(fileURLWithPath: self.tempDirectory)
		let keys = [URLResourceKey.isDirectoryKey]
		
		
		let documentsEnumerator = FileManager.default.enumerator(at: documentsDirectoryURL, includingPropertiesForKeys: keys, options: [], errorHandler: {(url, error) -> Bool in
			return true
		})
		
		let resourcesEnumerator = FileManager.default.enumerator(at: resourcesDirectoryURL, includingPropertiesForKeys: keys, options: [], errorHandler: {(url, error) -> Bool in
			return true
		})
		
		let libraryEnumerator = FileManager.default.enumerator(at: libraryDirectoryURL, includingPropertiesForKeys: keys, options: [], errorHandler: {(url, error) -> Bool in
			return true
		})
		
		let tempEnumerator = FileManager.default.enumerator(at: tempDirectoryURL, includingPropertiesForKeys: keys, options: [], errorHandler: {(url, error) -> Bool in
			return true
		})
		
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Searching Documents Directory for file: '%@'.", filename)
		}
		
		for case let url as URL in documentsEnumerator!
		{
			if !(try url.resourceValues(forKeys: Set(keys)).isDirectory!)
			{
				if url.absoluteString.hasSuffix(filename)
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: File found at path: '%@'.", url.path)
					}
					
					fileFound = true
					return url.path
				}
			}
		}
		
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Searching Resources Directory for file: '%@'.", filename);
		}
		
		for case let url as URL in resourcesEnumerator!
		{
			if !(try url.resourceValues(forKeys: Set(keys)).isDirectory!)
			{
				if url.absoluteString.hasSuffix(filename)
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: File found at path: '%@'.", url.path);
					}
					
					fileFound = true
					return url.path
				}
			}
		}
		
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Searching Library Directory for file: '%@'.", filename);
		}
		
		for case let url as URL in libraryEnumerator!
		{
			if !(try url.resourceValues(forKeys: Set(keys)).isDirectory!)
			{
				if url.absoluteString.hasSuffix(filename)
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: File found at path: '%@'.", url.path);
					}
					
					fileFound = true
					return url.path
				}
			}
		}
		
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Searching Temp Directory for file: '%@'.", filename);
		}
		
		for case let url as URL in tempEnumerator!
		{
			if !(try url.resourceValues(forKeys: Set(keys)).isDirectory!)
			{
				if url.absoluteString.hasSuffix(filename)
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: File found at path: '%@'.", url.path);
					}
					
					fileFound = true
					return url.path
				}
			}
		}
		
		
		if !fileFound
		{
			NSLog("[TOMFileManager] ERROR: File not found.")
			return nil
		}
		else
		{
			// This should never be the case - but just to be safe
			NSLog("[TOMFileManager] ERROR: File found, but not returned.")
			return nil
		}
	}
	
	
	
	
	/**
	Copies a file to a specified directory synchronously.
	
	Synchronously performs a shallow copy of the file with the path `filePath` to a directory with the path `directoryPath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.copyFile(atPath: exampleFilePath, to: manager.documentsDirectory)
	```
	
	- Note: If `directoryPath` doesn't exist, it is created.
	
	- Parameter filePath: The path of the file you'd like to copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the file to be copied.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func copyFile(atPath filePath : String, to destinationDirectoryPath : String) throws
	{
		try copyFile(atPath: filePath, to: destinationDirectoryPath, regardlessOfType: false)
	}
	
	
	
	
	/**
	Copies a file to a specified directory synchronously.
	
	Synchronously performs a shallow copy of the file with the path `filePath` to a directory with the path `directoryPath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.copyFile(atPath: exampleFilePath, to: manager.documentsDirectory)
	```
	
	- Note: If `directoryPath` doesn't exist, it is created.
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter filePath: The path of the file you'd like to copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the file to be copied.
	- Parameter ignoreType: If `true`, continue with copying even if `filePath` is not a file.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func copyFile(atPath filePath : String, to destinationDirectoryPath : String, regardlessOfType ignoreType : Bool) throws
	{
		var sourceIsDirectory : ObjCBool = true
		var destinationIsDirectory : ObjCBool = true
		var correctedDestinationDirectoryPath : String
		
		
		if !FileManager.default.fileExists(atPath: destinationDirectoryPath, isDirectory: &destinationIsDirectory)
		{
			try createDirectory(atPath: destinationDirectoryPath)
			correctedDestinationDirectoryPath = (destinationDirectoryPath as NSString).appendingPathComponent((filePath as NSString).lastPathComponent)
		}
		else
		{
			if destinationIsDirectory.boolValue
			{
				correctedDestinationDirectoryPath = (destinationDirectoryPath as NSString).appendingPathComponent((filePath as NSString).lastPathComponent)
			}
			else
			{
				correctedDestinationDirectoryPath = destinationDirectoryPath
			}
		}
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Full path of file copy: '%@'.", correctedDestinationDirectoryPath)
		}
		
		
		if FileManager.default.fileExists(atPath: filePath, isDirectory: &sourceIsDirectory)
		{
			if FileManager.default.isReadableFile(atPath: filePath)
			{
				if !sourceIsDirectory.boolValue
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: Copying file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
					}
					
					try FileManager.default.copyItem(atPath: filePath, toPath: correctedDestinationDirectoryPath)
				}
				else
				{
					if ignoreType
					{
						if debugMode
						{
							NSLog("[TOMFileManager] INFO: Copying file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
						}
						
						try FileManager.default.copyItem(atPath: filePath, toPath: correctedDestinationDirectoryPath)
					}
					else
					{
						NSLog("[TOMFileManager] ERROR: Could not copy file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath)
						
						if debugMode
						{
							NSLog("   MOST LIKELY REASON: Source is not a file.");
						}
					}
				}
			}
			else
			{
				NSLog("[TOMFileManager] ERROR: Could not copy file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath)
				
				if debugMode
				{
					NSLog("   MOST LIKELY REASON: Permissions Error.");
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not copy file: '%@'.", filePath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: File Does Not Exist.");
			}
		}
	}
	
	
	
	
	/**
	Finds, then copies a file to a specified directory.
	
	Recursively searches all accessible directories for a file named `filename`, then copies the first found instance to a directory with the path `directoryPath`.
	
	```
	manager.findAndCopyFile(named: "example.txt", to: manager.documentsDirectory)
	```
	
	- Note: If `directoryPath` doesn't exist, it is created.
	
	- Remark: Under the hood, this simply calls `findAndGetPathForFile()` then `copyFile()`
	
	- Parameter filename: The name of the file you'd like to find and copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the file to be copied, once found.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func findAndCopyFile(named filename : String, to destinationDirectoryPath : String) throws
	{
		let pathOfFile = try findAndGetPathForFile(named: filename)
		
		
		if pathOfFile != nil
		{
			try copyFile(atPath: pathOfFile!, to: destinationDirectoryPath)
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not find and copy file: '%@'.\nTo: '%@'.", filename, destinationDirectoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: File was not found.");
			}
		}
	}
	
	
	
	
	/**
	Moves a file to a specified directory synchronously.
	
	Synchronously performs a shallow move of the file with the path `filePath` to a directory with the path `directoryPath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.moveFile(atPath: exampleFilePath, to: manager.documentsDirectory)
	```
	
	- Note: If `directoryPath` doesn't exist, it is created.
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter filePath: The path of the file you'd like to move.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the file to be moved.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func moveFile(atPath filePath : String, to destinationDirectoryPath : String) throws
	{
		try moveFile(atPath: filePath, to: destinationDirectoryPath, regardlessOfType: false)
	}
	
	
	
	
	/**
	Moves a file to a specified directory synchronously.
	
	Synchronously performs a shallow move of the file with the path `filePath` to a directory with the path `directoryPath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.moveFile(atPath: exampleFilePath, to: manager.documentsDirectory, regardlessOfType: true)
	```
	
	- Note: If `directoryPath` doesn't exist, it is created.
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter filePath: The path of the file you'd like to copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the file to be copied.
	- Parameter ignoreType: If `true`, continue with moving even if `filePath` is not a file
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func moveFile(atPath filePath : String, to destinationDirectoryPath : String, regardlessOfType ignoreType : Bool) throws
	{
		var sourceIsDirectory : ObjCBool = true
		var destinationIsDirectory : ObjCBool = true
		var correctedDestinationDirectoryPath : String
		
		
		if !FileManager.default.fileExists(atPath: destinationDirectoryPath, isDirectory: &destinationIsDirectory)
		{
			try createDirectory(atPath: destinationDirectoryPath)
			correctedDestinationDirectoryPath = destinationDirectoryPath
		}
		else
		{
			if destinationIsDirectory.boolValue
			{
				correctedDestinationDirectoryPath = (destinationDirectoryPath as NSString).appendingPathComponent((filePath as NSString).lastPathComponent)
			}
			else
			{
				correctedDestinationDirectoryPath = destinationDirectoryPath
			}
		}
		
		if debugMode
		{
			NSLog("[TOMFileManager] INFO: Full path of file move: '%@'.", correctedDestinationDirectoryPath)
		}
		
		
		if FileManager.default.fileExists(atPath: filePath, isDirectory: &sourceIsDirectory)
		{
			if FileManager.default.isReadableFile(atPath: filePath)
			{
				if !sourceIsDirectory.boolValue
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: Moving file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath)
					}
					
					try FileManager.default.moveItem(atPath: filePath, toPath: correctedDestinationDirectoryPath)
				}
				else
				{
					if ignoreType
					{
						if debugMode
						{
							NSLog("[TOMFileManager] INFO: Moving file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath);
						}
						
						try FileManager.default.moveItem(atPath: filePath, toPath: correctedDestinationDirectoryPath)
					}
					else
					{
						NSLog("[TOMFileManager] ERROR: Could not move file: '%@'.\nTo: '%@'.", filePath, correctedDestinationDirectoryPath)
						
						if debugMode
						{
							NSLog("   MOST LIKELY REASON: Source is not a file");
						}
					}
				}
			}
			else
			{
				NSLog("[TOMFileManager] ERROR: Could not move file: '%@'.", filePath)
				
				if debugMode
				{
					NSLog("   MOST LIKELY REASON: Permissions error.");
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not move file: '%@'.", filePath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: File does not exist.");
			}
		}
	}
	
	
	
	
	/**
	Finds, then moves a file to a specified directory.
	
	Recursively searches all available directories for a file named `filename`, then moves the first found instance to a directory with the path `directoryPath`.
	
	```
	manager.findAndMoveFile(named: "example.txt", to: manager.documentsDirectory)
	```
	
	- Note: If `directoryPath` doesn't exist, it is created.
	
	- Remark: Under the hood, this simply calls `findAndGetPathForFile()` then `moveFile()`
	
	- Parameter filename: The name of the file you'd like to find and copy.
	- Parameter destinationDirectoryPath: The path of the directory into which you'd like the file to be copied, once found.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func findAndMoveFile(named filename : String, to destinationDirectoryPath : String) throws
	{
		let pathOfFile = try findAndGetPathForFile(named: filename)
		
		
		if pathOfFile != nil
		{
			try moveFile(atPath: pathOfFile!, to: destinationDirectoryPath)
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not find and move file: '%@'.\nTo: '%@'.", filename, destinationDirectoryPath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: File was not found.");
			}
		}
	}
	
	
	
	
	/**
	Deletes the file located at `filePath`.
	
	Deletes the file located at `filePath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.deleteFile(atPath: exampleFilePath)
	```
	
	- Parameter filePath: The path of the file you'd like to delete.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func deleteFile(atPath filePath : String) throws
	{
		try deleteFile(atPath: filePath, regardlessOfType: false)
	}
	
	
	
	
	/**
	Deletes the file located at `filePath`.
	
	Deletes the file located at `filePath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.deleteFile(atPath: exampleFilePath, regardlessOfType: true)
	```
	
	- Warning: Ignoring the type if not recommended. Do so at your own risk.
	
	- Parameter filePath: The path of the file you'd like to delete.
	- Parameter ignoreType: If `true`, continue with deleting even if `filePath` is not a file
	
	- returns : `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func deleteFile(atPath filePath : String, regardlessOfType ignoreType : Bool) throws
	{
		var fileIsDirectory : ObjCBool = false
		
		
		if FileManager.default.fileExists(atPath: filePath, isDirectory: &fileIsDirectory)
		{
			if FileManager.default.isReadableFile(atPath: filePath)
			{
				if !fileIsDirectory.boolValue
				{
					if debugMode
					{
						NSLog("[TOMFileManager] INFO: Deleting file: '%@'.", filePath);
					}
					
					try FileManager.default.removeItem(atPath: filePath)
				}
				else
				{
					if ignoreType
					{
						if debugMode
						{
							NSLog("[TOMFileManager] INFO: Deleting file: '%@'.", filePath);
						}
						
						try FileManager.default.removeItem(atPath: filePath)
					}
					else
					{
						NSLog("[TOMFileManager] ERROR: Could not delete file: '%@'.", filePath)
						
						if debugMode
						{
							NSLog("   MOST LIKELY REASON: Source is not a file.");
						}
					}
				}
			}
			else
			{
				NSLog("[TOMFileManager] ERROR: Could not delete file: '%@'.", filePath)
				
				if debugMode
				{
					NSLog("   MOST LIKELY REASON: Permissions error.");
				}
			}
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not delete file: '%@'.", filePath)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: File does not exist.");
			}
		}
	}
	
	
	
	
	/**
	Finds, then deletes a file named `filename`.
	
	Recursively searches all available directories for a file named `filename`, then deletes the first found instance.
	
	```
	manager.findAndDeleteFile(named: "example.txt")
	```
	
	- Parameter filename: The name of the file you'd like to delete, once found.
	
	- Returns: `Void` - Nothing to return since errors are handled with `try` / `catch`.
	*/
	func findAndDeleteFile(named filename : String) throws
	{
		let pathOfFile = try findAndGetPathForFile(named: filename)
		
		
		if pathOfFile != nil
		{
			try deleteFile(atPath: pathOfFile!)
		}
		else
		{
			NSLog("[TOMFileManager] ERROR: Could not find and delte file: '%@'.", filename)
			
			if debugMode
			{
				NSLog("   MOST LIKELY REASON: File was not found.");
			}
		}
	}
	
	
	
	
	/**
	Checks if a file exists at the given path
	
	Checks if `filePath` is an existing file. Really, it's just a call through to `NSFileManager`, primarily provided for consistency.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	manager.fileExistsAtPath(exampleFilePath)
	```
	
	- Parameter filePath: filePath The path to the file you would like to verify the existence of.
	
	- Returns: `Bool` - `true` if the file exists, and `false0` if it doesn't.
	*/
	func fileExists(atPath filePath : String) -> Bool
	{
		return FileManager.default.fileExists(atPath: filePath)
	}
	
	
	
	
	/**
	Returns the number of files in a directory.
	
	Returns the number of files in `directoryPath`.
	
	```
	let fileCount = manager.numberOfFilesInDirectory(atPath: manager.documentsDirectory)
	```
	
	- Parameter directoryPath: The path you'd like to count the contents of.
	
	- Returns: `Int` - The number of files in the specified directory.
	*/
	func numberOfFilesInDirectory(atPath directoryPath : String) -> Int
	{
		return FileManager.default.contents(atPath: directoryPath)?.count ?? 0
	}
	
	
	
	
	/**
	Returns the data for the file at `filePath`.
	
	Creates a data object by reading every byte from the file at a `filePath`.
	
	```
	let exampleFilePath = (manager.documentsDirectory as NSString).appendingPathComponent("example.png")
	let fileData = manager.retrieveDataForFile(atPath: exampleFilePath)
	```
	
	- Parameter filePath: The path to the file you'd like to get the data for.
	
	- Returns: `NSData` - The data for the requested file - `NULL` if file doesn't exist.
	*/
	func retrieveDataForFile(atPath filePath : String) -> NSData?
	{
		if self.fileExists(atPath: filePath)
		{
			return NSData.init(contentsOfFile: filePath)
		}
		else
		{
			return nil
		}
	}
	
	
	
	
	/**
	Sets the TOMFileManager object into Debug Mode.
	
	Sets the TOMFileManager object into Debug Mode.
	
	This will log more information than just errors.
	
	```
	manager.setDebugMode(to: true)
	```
	
	- Note: By default, Debug Mode is off.
	
	- Parameter debugMode: A Boolean that if `true` sets Debug Mode on, if `false` sets Debug Mode off
	
	- Returns: `Void` - Nothing to return.
	*/
	func setDebugMode(to debugMode : Bool)
	{
		if self.debugMode
		{
			NSLog("[TOMFileManager] INFO: Setting debug mode to: '%@'.", debugMode.description)
		}
		
		
		self.debugMode = debugMode
	}
}
