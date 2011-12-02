//
//  UIApplicationTracking.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 7/17/09.
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

#import "Tracker.h"
#import "NSBundleExtensions.h"
#import "NSStringExtensions.h"

@implementation Tracker

- (id)init {
	if (self = [super init])
		queue = [[ConnectionQueue alloc] initWithStore:[NSBundle pathForDocument:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Tracking Store"]]];
	
	return self;
}

+ (BOOL)trackingEnabled {
	static BOOL loaded = NO, enabled;
	
	if (!loaded) {
		enabled = ![NSBundle disabledConfigWithKey:@"Disable Tracking"];
		
		loaded = YES;
	}
	
	return enabled;
}

+ (Tracker *)shared {
	static Tracker *tracker = nil;
	
	if (!tracker)
		tracker = [[Tracker alloc] init];
	
	return tracker;
}

- (void)trackWithType:(NSString *)type foreignId:(NSUInteger)foreignId {
	NSMutableURLRequest *request;
	NSMutableString *body;
	NSString *urlString;
	NSURL *url;
	
	if (![Tracker trackingEnabled])
		return;
	
	urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Tracking URL"];
	url = [NSURL URLWithString:urlString];
	request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	body = [[NSMutableString alloc] initWithCapacity:0];
	[body appendFormat:@"type=%@", type];
	
	if (foreignId > 0)
		[body appendFormat:@"&fid=%u", foreignId];
	
	[body appendFormat:@"&did=%@", [[[UIDevice currentDevice] uniqueIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[body release];
	
	[queue push:request];
	
	[request release];
}

- (void)dealloc {
	[queue release];
	queue = nil;
	
	[super dealloc];
}

@end