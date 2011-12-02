//
//  BetterURLConnection.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 7/1/09.
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

#import "BetterURLConnection.h"
#import "DataCache.h"

@implementation BetterURLConnection

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
	NSData *data;
	
	if ([request cachePolicy] == NSURLRequestReturnCacheDataElseLoad || [request cachePolicy] == NSURLRequestReturnCacheDataDontLoad) {
		data = [[DataCache shared] retrieveFromCache:[request.URL absoluteString] response:response];
		
		if (data) {			
			return data;
		} else {
			if ([request cachePolicy] == NSURLRequestReturnCacheDataDontLoad)
				return nil;
			
			data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
			
			if (data)
				[[DataCache shared] storeIntoCache:data response:*response withKey:[request.URL absoluteString]];
			else
				data = [[DataCache shared] retrieveFromCacheIgnoreExpiration:[request.URL absoluteString] response:response];
			
			return data;
		}
	}
	
	return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

@end