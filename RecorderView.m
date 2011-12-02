//
//  RecorderView.m
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

#import <CoreAudio/CoreAudioTypes.h>
#import "RecorderView.h"
#import "NSBundleExtensions.h"

@implementation RecorderView

@synthesize delegate, path, recordButton, playButton, deleteButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
		[self initialize];

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
		[self initialize];

	return self;
}

- (void)initialize {
	recordButton = playButton = deleteButton = nil;
	delegate = nil;
	
	path = [NSBundle pathForDocument:@"temp.wav"];
	[path retain];
	
	url = [NSURL fileURLWithPath:path];
	[url retain];
	
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, [NSNumber numberWithFloat:22050], AVSampleRateKey, [NSNumber numberWithInt:1], AVNumberOfChannelsKey, nil] error:nil];
	recorder.delegate = self;
	
	player = nil;
	
	deleteConfirmation = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Your intro can not be recovered." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
}

- (UIControl *)recordButton {
	return recordButton;
}

- (void)setRecordButton:(UIControl *)value {	
	[recordButton removeTarget:self action:@selector(didPressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
	
	[recordButton release];
	recordButton = value;
	[recordButton retain];
	
	[recordButton addTarget:self action:@selector(didPressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIControl *)playButton {
	return playButton;
}

- (void)setPlayButton:(UIControl *)value {
	[playButton removeTarget:self action:@selector(didPressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
	
	[playButton release];
	playButton = value;
	[playButton retain];
	
	[playButton addTarget:self action:@selector(didPressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIControl *)deleteButton {
	return deleteButton;
}

- (void)setDeleteButton:(UIControl *)value {	
	[deleteButton removeTarget:self action:@selector(didPressDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
	
	[deleteButton release];
	deleteButton = value;
	[deleteButton retain];
	
	[deleteButton addTarget:self action:@selector(didPressDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (IBAction)didPressRecordButton:(id)sender {	
	if (recorder.recording)
		[self stopRecording];
	else
		[self startRecording];
}

- (BOOL)startRecording {
	if (recorder.recording)
		return NO;
	
	[self stopRecording];
	
	[self stopPlaying];
	
	return [recorder recordForDuration:5]; // TODO: duration? play sound when done?
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
	[self stopRecording];
}

- (BOOL)stopRecording {
	if (!recorder.recording)
		return NO;
	
	[recorder stop];
	
	return YES;
}

- (IBAction)didPressPlayButton:(id)sender {
	if (player.playing)
		[self stopPlaying];
	else
		[self startPlaying];
}

- (BOOL)startPlaying {
	NSError *error = nil;
	
	[self stopPlaying];
	
	[self stopRecording];
	
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	
	if (error || ![player prepareToPlay]) {
		[player release];
		player = nil;
		
		return NO;
	}
	
	player.delegate = self;
	
	if (![player play]) {
		[self stopPlaying];
		
		return NO;
	}
	
	return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)currentPlayer successfully:(BOOL)flag {
	[self stopPlaying];
}

- (BOOL)stopPlaying {
	if (!player || !player.playing)
		return NO;
	
	[player stop];
	
	[player release];
	player = nil;
	
	return YES;
}

- (IBAction)didPressDeleteButton:(id)sender {
	[self stopRecording];
	
	[self stopPlaying];
	
	[deleteConfirmation show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 1)
		return;
	
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	
	if (delegate)
		[delegate recorderViewDidDelete:self];
}

- (void)dealloc {
	[recordButton release];
	recordButton = nil;
	
	[playButton release];
	playButton = nil;
	
	[deleteButton release];
	deleteButton = nil;
	
	[recorder release];
	recorder = nil;
	
	[player release];
	player = nil;
	
	[path release];
	path = nil;
	
	[url release];
	url = nil;
	
	delegate = nil;
	
	[deleteConfirmation release];
	deleteConfirmation = nil;
	
    [super dealloc];
}

@end