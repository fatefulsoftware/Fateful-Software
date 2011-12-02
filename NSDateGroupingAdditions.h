//
//  NSDateGroupingAdditions.h
//  Fateful Software
//
//  Created by Jason Jaskolka on 11/19/09.
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

@interface NSDate (NSDateGroupingAdditions)

- (BOOL)isSameDayAs:(NSDate *)date;
+ (NSDate *)dayFromDate:(NSDate *)date;
+ (NSDictionary *)groupObjects:(NSArray *)objects byDay:(SEL)selector days:(NSArray **)days;
+ (void)timeIntervalSince:(NSDate *)date inYears:(NSUInteger *)years months:(unsigned char *)months days:(unsigned char *)days hours:(unsigned char *)hours minutes:(unsigned char *)minutes seconds:(unsigned char *)seconds;

@end