//
//  NSStringExtensions.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/16/09.
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

#import "NSStringExtensions.h"

@implementation NSString (NSStringExtensions)

- (BOOL)startsWith:(NSString *)substring {
	return [self rangeOfString:substring].location == 0;
}

- (NSString *)stringByTrimmingCharactersPastLength:(NSInteger)length {
	if ([self length] <= length)
		return self;
	
	if (length <= 3)
		return [self substringWithRange:NSMakeRange(0, length)];
	
	return [[self substringWithRange:NSMakeRange(0, length - 3)] stringByAppendingString:@"..."];
}

- (NSString *)stringByEscapingQuotes {
	return [[self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

@end