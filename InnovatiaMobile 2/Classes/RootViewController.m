//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "RootViewController.h"
#import "Innovatia20AppDelegate.h"
#import "Note.h"
#import "NoteCell.h"

@implementation RootViewController

@synthesize noteView,syncView;

/*
 Set up the search results array and navigation items
 */
- (void)viewDidLoad {
	searching = NO; 
	self.title = @"Notes";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	UIBarButtonItem * btn = [[UIBarButtonItem alloc] initWithTitle:@"Add" 
															 style:UIBarButtonItemStyleBordered 
															 target:self action:@selector(addNote:)];
	self.navigationItem.rightBarButtonItem = btn; 
	searchResults = [[NSMutableArray alloc]init];
}

- (void) addNote:(id)sender {
	Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.noteView == nil) {
		NoteViewController *viewController = [[NoteViewController alloc] 
											  initWithNibName:@"NoteViewController" bundle:[NSBundle mainBundle]];
		self.noteView = viewController;
		[viewController release];
	}
	
	Note *note = [appDelegate addNote];
	[self.navigationController pushViewController:self.noteView animated:YES];
	self.noteView.note = note;
	self.noteView.title = @"Details";
	[self.noteView.noteText setText:note.text];
	[self.noteView.noteDesc setText:note.desc];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching) {
		return searchResults.count;
	} else {
		Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];
		return appDelegate.notes.count;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	NoteCell *cell = (NoteCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[NoteCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	//RENDER ROWS IN REVERSE
	if (searching) {
		Note *td = [searchResults objectAtIndex:([searchResults count] - indexPath.row - 1)];
		[cell setNote:td];
	} else {
		Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];
		Note *td = [appDelegate.notes objectAtIndex:([appDelegate.notes count] - indexPath.row - 1)];
		[cell setNote:td];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 Note *note = nil;
	 
	 if (searching) {
		 note = [searchResults objectAtIndex:([searchResults count] - indexPath.row - 1)];
	 } else {
		 Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];
		 note = (Note *)[appDelegate.notes objectAtIndex:([appDelegate.notes count] - indexPath.row - 1)];
	 }
		 
	 if(self.noteView == nil) {
		 NoteViewController *viewController = [[NoteViewController alloc] 
											   initWithNibName:@"NoteViewController" bundle:[NSBundle mainBundle]];
		 self.noteView = viewController;
		 [viewController release];
	 }
	 
	 [self.navigationController pushViewController:self.noteView animated:YES];
	 self.noteView.note = note;
	 self.noteView.title = @"Details";
	 [self.noteView.noteText setText:note.text];
	 [self.noteView.noteDesc setText:note.desc];
	 
}

// Override if you support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:
	(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];
	Note *note = (Note *)[appDelegate.notes objectAtIndex:([appDelegate.notes count] - indexPath.row - 1)];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[appDelegate removeNote:note];
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}	
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[super dealloc];
	[self.noteView release];
	[self.syncView release];
}

- (IBAction) showSync:(id) sender {
	if(self.syncView == nil) {
		SyncViewController *viewController = [[SyncViewController alloc] 
											   initWithNibName:@"SyncViewController" bundle:[NSBundle mainBundle]];
		self.syncView = viewController;
		[viewController release];
	}
	
	[self.navigationController presentModalViewController:self.syncView animated:YES];
	self.syncView.title = @"Sync";
	[self.syncView.responseLabel setText:@"Waiting for user input"];
	[self.syncView resetState];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if ([searchText isEqualToString:@""]) {
		searching = NO;
		[searchResults removeAllObjects]; 
		return;
	} else {
		searching = YES;
		[searchResults removeAllObjects]; 
		Innovatia20AppDelegate *appDelegate = (Innovatia20AppDelegate *)[[UIApplication sharedApplication] delegate];
		for (int i = 0; i < [appDelegate.notes count]; i++) {
			Note *tdTemp = [appDelegate.notes objectAtIndex:i];
			if ([tdTemp.text rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
				[searchResults addObject:tdTemp];
			}
		}
	}
	[self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	searching = YES;
	searchBar.showsCancelButton = NO;
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searching = NO;
	searchBar.text = nil;
	[searchResults removeAllObjects];
	searchBar.showsCancelButton = NO;
	[searchBar resignFirstResponder];
	[self.tableView reloadData];
}

@end

