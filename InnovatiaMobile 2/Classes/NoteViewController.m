//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "NoteViewController.h"

@implementation NoteViewController

@synthesize noteText,noteDesc,notePriority,noteStatus,noteButton,note;

@synthesize photoView, soundView,shareView, drawView, twitView;

- (void)viewDidLoad {
	[super viewDidLoad];
	[noteDesc setScrollEnabled:YES]; // Initialization code
	viewShifted = FALSE;
}

- (IBAction) updateText:(id) sender {
	[self.note updateText:self.noteText.text];
}

- (IBAction) updateDesc:(id) sender {
	[self.note updateDesc:self.noteDesc.text];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; 
}


- (void)dealloc {
	[super dealloc];
}

- (IBAction) openImage:(id) sender {
	self.photoView = nil;
	if(self.photoView == nil) {
		PhotoViewController *viewController = [[PhotoViewController alloc] 
											  initWithNibName:@"PhotoViewController" bundle:[NSBundle mainBundle]];
		self.photoView = viewController;
		[viewController release];
	}
	[self.navigationController pushViewController:self.photoView animated:YES];
	self.photoView.title = @"Photo";
	self.photoView.itemName = note.text;
	[self.photoView setup];
}


- (IBAction) openVoice:(id) sender {
	NSLog(@"Opening Voice");
	if(self.soundView == nil) {
		SoundViewController *viewController = [[SoundViewController alloc] 
											   initWithNibName:@"SoundViewController" bundle:[NSBundle mainBundle]];
		self.soundView = viewController;
		[viewController release];
	}
	
	[self.navigationController pushViewController:self.soundView animated:YES];
	self.soundView.title = @"Record";
	self.soundView.itemName = note.text;
	[self.soundView setup];
}

-(void)openDraw:(id) sender {
	self.drawView = nil; //FIXME
	if(self.drawView == nil) {
		DrawViewController *viewController = [[DrawViewController alloc] 
											   initWithNibName:@"DrawViewController" bundle:[NSBundle mainBundle]];
		self.drawView = viewController;
		[viewController release];
	}
	[self.navigationController pushViewController:self.drawView animated:YES];
	self.drawView.title = @"Draw";
	self.drawView.itemName = note.text;
	[self.drawView setup];
}

- (IBAction) shareIdea:(id) sender {
	if(self.shareView == nil) {
		ShareViewController *viewController = [[ShareViewController alloc] 
											  initWithNibName:@"ShareViewController" bundle:[NSBundle mainBundle]];
		self.shareView = viewController;
		[viewController release];
	}
	
	[self.navigationController presentModalViewController:self.shareView animated:YES];
	[self.shareView.noteName setText:[NSString stringWithFormat:@"%@",note.text]];
	[self.shareView.responseLabel setText:@"Waiting for user input"];
	self.shareView.note = self.note;
}

- (IBAction) tweetIdea:(id) sender {
	if(self.twitView == nil) {
		TwitViewController *viewController = [[TwitViewController alloc] 
											   initWithNibName:@"TwitViewController" bundle:[NSBundle mainBundle]];
		self.twitView = viewController;
		[viewController release];
	}
	
	[self.navigationController presentModalViewController:self.twitView animated:YES];
	[self.twitView.noteName setText:[NSString stringWithFormat:@"%@",note.text]];
	[self.twitView.responseLabel setText:@"Waiting for user input"];
	self.twitView.note = self.note;
}

- (IBAction) emailIdea:(id) sender {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		[picker setSubject:self.noteText.text];
		[picker setMessageBody:self.noteDesc.text isHTML:NO];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *trimmedName = [self.note.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSData *myData;
		
		NSString *ideaPhotoDir = [NSString stringWithFormat:@"%@Photo.jpg",trimmedName];
		NSString *photoFilePath = [documentsDirectory stringByAppendingPathComponent:ideaPhotoDir];
		myData = [NSData dataWithContentsOfFile:photoFilePath];
		if (myData != nil) {
			[picker addAttachmentData:myData mimeType:@"image/jpg" fileName:@"photo"];
		}
		
		NSString *ideaSoundDir = [NSString stringWithFormat:@"%@Sound.caf",trimmedName];
		NSString *soundFilePath = [documentsDirectory stringByAppendingPathComponent:ideaSoundDir];
		myData = [NSData dataWithContentsOfFile:soundFilePath];
		if (myData != nil) {
			[picker addAttachmentData:myData mimeType:@"audio/caf" fileName:@"sound"];
		}
		
		NSString *ideaDrawDir = [NSString stringWithFormat:@"%@Draw.jpg",trimmedName];
		NSString *drawFilePath = [documentsDirectory stringByAppendingPathComponent:ideaDrawDir];
		myData = [NSData dataWithContentsOfFile:drawFilePath];
		if (myData != nil) {
			[picker addAttachmentData:myData mimeType:@"image/jpg" fileName:@"draw"];
		}
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	} else {
		//If no 3.0, old code here
		NSString *title = [self.noteText.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		NSString *description = [self.noteDesc.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		NSString *emailTarget = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", title, description];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailTarget]];
	}
}

// the amount of vertical shift upwards keep the Notes text view visible as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					72.0

// the duration of the animation for the view shift
#define kVerticalOffsetAnimationDuration		0.50

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
		[self.note updateDesc:self.noteDesc.text];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if (!viewShifted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kVerticalOffsetAnimationDuration];
	
		CGRect rect = textView.frame;		
		rect.size.height -= kOFFSET_FOR_KEYBOARD;
		textView.frame = rect;
	
		[UIView commitAnimations];
		viewShifted = TRUE;
	}
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	if (viewShifted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kVerticalOffsetAnimationDuration];
	
		CGRect rect = textView.frame;
		rect.size.height += kOFFSET_FOR_KEYBOARD;
		textView.frame = rect;
	
		[UIView commitAnimations];
		viewShifted = FALSE;
	}
	return YES;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	if (result == MFMailComposeResultSent) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email result" message:@"Sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}else if (result == MFMailComposeResultFailed) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email result" message:@"Sending failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	[self dismissModalViewControllerAnimated:YES];
}


@end
