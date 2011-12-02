//
//  FSRecorder.h
//  Fateful Software
//
//  Created by Jason Jaskolka on 12/7/09.
//
//  Copyright (c) 2010 Fateful Software All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FSRecorderDelegate.h"

@interface FSRecorder : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate> {
	UIControl *recordButton, *playButton, *deleteButton;
	id<FSRecorderDelegate> delegate;
	AVAudioRecorder *recorder;
	AVAudioPlayer *player;
	NSString *path;
	NSURL *url;
	UIAlertView *deleteConfirmation;
	float maxDuration;
}

@property (nonatomic, retain) IBOutlet UIControl *recordButton, *playButton, *deleteButton;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, assign) IBOutlet id<FSRecorderDelegate> delegate;
@property (nonatomic, assign) float maxDuration;
@property (nonatomic, readonly) BOOL recording, playing;

- (void)initialize;

- (IBAction)didPressRecordButton:(id)sender;
- (BOOL)startRecording;
- (BOOL)stopRecording;

- (IBAction)didPressPlayButton:(id)sender;
- (BOOL)startPlaying;
- (BOOL)stopPlaying;

- (IBAction)didPressDeleteButton:(id)sender;

@end