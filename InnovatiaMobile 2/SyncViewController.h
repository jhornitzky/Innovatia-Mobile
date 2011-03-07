//
//  SyncViewController.h
//  note
//
//  Created by g g on 20/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Innovatia20AppDelegate.h"
#import "Note.h"

@interface SyncViewController : UIViewController {
	IBOutlet UITextField        *noteUrl;
	IBOutlet UITextField        *noteUser;
	IBOutlet UITextField        *noteUserPass;
	IBOutlet UILabel            *responseLabel;
	IBOutlet UIActivityIndicatorView *progressSpinner;
	NSString *currentElement;
	NSMutableDictionary *currentNote;
	NSMutableString *currentTitle;
	NSMutableString *currentDesc;
	NSMutableString *currentDate;
	NSMutableArray *syncNotes;
	NSString *lastSyncDate;
	NSMutableData *responseData;
	int state; //0=nothing, 1=getSyncData, 2=sendingData
	int openConnectionCount;
	NSXMLParser *parser;
	CGFloat animatedDistance;
}

@property(nonatomic,retain) IBOutlet UITextField        *noteUrl;
@property(nonatomic,retain) IBOutlet UITextField        *noteUser;
@property(nonatomic,retain) IBOutlet UITextField        *noteUserPass;
@property(nonatomic,retain) NSMutableData				*responseData;
@property(nonatomic,retain) IBOutlet UILabel            *responseLabel;
@property(nonatomic,retain) NSMutableArray				*syncNotes;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *progressSpinner;
@property(nonatomic,retain) NSXMLParser *parser;

-(IBAction)startSync:(id)sender;
-(IBAction)closeView:(id)sender;
- (IBAction) updateDefaultConnectionDetails:(id) sender;
- (void)resetState;

@end
