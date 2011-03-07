//
//  SyncViewController.m
//  This sync view controller class is used to control the sync process between an innovatia server 
//	and the client.
//
//  Created by g g on 20/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "SyncViewController.h"

@interface SyncViewController (Private)
- (void)finalizeSync;
- (void)sendIdea:(Note *)note;
@end

@implementation SyncViewController

@synthesize noteUrl,noteUser,noteUserPass,responseData,responseLabel,syncNotes,progressSpinner,parser;

/*
 Upon view load, retrieve the default user credentials and populate the relevant fields with data
 */

- (IBAction) updateDefaultConnectionDetails:(id)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:noteUrl.text forKey:@"innovatiaUrl"];
	[prefs setObject:noteUser.text forKey:@"innovatiaUser"];
	[prefs setObject:noteUserPass.text forKey:@"innovatiaPass"];
	[prefs synchronize];
}

/*
 Release lots of stuff
 */
- (void)dealloc {
    [super dealloc];
	[currentElement release];
	[syncNotes release];
	[currentNote release];
	[currentTitle release];
	[currentDate release];
}

/*
 Syncing methods:
 The current process is;
 1. Start a sync by sending the ID to the server
 2. Receive ideas from server in XML form
 3. Send these to the appDelegate
 4. Now send our ideas to the server
 FIXME at the moment this process is stupid... its sends everything to and from the server.
 Needs more intelligence. And better memory handling.
 */

/*
 First method in response to the start sync. Send the UID to server to get ideas and last requested ideas.
 */
-(IBAction)startSync:(id)sender{
	NSLog(@"STARTING SYNC");
	[self.responseLabel setText:@"Downloading ideas"];
	[self.progressSpinner startAnimating];
	
	state = 1;
	NSLog(@"PREPING REQUESTS");
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
	NSString *post = [NSString stringWithFormat:@"action=getSyncData&username=%@&password=%@&clientid=%@"
					  , noteUser.text, noteUserPass.text, deviceUDID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSString *url = [NSString stringWithFormat:@"%@/innovatia_ajax.php", noteUrl.text];
	[request setURL:[NSURL URLWithString:url]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	NSLog(@"CHECK REQUEST");
	
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (conn)  
	{  
		responseData = [[NSMutableData data] retain];
	}   
	
	[request release];
	NSLog(@"RELEASING REQUEST");
	//[url release];
	//[post release];
	//[postData release];
	//[postLength release];
}

/*
 Once the response has been received, parse the ideas XML.
 */
-(void) continueSync {
	self.parser = [[NSXMLParser alloc] initWithData:self.responseData];
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[self.responseLabel setText:@"Parsing data"];
	[parser parse];
	
	state = 2;
}


/*
 Parsing methods
 */

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
	syncNotes =  [[NSMutableArray alloc] init];
	currentDate = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"idea"]) {
		currentNote = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDesc = [[NSMutableString alloc] init];
	} 
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//Idea
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"desc"]) {
		[currentDesc appendString:string];
	} else if ([currentElement isEqualToString:@"lastsync"]) {
		[currentDate appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"idea"]) {
		[currentNote setObject:currentTitle forKey:@"title"];
		[currentNote setObject:currentDesc forKey:@"desc"];
		[syncNotes addObject:[currentNote copy]];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self.parser release];
	[self finalizeSync];
}

/*
 Now that the ideas have been parsed, add them to the DB via appDelegate.
 Then send all new ideas.
 */

-(void) finalizeSync {
	[self.responseLabel setText:@"Adding ideas to DB"];
	Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];

	int size = [syncNotes count]; 
	NSLog(@"stories array has %d items", size);
	for (int i = 0; i < size; i++) {
		NSLog(@"syncToDo");
		NSMutableDictionary *dict = [syncNotes objectAtIndex:i];
		Note *note = [[Note alloc] init];
		note.text = [dict objectForKey: @"title"];
		note.desc = [dict objectForKey: @"desc"];
		[dict release];
		[appDelegate addNote:note];
		[note release];
	}
	
	[self.responseLabel setText:@"Sending ideas"];
	//Get the DB objects
	NSMutableArray *ideas = appDelegate.notes;
	
	size = [ideas count]; 
	//Now for each send them to server FIXME check for Synced date
	for (int i = 0; i < size; i++) {
		Note *note = [ideas objectAtIndex:i];
		NSLog(@"SENDING: %@", note.text);
		[self sendIdea:note];
		openConnectionCount++;
	}
}

- (void) sendIdea:(Note *)note{ 
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
	NSString *post = [NSString stringWithFormat:@"action=saveOrUpdate&title=%@&description=%@&visibility=%@&licence=%@&username=%@&password=%@&clientid=%@"
					  ,note.text, note.desc, note.visibility, @"Closed", noteUser.text, noteUserPass.text, deviceUDID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSString *url = [NSString stringWithFormat:@"%@/innovatia_ajax.php", noteUrl.text];
	
	[request setURL:[NSURL URLWithString:url]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	//[url release];
	//[post release];
	//[postData release];
	//[postLength release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.responseLabel setText:@"Connection Failure!"];
	[self.progressSpinner stopAnimating];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"CLOSING CONNECTION");
	[connection release];
	if (state == 1) {
		NSLog(@"CONTINUING SYNC");
		[self continueSync];
	}
	else if (state == 2) {
		//ONLY dismiss once ALL connections have completed
		openConnectionCount--;
		NSLog(@"CONNECTION COUNT %i", openConnectionCount);

		if (openConnectionCount == 0)
		{
			NSLog(@"ENDED SYNC");
			[self.progressSpinner stopAnimating];
			[self.responseLabel setText:@"Sync complete"];
			state = 0;
			NSLog(@"1");
			
			//RELEASE STUFF
			[currentElement release];
			[self.syncNotes removeAllObjects];
			[self.syncNotes release];
			[currentNote release];
			[currentTitle release];
			[currentDate release];
			[self.responseData release];
			NSLog(@"2");
			
			//SHOW completion message
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sync result" message:@"Sync complete" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			[self dismissModalViewControllerAnimated:YES];
			NSLog(@"3");
		}
	}
}

-(IBAction)closeView:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
	//[self release];
}

-(void)resetState {
	state = 0;
	openConnectionCount = 0;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self.noteUrl setText:[prefs stringForKey:@"innovatiaUrl"]];
	[self.noteUser setText:[prefs stringForKey:@"innovatiaUser"]];
	[self.noteUserPass setText:[prefs stringForKey:@"innovatiaPass"]];
}

// VIEW STUFF

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
