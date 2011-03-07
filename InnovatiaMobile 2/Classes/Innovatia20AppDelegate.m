//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "Innovatia20AppDelegate.h"
#import "RootViewController.h"
#import "Note.h"

@interface Innovatia20AppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation Innovatia20AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize notes;


- (id)init {
	if (self = [super init]) {
		// 
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Innovatiav1.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Innovatiav1.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeDatabase {
    NSMutableArray *noteArray = [[NSMutableArray alloc] init];
    self.notes = noteArray;
    [noteArray release];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Innovatiav1.sqlite"];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        const char *sql = "SELECT pk FROM note ORDER BY pk ASC"; 
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int primaryKey = sqlite3_column_int(statement, 0);
				Note *td = [[Note alloc] initWithPrimaryKey:primaryKey database:database];
				
                [notes addObject:td];
                [td release];
            }
        }
       sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
}

-(void)removeNote:(Note *)note {
	NSUInteger index = [notes indexOfObject:note];
	
	if (index == NSNotFound) return;
	
	NSString *noteName = [note.text copy];
	
	//delete from DB and datasource
    [note deleteFromDatabase];
    [notes removeObject:note];
	
	//Remomove media files ie images, drwaings and sounds
	NSLog(@"Removing media");
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	noteName = [noteName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	NSString *ideaSoundDir = [NSString stringWithFormat:@"%@Sound.caf",noteName];
	NSString *soundFilePath = [documentsDirectory stringByAppendingPathComponent:ideaSoundDir];
	
	NSString *ideaPhotoDir = [NSString stringWithFormat:@"%@Photo.jpg",noteName];
	NSString *photoFilePath = [documentsDirectory stringByAppendingPathComponent:ideaPhotoDir];
	
	NSString *ideaDrawName = [NSString stringWithFormat:@"%@Draw.jpg",noteName];
	NSString *drawFilePath = [documentsDirectory stringByAppendingPathComponent:ideaDrawName];
	
    [fileManager removeItemAtPath:soundFilePath error:nil];
	[fileManager removeItemAtPath:photoFilePath error:nil];
	[fileManager removeItemAtPath:drawFilePath error:nil];
	
	[noteName release];
}

-(Note *) addNote {
	NSInteger primaryKey = [Note insertNewNoteIntoDatabase:database];
    Note *newNote = [[Note alloc] initWithPrimaryKey:primaryKey database:database];
	
	[notes addObject:newNote];
     return newNote;
}

-(void)addNote:(Note *)syncNote {
	NSLog(@"Searching note");
	BOOL found = NO;
	
	//ENUMERATE TO FIND UPDATE
	NSEnumerator * enumerator = [notes objectEnumerator];
	Note *listNote;
	
	while(listNote = [enumerator nextObject])
    {
		if ([listNote.text isEqualToString:syncNote.text]) {
			[listNote updateText:syncNote.text];
			[listNote updateDesc:syncNote.desc];
			found = YES;
		}
    }
	
	if (!found) {
		[syncNote insertSyncNoteIntoDatabase:database];
		[syncNote retain];
		[notes addObject:syncNote];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	[notes makeObjectsPerformSelector:@selector(dehydrate)];
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
