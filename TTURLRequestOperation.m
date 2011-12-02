//
//  TTURLRequestOperation.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 5/25/10.
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
#import "Three20/Three20.h"
#import "TTURLRequestOperation.h"

@implementation TTURLRequestOperation

@synthesize request, data, error, image, cacheKey, precache, three20Request, precachePath;

#pragma mark NSObject

- (id)init {	
    if (self = [super init]) {
		request = nil;
		data = nil;
		self.invocationTarget = self;
		self.invocationSelector = @selector(sendRequest);
		error = precache = NO;
		image = nil;
		three20Request = nil;
		precachePath = nil;
	}

    return self;
}

#pragma mark -

+ (TTURLRequest *)three20RequestForRequest:(id)request {
	TTURLRequest *three20Request;
	
	if ([request isKindOfClass:[TTURLRequest class]])
		return request;
	
	three20Request = [[[TTURLRequest alloc] initWithURL:[[request URL] absoluteString] delegate:nil] autorelease];
	three20Request.httpMethod = [request HTTPMethod];
	three20Request.httpBody = [request HTTPBody];
	
	if ([request cachePolicy] == NSURLRequestReloadIgnoringCacheData || [request cachePolicy] == NSURLRequestReloadIgnoringLocalAndRemoteCacheData)
		three20Request.cachePolicy = TTURLRequestCachePolicyNetwork;
	else if ([request cachePolicy] == NSURLRequestReturnCacheDataDontLoad)
		three20Request.cachePolicy = TTURLRequestCachePolicyLocal;
	
	return three20Request;
}

#pragma mark Properties

- (NSString *)cacheKey {
	return self.three20Request.cacheKey;
}

- (UIImage *)image {
	if (!image && self.three20Request) {
		if (data) {
			image = [[UIImage alloc] initWithData:data];
			
			if (image)
				[[TTURLCache sharedCache] storeImage:image forURL:self.three20Request.urlPath];
		} else {
			image = [[[TTURLCache sharedCache] imageForURL:self.three20Request.urlPath fromDisk:NO] retain];
		}
	}
	
	return image;
}

- (TTURLRequest *)three20Request {
	if (!three20Request)
		three20Request = [[[self class] three20RequestForRequest:request] retain];
	
	return three20Request;
}

#pragma mark -

#pragma mark Queuing

- (void)queueOnto:(NSOperationQueue *)queue {
	NSURL *URL;
		  
	if ([request isKindOfClass:[NSURLRequest class]])
		URL = [request URL];
	else if ([request isKindOfClass:[TTURLRequest class]])
		URL = [NSURL URLWithString:(NSString *)[request URL]];
	else
		return;
	
	if ([URL isFileURL]) {		
		[data release];
		data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.three20Request.urlPath]];
		
		[super notifyFinished];
		
		return;
	}
	
	[super queueOnto:queue];
}

#pragma mark -

#pragma mark Invocation

- (NSData *)sendRequest {
	NSURLRequest *fileRequest;
	TTURLDataResponse *dataResponse;
	
	if ([request isKindOfClass:[NSURLRequest class]]) {
		if (precache && [[TTURLCache sharedCache] hasDataForURL:[[request URL] absoluteString]]) // just want to make sure there is data. don't need to fetch from cache or net
			return nil;
		
		[image release];
		image = [[[TTURLCache sharedCache] imageForURL:[[request URL] absoluteString] fromDisk:NO] retain];
		
		if (image)
			return nil;
		
		if ([[request URL] isFileURL]) {		
			[data release];
			data = [[NSData alloc] initWithContentsOfURL:[request URL]];
			
			return data;
		}
	} else if ([request isKindOfClass:[TTURLRequest class]]) {
		if (precache && [[TTURLCache sharedCache] hasDataForURL:self.three20Request.urlPath]) // just want to make sure there is data. don't need to fetch from cache or net
			return nil;
		
		[image release];
		image = [[[TTURLCache sharedCache] imageForURL:self.three20Request.urlPath fromDisk:NO] retain];
		
		if (image)
			return nil;
		
		fileRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.three20Request.urlPath]];
		
		if ([[fileRequest URL] isFileURL]) {		
			[data release];
			data = [[NSData alloc] initWithContentsOfURL:[fileRequest URL]];
			
			return data;
		}
	} else {
		return nil;
	}
	
	dataResponse = [TTURLDataResponse new];
	self.three20Request.response = dataResponse;
	[dataResponse release];
	
	[self.three20Request sendSynchronously];
	
	[data release];
	data = [((TTURLDataResponse *)self.three20Request.response).data retain];
	
	if (data) {
		error = NO;
	} else {
		data = [[NSData alloc] initWithContentsOfFile:precachePath];
        
		error = data == nil;
	}
	
	return data;
}

#pragma mark -

#pragma mark Deallocation

- (void)dealloc {	
	[request release];
	request = nil;
	
	[three20Request release];
	three20Request = nil;
	
	[data release];
	data = nil;
	
	[image release];
	image = nil;
	
	[precachePath release];
	precachePath = nil;
	
    [super dealloc];
}

#pragma mark -

@end
