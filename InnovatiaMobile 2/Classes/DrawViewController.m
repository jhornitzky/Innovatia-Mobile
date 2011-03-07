//
//  DrawViewController.m
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "DrawViewController.h"

@implementation DrawViewController

@synthesize itemName, drawImage;

- (void)setup {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ideaDrawName = [NSString stringWithFormat:@"%@Draw.jpg",trimmedName];
	NSString *drawFilePath = [documentsDirectory stringByAppendingPathComponent:ideaDrawName];
	//NSLog(ideaDrawName);
	//NSLog(drawFilePath);
	
	//Check if it exists first
	BOOL fileExists = FALSE;
	char *charPath = [drawFilePath UTF8String];
	FILE* testFile = fopen(charPath, "rb");
	if (testFile)
	{
		fileExists = TRUE;
	}
	fclose(testFile);
	
	if (fileExists) {
		UIImage *tempImg = [self loadImage:ideaDrawName];
		drawImage = [[UIImageView alloc] initWithImage:tempImg];
	} else {
		drawImage = [[UIImageView alloc] initWithImage:nil];
	}	
	
	drawImage.frame = self.view.frame;
	//drawImage.multipleTouchEnabled = YES;
	[self.view addSubview:drawImage];
	
	mouseMoved = 0;
	changed = NO;
	
	UIBarButtonItem * btn = [[UIBarButtonItem alloc] initWithTitle:@"Clear" 
															 style:UIBarButtonItemStyleBordered 
															target:self action:@selector(clearScreen:)];
	self.navigationItem.rightBarButtonItem = btn; 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	changed = YES;
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
	
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}

- (void)captureScreen {
	if (changed) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[self.drawImage.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
		//UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil); //???

		itemName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSString *ideaDrawName = [NSString stringWithFormat:@"%@Draw.jpg",itemName];
		[self saveImage:viewImage withName:ideaDrawName];
		UIGraphicsEndImageContext();
	}
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

-(void) clearScreen:(id)sender {
	drawImage.image = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ideaDrawName = [NSString stringWithFormat:@"%@Draw.jpg",trimmedName];
	NSString *drawFilePath = [documentsDirectory stringByAppendingPathComponent:ideaDrawName];
    [fileManager removeItemAtPath:drawFilePath error:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self captureScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end
