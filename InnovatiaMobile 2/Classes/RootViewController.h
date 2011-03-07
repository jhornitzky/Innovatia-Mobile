//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h"
#import "SyncViewController.h"

@interface RootViewController : UITableViewController <UISearchBarDelegate> {
	NoteViewController *noteView;
	SyncViewController *syncView;
	BOOL searching;
	NSMutableArray *searchResults;
}

@property(nonatomic,retain) NoteViewController *noteView;
@property(nonatomic,retain) SyncViewController *syncView;

- (IBAction) showSync:(id) sender;

@end
