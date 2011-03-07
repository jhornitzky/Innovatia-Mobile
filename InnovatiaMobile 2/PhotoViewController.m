//
//  PhotoViewController.m
//  note
//
//  Created by g g on 18/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "PhotoViewController.h"

@implementation PhotoViewController 

@synthesize imgPicker, itemName, imgView; 

-(void) setup {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ideaPhotoDir = [NSString stringWithFormat:@"%@Photo.jpg",trimmedName];
	NSString *photoFilePath = [documentsDirectory stringByAppendingPathComponent:ideaPhotoDir];
	
	//Check if it exists first
	BOOL fileExists = FALSE;
	char *charPath = [photoFilePath UTF8String];
	FILE* testFile = fopen(charPath, "rb");
	if (testFile)
	{
		fileExists = TRUE;
	}
	fclose(testFile);
	
	if (fileExists) {
		//Load into ImageView
		UIImage *tempImg = [self loadImage:ideaPhotoDir];
		[imgView setImage:tempImg];
		//[tempImg release];
	} else {
		NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"noImage" ofType:@"png"];
		UIImage *defaultImg = [UIImage imageWithContentsOfFile:defaultFilePath];
		[imgView setImage:defaultImg];
	}
}

-(IBAction) takePic:(id)sender {
	
	if (self.imgPicker == nil) {
		self.imgPicker = [[UIImagePickerController alloc] init];
		self.imgPicker.allowsImageEditing = YES;
		self.imgPicker.delegate = self;
	}
	
	@try {
		self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera; 
		[self presentModalViewController:self.imgPicker animated:YES];
	}@catch ( NSException *e ) {
		[self pickPic:self];
	}	
}

-(IBAction) pickPic:(id)sender {
	//[[self.imgView image] release];
	if (self.imgPicker == nil) {
		self.imgPicker = [[UIImagePickerController alloc] init];
		self.imgPicker.allowsImageEditing = YES;
		self.imgPicker.delegate = self;
	}
	
	self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:self.imgPicker animated:YES];
}

- (IBAction) delPic:(id)sender {
	NSLog(@"Removing");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ideaPhotoDir = [NSString stringWithFormat:@"%@Photo.jpg",trimmedName];
	NSString *photoFilePath = [documentsDirectory stringByAppendingPathComponent:ideaPhotoDir];
	NSLog(photoFilePath);
    [fileManager removeItemAtPath:photoFilePath error:nil];
	NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"noImage" ofType:@"png"];
	UIImage *defaultImg = [UIImage imageWithContentsOfFile:defaultFilePath];
	[imgView setImage:defaultImg];
	NSLog(@"UpdatingView");
}



- (void)saveImage:(UIImage *)image withName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}

- (UIImage *)loadImage:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];    
    UIImage *res = [UIImage imageWithContentsOfFile:fullPath];
    return res;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	NSLog(@"1");
	
	[self.imgView setImage:img];
	NSLog(@"2");
	self.itemName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSLog(@"3");
	NSString *ideaPhotoDir = [NSString stringWithFormat:@"%@Photo.jpg",self.itemName];
	NSLog(@"4");
	[self saveImage:img withName:ideaPhotoDir];
	NSLog(@"5");
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[self.imgPicker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[[picker parentViewController]  dismissModalViewControllerAnimated:YES];
	[self.imgPicker release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	NSLog(@"PHOTO MEM WARNING!");
	[imgPicker release];
}

- (void)dealloc {
    [super dealloc];
	[imgPicker release];
	[itemName release];
	[imgView release];
}

@end
