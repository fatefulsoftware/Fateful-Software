//
//  ConnectionQueue.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 10/2/09.
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

#import "ConnectionQueue.h"
#import "NSArrayRequestSerializationAdditions.h"
#import "ConnectionOperation.h"

@implementation ConnectionQueue

@synthesize store;

- (id)initWithStore:(NSString *)newStore {
	if (self = [super init]) {
		self.store = newStore;
		
		requests = [NSMutableArray arrayWithCapacity:0];
		[requests retain];
		
		operations = [[NSOperationQueue alloc] init];
		[operations retain];
		
		[self loadWithContentsOfFile:newStore];
	}
	
	return self;
}

- (void)loadWithContentsOfFile:(NSString *)path {
	NSEnumerator *enumerator;
	NSURLRequest *request;
	NSArray *newRequests;
	
	newRequests = [NSArray arrayWithContentsOfFile:path];
	
	if (!newRequests)
		return;
	
	enumerator = [[NSArray requestsWithArray:newRequests] objectEnumerator];
	while (request = [enumerator nextObject])
		[self push:request];
}

- (void)push:(NSURLRequest *)request save:(BOOL)save {
	ConnectionOperation *operation;
	
	if (save) {
		[requests push:request];
		
		[self save];
	}
	
	operation = [[ConnectionOperation alloc] initWithRequest:request];
	[operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
	[operations addOperation:operation];
	[operation release];
}

- (void)push:(NSURLRequest *)request {
	[self push:request save:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	ConnectionOperation *operation;
	
	operation = ((ConnectionOperation *) object);
	
	if ([object isKindOfClass:[ConnectionOperation class]] && [keyPath isEqualToString:@"isFinished"] && operation.isFinished) {
		if (operation.response) {
			[requests removeObject:operation.request];
			
			[self save];
		}
	}
}

- (void)save {
	NSArray *dictionaries;
	
	dictionaries = [requests requestDictionaries];
	
	[dictionaries writeToFile:store atomically:YES];
}

- (void)dealloc {
	[store release];
	store = nil;
	
	[requests release];
	requests = nil;
	
	[operations release];
	operations = nil;
	
	[super dealloc];
}

@end