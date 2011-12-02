//
//  FSNotificationCenter.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/1/10.
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
#import "FSNotificationCenter.h"
#import "FSInvocation.h"

@interface FSNotificationCenter (Private)

@end

@implementation FSNotificationCenter (Private)

@end

@implementation FSNotificationCenter

#pragma mark NSObject

- (id)init {
    if (self = [super init])
		observers = [[NSMutableDictionary alloc] initWithCapacity:0];

    return self;
}

#pragma mark -

+ (FSNotificationCenter *)shared {
	static FSNotificationCenter *shared = nil;
	
	if (!shared)
		shared = [FSNotificationCenter new];
	
	return shared;
}

- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object {
	FSInvocation *invocation;
	NSMutableArray *group;
	
	invocation = [FSInvocation new];
	invocation.target = observer;
	invocation.selector = selector;
	
	group = [observers objectForKey:name];
	
	if (!group) {
		group = [NSMutableArray arrayWithCapacity:1];
		[observers setObject:group forKey:name];
	}
	
	[group addObject:invocation];
	
	[invocation release];
}

- (void)postNotification:(NSNotification *)notification {
	FSInvocation *invocation;
	NSArray *group;
	
	group = [observers objectForKey:[notification name]];
	
	if (!group)
		return;
	
	for (invocation in group)		
		[invocation.target performSelector:invocation.selector withObject:notification];
}

- (void)removeObserver:(id)observer {
	NSString *key;
	
	for (key in observers)
		[self removeObserver:observer name:key object:nil];
}

- (void)removeObserver:(id)observer name:(NSString *)name object:(id)object {
	NSMutableArray *group;
	FSInvocation *invocation;
	
	group = [observers objectForKey:name];
	
	for (invocation in group)
		if (invocation.target == observer)
			[group removeObject:invocation];
}

#pragma mark Deallocation

- (void)dealloc {
	[observers release];
	observers = nil;
	
    [super dealloc];
}

#pragma mark -

@end
