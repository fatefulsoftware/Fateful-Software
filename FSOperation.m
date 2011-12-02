//
//  FSOperation.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 5/20/10.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FSOperation.h"
#import "FSOperationQueue.h"
#import "FSNotificationCenter.h"

NSString *const OperationDidFinishNotification = @"OperationDidFinishNotification";

@implementation FSOperation

@synthesize invocationSelector, userInfo, selector, returnValue, timeout;

#pragma mark NSObject

- (id)init {	
    if (self = [super init]) {
		userInfo = returnValue = nil;
		target = invocationTarget = nil;
		selector = invocationSelector = nil;
		timeout = 0;
		startDate = nil;
	}

    return self;
}

#pragma mark -

#pragma mark Properties

- (BOOL)timedOut {
	if (timeout == 0)
		return NO;
	
	if (!startDate)
		return NO;
	
	return [[NSDate date] timeIntervalSinceDate:startDate] > timeout;
}

- (id)target {
	return target;
}

- (void)setTarget:(id)value {
	if (target == value)
		return;
	
	if (self == value) {
		target = value;
		
		return;
	}
	
	[target release];
	target = [value retain];
}

- (id)invocationTarget {
	return invocationTarget;
}

- (void)setInvocationTarget:(id)value {
	if (invocationTarget == value)
		return;
	
	if (self == value) {
		invocationTarget = value;
		
		return;
	}
	
	[invocationTarget release];
	invocationTarget = [value retain];
}

#pragma mark -

#pragma mark NSOperation

- (void)main {
	NSAutoreleasePool *pool;
	
	if ([self isCancelled])
		return;
	
	pool = [NSAutoreleasePool new];
	
	startDate = [NSDate new];
		
	[returnValue release];
	
	if ([invocationTarget respondsToSelector:@selector(methodSignatureForSelector:)] && strcmp([[invocationTarget methodSignatureForSelector:invocationSelector] methodReturnType], "v") == 0)
		returnValue = nil;
	else
		returnValue = [[invocationTarget performSelector:invocationSelector] retain];
	
	if (![self isCancelled])
		[self notifyFinished];
	
	[pool release];
}

#pragma mark -

- (void)notifyFinished {	
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:OperationDidFinishNotification object:self] waitUntilDone:NO];
	[[FSNotificationCenter shared] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:OperationDidFinishNotification object:self] waitUntilDone:NO];
	
	if (target && selector && [target respondsToSelector:selector])
		[target performSelectorOnMainThread:selector withObject:self waitUntilDone:NO];
}

#pragma mark Queuing

- (void)queueOnto:(NSOperationQueue *)queue {	
	[queue addOperation:self];
}

- (void)queue {	
	[self queueOnto:[FSOperationQueue shared]];
}

#pragma mark -

#pragma mark Deallocation

- (void)dealloc {
	[userInfo release];
	userInfo = nil;
	
	if (target != self)
		[target release];
	
	target = nil;
	
	if (invocationTarget != self)
		[invocationTarget release];
	
	invocationTarget = nil;
	
	[returnValue release];
	returnValue = nil;
	
	[startDate release];
	startDate = nil;
	
    [super dealloc];
}

#pragma mark -

@end
