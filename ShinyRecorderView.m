//
//  ShinyRecorderView.m
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

#import "ShinyRecorderView.h"
#import "ShinyButton.h"

@implementation ShinyRecorderView

- (void)initialize {
	[super initialize];
	
	self.recordButton = [[[ShinyButton alloc] initWithFrame:CGRectZero] autorelease];
	
	self.playButton = [[[ShinyButton alloc] initWithFrame:CGRectZero] autorelease];
	((ShinyButton *)playButton).color = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
	
	self.deleteButton = [[[ShinyButton alloc] initWithFrame:CGRectZero] autorelease];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, deleteButton.frame.origin.x + deleteButton.frame.size.width, recordButton.frame.size.height);
}

- (void)setRecordButton:(UIControl *)value {
	value.frame = CGRectMake(0, 0, 64, 37);
	
	if ([value isKindOfClass:[ShinyButton class]])
		((ShinyButton *)value).title = recorder.recording ? @"Stop" : @"Record";
	
	[super setRecordButton:value];
}

- (void)setPlayButton:(UIControl *)value {
	value.frame = CGRectMake(72, 0, 64, 37);
	
	if ([value isKindOfClass:[ShinyButton class]])
		((ShinyButton *)value).title = player.playing ? @"Stop" : @"Play";
	
	[super setPlayButton:value];
}

- (void)setDeleteButton:(UIControl *)value {
	value.frame = CGRectMake(144, 0, 64, 37);
	
	if ([value isKindOfClass:[ShinyButton class]])
		((ShinyButton *)value).title = @"Delete";
	
	[super setDeleteButton:value];
}

- (BOOL)startRecording {
	if (![super startRecording])
		return NO;
	
	if ([recordButton isKindOfClass:[ShinyButton class]])
		((ShinyButton *)recordButton).title = @"Stop";
	
	return YES;
}

- (BOOL)stopRecording {
	BOOL result;
	
	result = [super stopRecording];
	
	if ([recordButton isKindOfClass:[ShinyButton class]])
		((ShinyButton *)recordButton).title = @"Record";
	
	return result;
}

- (BOOL)startPlaying {
	if (![super startPlaying])
		return NO;
	
	if ([playButton isKindOfClass:[ShinyButton class]])
		((ShinyButton *)playButton).title = @"Stop";
	
	return YES;
}

- (BOOL)stopPlaying {
	BOOL result;
	
	result = [super stopPlaying];
	
	if ([playButton isKindOfClass:[ShinyButton class]])
		((ShinyButton *)playButton).title = @"Play";
	
	return result;
}

@end