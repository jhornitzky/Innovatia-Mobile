//
//  shareViewController.h
//  note
//
//  Created by g g on 1/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "ShareViewController.h"

@implementation ShareViewController

@synthesize noteUrl,noteUser,noteUserPass,noteName,progressSpinner,note,responseLabel,responseData;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self.noteUrl setText:[prefs stringForKey:@"innovatiaUrl"]];
	[self.noteUser setText:[prefs stringForKey:@"innovatiaUser"]];
	[self.noteUserPass setText:[prefs stringForKey:@"innovatiaPass"]];
}

- (void) shareIdea:(id)sender{ 
	[self.responseLabel setText:@"Sending Idea"];
	[self.progressSpinner startAnimating];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
	NSString *post = [NSString stringWithFormat:@"action=saveOrUpdate&title=%@&description=%@&visibility=%@&licence=%@&username=%@&password=%@&clientid=%@"
					  ,note.text, note.desc, note.visibility, @"Closed", noteUser.text, noteUserPass.text, deviceUDID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	NSString *url = [NSString stringWithFormat:@"%@/innovatia_ajax.php", noteUrl.text];
	
	[request setURL:[NSURL URLWithString:url]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (conn)  
	{  
		[self.responseLabel setText:@"Connection made"];
		responseData = [[NSMutableData data] retain];
	}  
	else  
	{  
		[self.responseLabel setText:@"No connection made"];
	}  
}

- (IBAction) updateDefaultConnectionDetails:(id)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:noteUrl.text forKey:@"innovatiaUrl"];
	[prefs setObject:noteUser.text forKey:@"innovatiaUser"];
	[prefs setObject:noteUserPass.text forKey:@"innovatiaPass"];
	[prefs synchronize];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseLabel setText:@"Receiving data"];
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.responseLabel setText:@"Connection failure!"];
	[self.progressSpinner stopAnimating];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *tmpString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	[self.responseLabel setText:tmpString];
	[self.progressSpinner stopAnimating];
	[connection release];
	[self.responseData release];
	
	//Show confirmation
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sharing result" message:tmpString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	[self dismissModalViewControllerAnimated:YES];
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
