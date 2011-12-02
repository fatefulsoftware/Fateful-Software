//
//  TTURLRequestOperation.h
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
#import "FSOperation.h"

@class UIImage;
@class TTURLRequest;

@interface TTURLRequestOperation : FSOperation {
	id request;
	NSData *data;
	BOOL error, precache;
	UIImage *image;
	TTURLRequest *three20Request;
	NSString *precachePath;
}

@property (nonatomic, retain) id request;
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, assign) BOOL error, precache;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *cacheKey;
@property (nonatomic, readonly) TTURLRequest *three20Request;
@property (nonatomic, retain) NSString *precachePath;

+ (TTURLRequest *)three20RequestForRequest:(id)request;

@end
