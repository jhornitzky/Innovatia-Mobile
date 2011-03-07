//
//  PhotoViewController.h
//  note
//
//  Created by g g on 18/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImagePickerController *imgPicker; 
	UIImageView IBOutlet *imgView;
	NSString *itemName;
}

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) IBOutlet UIImageView *imgView;
@property (nonatomic, retain) NSString *itemName;

- (IBAction) takePic:(id)sender;
- (IBAction) pickPic:(id)sender;
- (IBAction) delPic:(id)sender;
- (void) setup;
- (void) saveImage:(UIImage *)image withName:(NSString *)name;
- (UIImage *)loadImage:(NSString *)name;


@end
