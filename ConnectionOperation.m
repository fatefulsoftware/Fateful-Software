//
//  ConnectionOperation.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 9/17/09.
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

#import "ConnectionOperation.h"

@implementation ConnectionOperation

@synthesize response, request, executing, finished;

- (id)initWithRequest:(NSURLRequest *)req {
	if (self = [super init]) {
		request = req;
		[request retain];
		
		response = nil;
		executing = finished = NO;
	}
	
	return self;
}

- (void)main {
	[self setExecuting:YES];
	
	response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	[response retain];
	
	[self setExecuting:NO];
	
	[self setFinished:YES];
}

- (void)dealloc {
	[request release];
	request = nil;
	
	[response release];
	response = nil;
	
	[super dealloc];
}

@end