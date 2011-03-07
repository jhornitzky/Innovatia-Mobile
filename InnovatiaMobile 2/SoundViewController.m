//
//  SoundViewController.m
//  note
//
//  Created by g g on 10/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "SoundViewController.h"

@implementation SoundViewController

@synthesize recordOrStopButton, playButton, soundPlayer, soundRecorder, soundFileUrl, itemName, statusImg, infoLabel;

- (void) setup {
    [super viewDidLoad];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	self.itemName = [self.itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ideaSoundDir = [NSString stringWithFormat:@"%@Sound.caf",itemName];
	NSString *soundFilePath = [documentsDirectory stringByAppendingPathComponent:ideaSoundDir];
	
	//Check if it exists first
	char * cSoundFilePath = [soundFilePath UTF8String];
	FILE* testFile = fopen(cSoundFilePath, "rb");
	if (testFile)
	{
		[self.playButton setEnabled:YES];
		NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"soundExists" ofType:@"png"];
		UIImage *defaultImg = [UIImage imageWithContentsOfFile:defaultFilePath];
		[statusImg setImage:defaultImg];
	}
	else
	{
		[self.playButton setEnabled:NO];
		NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"noSoundExists" ofType:@"png"];
		UIImage *defaultImg = [UIImage imageWithContentsOfFile:defaultFilePath];
		[statusImg setImage:defaultImg];
	}
	fclose(testFile);
	
	NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.soundFileUrl = newURL;
    [newURL release];
	
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setDelegate:self];
	[audioSession setActive: YES error: nil];
	
    recording = NO;
    playing = NO;
} 

-(IBAction) delSound:(id)sender {
	NSLog(@"Removing");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	self.itemName = [self.itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ideaSoundDir = [NSString stringWithFormat:@"%@Sound.caf",self.itemName];
	NSString *soundFilePath = [documentsDirectory stringByAppendingPathComponent:ideaSoundDir];
	NSLog(soundFilePath);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:soundFilePath error:nil];
	
	NSLog(@"Deleted File");
	
	[self.playButton setEnabled:NO];
	NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"noSoundExists" ofType:@"png"];
	UIImage *defaultImg = [UIImage imageWithContentsOfFile:defaultFilePath];
	
	[self.statusImg setImage:defaultImg];
	NSLog(@"Updated IMAGE");
}

-(IBAction) recordOrStop: (id) sender {
	if (recording) {
		NSLog(@"Stopped Recording");
		[soundRecorder stop];
		recording = NO;
		self.soundRecorder = nil;
		
		[recordOrStopButton setTitle: @"Record" forState: UIControlStateNormal];
		[recordOrStopButton setTitle: @"Record" forState: UIControlStateHighlighted];
		
		NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"soundExists" ofType:@"png"];
		UIImage *defaultImg = [UIImage imageWithContentsOfFile:defaultFilePath];
		[statusImg setImage:defaultImg];
		
		[self.playButton setEnabled:YES];
		
		//[[AVAudioSession sharedInstance] setActive: NO error: nil];
		
	} else {
		NSLog(@"Started Recording");
		[[AVAudioSession sharedInstance]
		 setCategory: AVAudioSessionCategoryPlayAndRecord
		 error: nil];
		
		NSDictionary *recordSettings =
		[[NSDictionary alloc] initWithObjectsAndKeys:
		 [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
		 [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
		 [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
		 [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
         nil];
		
		AVAudioRecorder *newRecorder =
		[[AVAudioRecorder alloc] initWithURL: soundFileUrl settings: recordSettings error: nil];
		
		[recordSettings release];
		self.soundRecorder = newRecorder;
		[newRecorder release];
		
		[soundRecorder prepareToRecord];
		[soundRecorder setDelegate:self];
		[soundRecorder record];
		
		[recordOrStopButton setTitle: @"Stop" forState: UIControlStateNormal];
		[recordOrStopButton setTitle: @"Stop" forState: UIControlStateHighlighted];
		
		recording = YES;
	}
}

-(IBAction) playSound: (id) sender {
	if (playing) {
		NSLog(@"Stopping playing");
		[[AVAudioSession sharedInstance] setActive: NO error: nil];
		
		[playButton setTitle: @"Playback" forState: UIControlStateNormal];
		[playButton setTitle: @"Playback" forState: UIControlStateHighlighted];
		[soundPlayer stop];
		playing = NO;
	} else {
		NSLog(@"Starting playing");
		[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
		AVAudioPlayer *newPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL: self.soundFileUrl error: nil];
		
		self.soundPlayer = newPlayer;
		[newPlayer release];
		soundPlayer.volume = 1.5;
		[soundPlayer prepareToPlay];
		[soundPlayer setDelegate:self];
		[soundPlayer play];
		[playButton setTitle: @"Stop" forState: UIControlStateNormal];
		[playButton setTitle: @"Stop" forState: UIControlStateHighlighted];
		playing = YES;
	}
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog(@"Playing Ended");
	[playButton setTitle: @"Playback" forState: UIControlStateNormal];
	[playButton setTitle: @"Playback" forState: UIControlStateHighlighted];
}

- (void)dealloc {
    [super dealloc];
	[soundRecorder release];
	[soundPlayer release];
	[soundFileUrl release];
	[itemName release];
	[statusImg release];
}
																		
@end
