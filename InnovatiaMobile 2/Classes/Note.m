//
//  shareViewController.h
//  note
//
//  Created by g g on 1/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "Note.h"

static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *dehydrate_statment = nil;
static sqlite3_stmt *delete_statment = nil;
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *insertSync_statement = nil;

@implementation Note
@synthesize primaryKey,text,priority,status,desc,visibility;

+ (NSInteger)insertNewNoteIntoDatabase:(sqlite3 *)database {

    if (insert_statement == nil) {
        static char *sql = "INSERT INTO note (text,description,visibility,licence) VALUES ('New Idea','','PRIV','Closed')";
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    int success = sqlite3_step(insert_statement);

    sqlite3_reset(insert_statement);
    if (success != SQLITE_ERROR) {
        return sqlite3_last_insert_rowid(database);
    }
    NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    return -1;
}

- (void)insertSyncNoteIntoDatabase:(sqlite3 *)database {
	self.text = [self.text stringByReplacingOccurrencesOfString:@"'" withString:@""];
	self.desc = [self.desc stringByReplacingOccurrencesOfString:@"'" withString:@""];
	NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO note (text,description,visibility,licence) VALUES('%@','%@','PRIV','Closed')",
						   self.text, self.desc];
	
	NSLog(sqlString);
		char *sql = [sqlString UTF8String];
		if (sqlite3_prepare_v2(database, sql, -1, &insertSync_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
		sqlite3_step(insertSync_statement);
	
		sqlite3_reset(insertSync_statement);
}

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	
	if (self = [super init]) {
        primaryKey = pk;
        database = db;
        // Compile the query for retrieving book data. See insertNewBookIntoDatabase: for more detail.
        if (init_statement == nil) {
            // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
            // This is a great way to optimize because frequently used queries can be compiled once, then with each
            // use new variable values can be bound to placeholders.
            const char *sql = "SELECT text,priority,complete,description,visibility FROM note WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // For this query, we bind the primary key to the first (and only) placeholder in the statement.
        // Note that the parameters are numbered from 1, not from 0.
        sqlite3_bind_int(init_statement, 1, primaryKey);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
			self.priority = sqlite3_column_int(init_statement,1);
			self.status = sqlite3_column_int(init_statement,2);
			self.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 3)];
		} else {
            self.text = @"Nothing";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
    }
    return self;
}

- (void)updateStatus:(NSInteger)newStatus {
	self.status = newStatus;
	dirty = YES;
}

- (void)updatePriority:(NSInteger)newPriority {
	self.priority = newPriority;
	dirty = YES;
}

- (void)updateText:(NSString *)newTitle {
	self.text = newTitle;
	dirty = YES;
}

- (void)updateDesc:(NSString *)newDesc {
	self.desc = newDesc;
	dirty = YES;
}

- (void) dehydrate {
	if(dirty) {
		if (dehydrate_statment == nil) {
			const char *sql = "UPDATE note SET text = ? , description = ? WHERE pk=?";
			if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statment, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
			}
		}
		
		//LOCATION and DATES HERE!!!!
		
		sqlite3_bind_int(dehydrate_statment, 3, self.primaryKey);
		sqlite3_bind_text(dehydrate_statment, 2, [self.desc UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(dehydrate_statment, 1, [self.text UTF8String], -1, SQLITE_TRANSIENT);
		int success = sqlite3_step(dehydrate_statment);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_reset(dehydrate_statment);
		dirty = NO;
	}
	
}

-(void) deleteFromDatabase {
	if (delete_statment == nil) {
		const char *sql = "DELETE FROM note WHERE pk=?";
		if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(delete_statment, 1, self.primaryKey);
	int success = sqlite3_step(delete_statment);
	
	if (success != SQLITE_DONE) {
		NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(delete_statment);
}

@end
