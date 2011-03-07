//
//  SoundViewController.h
//  note
//
//  Created by g g on 10/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface SoundViewController : UIViewController <AVAudioSessionDelegate, 
AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
	UILabel *infoLabel;
	UIButton *recordOrStopButton;
	UIButton *playButton;
	UIImageView *statusImg;
	NSURL *soundFileUrl;
	BOOL recording;
	BOOL playing;
	AVAudioRecorder *soundRecorder;
	AVAudioPlayer *soundPlayer;
	NSString *itemName;
}

@property(nonatomic,retain) IBOutlet UIButton *recordOrStopButton;
@property(nonatomic,retain) IBOutlet UIButton *playButton; 
@property(nonatomic,retain) IBOutlet UIImageView *statusImg;
@property(nonatomic,retain) IBOutlet UILabel *infoLabel;

@property(nonatomic,retain) AVAudioRecorder *soundRecorder;
@property(nonatomic,retain) AVAudioPlayer *soundPlayer;
@property(nonatomic,retain) NSURL *soundFileUrl;

@property(nonatomic,retain) NSString *itemName;

-(IBAction) playSound:(id)sender;
-(IBAction) recordOrStop:(id)sender;
-(IBAction) delSound:(id)sender;
-(void) setup;

@end
