//
//  ProgressOperationQueue.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 4/30/10.
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

#import "ProgressOperationQueue.h"
#import "FSNotificationCenter.h"

NSString *const ProgressOperationQueueDidChangeNotification = @"ProgressOperationQueueDidChangeNotification";
NSString *const ProgressKey = @"progress";

@interface ProgressOperationQueue (Private)

- (void)initialize;

@end

@implementation ProgressOperationQueue (Private)

#pragma mark Initialization

- (void)initialize {
	totalOperations = 0;
}

#pragma mark -

@end

@implementation ProgressOperationQueue

#pragma mark NSObject

- (id)init {
    if (self = [super init])
        [self initialize];

    return self;
}

#pragma mark -

+ (ProgressOperationQueue *)shared {
	static ProgressOperationQueue *shared = nil;
	
	if (!shared)
		shared = [ProgressOperationQueue new];
	
	return shared;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSUInteger total;
	
	total = totalOperations;
	
	if (total == 0)
		total = 1;
	
	[[FSNotificationCenter shared] postNotification:[NSNotification notificationWithName:ProgressOperationQueueDidChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:(total - [[self operations] count]) / (float)total] forKey:ProgressKey]]];
	
	[object removeObserver:self forKeyPath:keyPath];
}

#pragma mark NSOperationQueue

- (void)addOperation:(NSOperation *)operation {
	[operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
	
	totalOperations++;
	
	[[FSNotificationCenter shared] postNotification:[NSNotification notificationWithName:ProgressOperationQueueDidChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:(totalOperations - [[self operations] count] - 1) / totalOperations] forKey:ProgressKey]]];
	
	[super addOperation:operation];
}

#pragma mark -

@end
