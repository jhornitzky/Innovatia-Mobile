//
//  shareViewController.h
//  note
//
//  Created by g g on 1/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Note : NSObject {
	sqlite3   *database;
	NSString  *text;
	NSString  *desc;
	NSString  *visibility;
	NSInteger primaryKey;
	NSInteger priority;
	NSInteger status;
	BOOL dirty;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *visibility;
@property (nonatomic) NSInteger priority;
@property (nonatomic) NSInteger status;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)updateStatus:(NSInteger) newStatus;
- (void)updatePriority:(NSInteger) newPriority;
- (void)updateText:(NSString *) newText;
- (void)updateDesc:(NSString *) newDesc;
- (void)dehydrate;
- (void)deleteFromDatabase;
- (void)insertSyncNoteIntoDatabase:(sqlite3 *)database;

+ (NSInteger)insertNewNoteIntoDatabase:(sqlite3 *)database;

@end
