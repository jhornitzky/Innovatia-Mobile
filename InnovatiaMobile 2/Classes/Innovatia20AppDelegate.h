//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Note.h"

@interface Innovatia20AppDelegate : NSObject <UIApplicationDelegate> {
	
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;

	sqlite3 *database;
	NSMutableArray *notes;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *notes;

-(void)removeNote:(Note *)note;
-(Note *)addNote;
-(void)addNote:(Note *)syncNote;

@end

