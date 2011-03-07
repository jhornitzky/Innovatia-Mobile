//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Note.h"
#import "ShareViewController.h"
#import "DrawViewController.h"
#import "SoundViewController.h"
#import "PhotoViewController.h"
#import "TwitViewController.h"

@interface NoteViewController : UIViewController <UITextViewDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
	IBOutlet UITextField        *noteText;
	IBOutlet UISegmentedControl *notePriority;
	IBOutlet UILabel            *noteStatus;
	IBOutlet UIButton			*noteButton;
	IBOutlet UITextView       *noteDesc;
	Note						*note;
	PhotoViewController *photoView;
	ShareViewController *shareView;
	DrawViewController *drawView;
	SoundViewController *soundView;
	TwitViewController *twitView;
	BOOL viewShifted;
}

@property(nonatomic,retain) PhotoViewController *photoView;
@property(nonatomic,retain) DrawViewController *drawView;
@property(nonatomic,retain) ShareViewController *shareView;
@property(nonatomic,retain) SoundViewController *soundView;
@property(nonatomic,retain) TwitViewController *twitView;
@property(nonatomic,retain) IBOutlet UITextField        *noteText;
@property(nonatomic,retain) IBOutlet UITextView          *noteDesc;
@property(nonatomic,retain) IBOutlet UISegmentedControl *notePriority;
@property(nonatomic,retain) IBOutlet UILabel            *noteStatus;
@property(nonatomic,retain) IBOutlet UIButton           *noteButton;
@property(nonatomic,retain) Note						*note;

- (IBAction) updateText:(id) sender;
- (IBAction) updateDesc:(id) sender;

- (IBAction) openImage:(id) sender;
- (IBAction) openVoice:(id) sender;
- (IBAction) openDraw:(id) sender;

- (IBAction) shareIdea:(id) sender;
- (IBAction) emailIdea:(id) sender;
- (IBAction) tweetIdea:(id) sender;

@end
