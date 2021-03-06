//
//  SettingsViewController.m
//  note
//
//  Created by g g on 20/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize noteUrl,noteUser,noteUserPass;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self.noteUrl setText:[prefs stringForKey:@"innovatiaUrl"]];
	[self.noteUser setText:[prefs stringForKey:@"innovatiaUser"]];
	[self.noteUserPass setText:[prefs stringForKey:@"innovatiaPass"]];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction) updateSettings:(id)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:noteUrl.text forKey:@"innovatiaUrl"];
	[prefs setObject:noteUser.text forKey:@"innovatiaUser"];
	[prefs setObject:noteUserPass.text forKey:@"innovatiaPass"];
	[prefs synchronize];
}

@end
