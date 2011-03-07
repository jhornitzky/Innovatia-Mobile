//
//  AvController.h
//  todo
//
//  Created by g g on 10/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AvController : NSObject <AVAudioRecorderDelegate, AVAudioSessionDelegate, AVAudioPlayerDelegate> {
	NSURL *soundFileUrl;
	BOOL recording;
	BOOL playing;
	AVAudioRecorder *soundRecorder;
	AVAudioPlayer *soundPlayer;
}

@property(nonatomic,retain) AVAudioRecorder *soundRecorder;
@property(nonatomic,retain) AVAudioPlayer *soundPlayer;
@property(nonatomic,retain) NSURL *soundFileUrl;

@end
