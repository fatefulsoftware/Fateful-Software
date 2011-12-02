//
//  RequestOperation.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 4/10/10.
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
#import "RequestOperation.h"

@interface RequestOperation (Private)

- (void)sendRequest;

@end

@implementation RequestOperation (Private)

#pragma mark Invocation

- (void)sendRequest {	
	[data release];
	[response release];
	[error release];
	
	data = [[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] retain];
	
	[response retain];	
	[error retain];
}

#pragma mark -

@end

@implementation RequestOperation

@synthesize request, response, error, data;

#pragma mark Initialization

- (id)init {
	if (self = [super init]) {
		request = nil;
		response = nil;
		error = nil;
		data = nil;
		self.invocationTarget = self;
		invocationSelector = @selector(sendRequest);
	}

	return self;
}

#pragma mark -

#pragma mark Queuing

- (void)queueOnto:(NSOperationQueue *)queue {
	if ([[request URL] isFileURL]) {
		[data release];
		data = [[NSData alloc] initWithContentsOfURL:[request URL]];
		
		[error release];
		error = nil;
		
		[super notifyFinished];
		
		return;
	}
	
	[super queueOnto:queue];
}

#pragma mark -

#pragma mark Deallocation

- (void)dealloc {
	[request release];
	request = nil;
	
	[response release];
	response = nil;
	
	[error release];
	error = nil;
	
	[data release];
	data = nil;
	
	[super dealloc];
}

#pragma mark -

@end
