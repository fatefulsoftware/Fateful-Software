//
//  NSStringWithURLExtension.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 5/30/09.
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

#import "NSStringWithURLExtension.h"
#import "JSON/JSON.h"
#import "BetterURLConnection.h"

@implementation NSString (NSStringWithURLExtension)

+ (NSString *)stringWithUrl:(NSURL *)url withHeaders:(NSDictionary *)headers cachePolicy:(NSURLRequestCachePolicy)cachePolicy {
	NSEnumerator *enumerator;
	NSString *key;
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:30];
	
	if (headers) {
		enumerator = [headers keyEnumerator];
		while (key = [enumerator nextObject])
			[urlRequest setValue:[headers objectForKey:key] forHTTPHeaderField:key];
	}
	
	// Fetch the JSON response
	urlData = [BetterURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
	[urlRequest release];
	
 	// Construct a String around the Data from the response
	return [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString *)stringWithUrl:(NSURL *)url {
	return [NSString stringWithUrl:url withHeaders:nil cachePolicy:NSURLRequestReturnCacheDataElseLoad];
}

+ (id)objectWithJSONURL:(NSURL *)url withHeaders:(NSDictionary *)headers cachePolicy:(NSURLRequestCachePolicy)cachePolicy {
	SBJSON *json;
	NSString *str;
	id result;
	
	json = [SBJSON new];
	str = [NSString stringWithUrl:url withHeaders:headers cachePolicy:cachePolicy];
	result = [json objectWithString:str];
	[json release];
	
	return result;
}

+ (id)objectWithJSONURL:(NSURL *)url {
	return [NSString objectWithJSONURL:url withHeaders:nil cachePolicy:NSURLRequestReturnCacheDataElseLoad];
}

@end