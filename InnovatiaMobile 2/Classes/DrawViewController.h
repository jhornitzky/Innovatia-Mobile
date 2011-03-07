//
//  DrawViewController.h
//  note
//
//  Created by g g on 7/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawViewController : UIViewController {
	CGPoint lastPoint;
	UIImageView *drawImage;
	BOOL mouseSwiped;	
	BOOL changed;
	int mouseMoved;
	NSString *itemName;
}

@property(nonatomic,retain) NSString *itemName;
@property(nonatomic,retain) UIImageView *drawImage;

- (void) setup;
- (void) saveImage:(UIImage *)image withName:(NSString *)name;
- (UIImage *) loadImage:(NSString *)name;
- (IBAction) clearScreen:(id)sender;

@end
