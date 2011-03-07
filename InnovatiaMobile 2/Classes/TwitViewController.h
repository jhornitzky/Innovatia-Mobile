//
//  TwitViewController.h
//  Innovatia20
//
//  Created by g g on 9/10/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterRequest.h"
#import "Note.h"

@interface TwitViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField        *noteUrl;
	IBOutlet UITextField        *noteUser;
	IBOutlet UITextField        *noteUserPass;
	IBOutlet UILabel            *noteName;
	IBOutlet UILabel            *responseLabel;
	IBOutlet UIActivityIndicatorView			*progressSpinner;
	Note *note;
	NSMutableData *responseData;
	CGFloat animatedDistance;
}

@property(nonatomic,retain) IBOutlet UITextField        *noteUrl;
@property(nonatomic,retain) IBOutlet UITextField        *noteUser;
@property(nonatomic,retain) IBOutlet UITextField        *noteUserPass;
@property(nonatomic,retain) IBOutlet UILabel            *noteName;
@property(nonatomic,retain) IBOutlet UILabel            *responseLabel;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView    *progressSpinner;
@property(nonatomic,retain) Note						*note;
@property(nonatomic,retain) NSMutableData				*responseData;

- (IBAction) updateDefaultConnectionDetails:(id) sender;
- (IBAction) closeView:(id)sender;
- (IBAction) postTweet: (id) sender;

@end
