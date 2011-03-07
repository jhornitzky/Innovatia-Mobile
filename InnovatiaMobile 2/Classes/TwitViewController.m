//
//  TwitViewController.m
//  Innovatia20
//
//  Created by g g on 9/10/09.
//  Copyright 2009 g. All rights reserved.
//

#import "TwitViewController.h"

@implementation TwitViewController
@synthesize noteUrl,noteUser,noteUserPass,noteName,progressSpinner,note,responseLabel,responseData;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self.noteUser setText:[prefs stringForKey:@"twitterInnovatiaUser"]];
	[self.noteUserPass setText:[prefs stringForKey:@"twitterInnovatiaPass"]];
}

- (IBAction) postTweet: (id) sender {
	TwitterRequest *t = [[TwitterRequest alloc] init];
	t.username = self.noteUser.text;
	t.password = self.noteUserPass.text;
	[progressSpinner startAnimating];
	[self.responseLabel setText:@"Posting To Twitter..."];
	NSString *tweetText = [NSString stringWithFormat:@"%@: %@", note.text, note.desc];
	[t statuses_update:tweetText delegate:self requestSelector:@selector(status_updateCallback:) errorSelector:@selector(status_errorCallback:) ];
}

- (void) status_updateCallback: (NSData *) content {
	[progressSpinner stopAnimating];
	[self.responseLabel setText:@"Finished update!"];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sharing result" message:@"Finished update!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	[self dismissModalViewControllerAnimated:YES];
	NSLog(@"%@",[[NSString alloc] initWithData:content encoding:NSASCIIStringEncoding]);
}

- (void) status_errorCallback: (NSData *) content {
	[progressSpinner stopAnimating];
	[self.responseLabel setText:@"Failure sending!"];
}

- (IBAction) updateDefaultConnectionDetails:(id)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:noteUser.text forKey:@"twitterInnovatiaUser"];
	[prefs setObject:noteUserPass.text forKey:@"twitterInnovatiaPass"];
	[prefs synchronize];
}

-(IBAction) closeView:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) dealloc {
	[super dealloc];
	[self.note release]; 
	[self.responseData release];
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];	
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }	
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
	
	animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
    
@end
