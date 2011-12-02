//
//  FSOperationQueue.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/18/10.
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

#import "FSOperationQueue.h"
#import "FSOperation.h"
#import "FSNotificationCenter.h"

NSString *const OperationDidTimeoutNotification = @"OperationDidTimeoutNotification";

@interface FSOperationQueue (Private)

- (void)timerDidFire:(NSTimer *)timer;

@end

@implementation FSOperationQueue (Private)

- (void)timerDidFire:(NSTimer *)timer {
	NSOperation *operation;
	FSOperation *fsOperation;
	
	for (operation in [self operations]) {
		if (![operation isKindOfClass:[FSOperation class]])
			continue;
		
		fsOperation = (FSOperation *)operation;
		
		if (![fsOperation timedOut])
			continue;
		
		[operation cancel];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:OperationDidTimeoutNotification object:operation];
		[[FSNotificationCenter shared] postNotification:[NSNotification notificationWithName:OperationDidTimeoutNotification object:operation]];
	}
}

@end

@implementation FSOperationQueue

#pragma mark NSObject

- (id)init {
	if (self = [super init]) {		
		timeoutTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:timeoutTimer forMode:NSDefaultRunLoopMode];
	}
	
	return self;
}

#pragma mark -

+ (FSOperationQueue *)shared {
	static FSOperationQueue *shared = nil;
	
	if (!shared)
		shared = [FSOperationQueue new];
	
	return shared;
}

#pragma mark Deallocation

- (void)dealloc {
	[timeoutTimer invalidate];
	timeoutTimer = nil;
	
	[super dealloc];
}

#pragma mark -

@end
