//
//  NSDateComparisonAdditions.m
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

#import "NSDateGroupingAdditions.h"

@implementation NSDate (NSDateGroupingAdditions)

- (BOOL)isSameDayAs:(NSDate *)date {
	NSDateComponents *components, *todayComponents;
	NSCalendar *calendar;
	
	calendar = [NSCalendar currentCalendar];
	
	components = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	todayComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
	
	return [components day] == [todayComponents day] && [components month] == [todayComponents month] && [components year] == [todayComponents year];
}

+ (NSDate *)dayFromDate:(NSDate *)date {
	NSCalendar *calendar;
	
	calendar = [NSCalendar currentCalendar];
	
	return [calendar dateFromComponents:[calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date]];
}

+ (NSDictionary *)groupObjects:(NSArray *)objects byDay:(SEL)selector days:(NSArray **)days {
	NSMutableDictionary *results;
	NSMutableArray *dates, *group;
	id obj;
	NSDate *date;
	
	results = [NSMutableDictionary dictionaryWithCapacity:1];
	dates = [NSMutableArray arrayWithCapacity:1];
	
	for (obj in objects) {
		date = [NSDate dayFromDate:[obj performSelector:selector]];
		
		group = [results objectForKey:date];
		
		if (!group) {
			group = [NSMutableArray arrayWithCapacity:1];
			
			[dates addObject:date];
		}
		
		[group addObject:obj];
		
		[results setObject:group forKey:date];
	}
	
	*days = dates;
	
	return results;
}

+ (void)timeIntervalSince:(NSDate *)date inYears:(NSUInteger *)years months:(unsigned char *)months days:(unsigned char *)days hours:(unsigned char *)hours minutes:(unsigned char *)minutes seconds:(unsigned char *)seconds {
	NSDateComponents *delta;
	NSDate *now, *future;
	NSDateFormatter *dateFormatter;
	
	dateFormatter = [[NSDateFormatter new] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	*years = *months = *days = *hours = *minutes = *seconds = 0;
	
	now = [NSDate new];
	
	if ([date compare:now] == NSOrderedAscending) {
		delta = [NSDateComponents new];
		[delta setMonth:0];
		[delta setDay:0];
		[delta setHour:0];
		[delta setMinute:0];
		[delta setSecond:0];
		
		[delta setYear:1];
		future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		while ([future compare:now] == NSOrderedAscending) {
			(*years)++;
			
			future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:future options:0];
		}
		
		[delta setYear:*years];
		date = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		[delta setYear:0];
		[delta setMonth:1];
		future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		while ([future compare:now] == NSOrderedAscending) {
			(*months)++;
			
			future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:future options:0];
		}
		
		[delta setMonth:*months];
		date = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		[delta setMonth:0];
		[delta setDay:1];
		future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		while ([future compare:now] == NSOrderedAscending) {
			(*days)++;
			
			future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:future options:0];
		}
		
		[delta setDay:*days];
		date = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		[delta setDay:0];
		[delta setHour:1];
		future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		while ([future compare:now] == NSOrderedAscending) {
			(*hours)++;
			
			future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:future options:0];
		}
		
		[delta setHour:*hours];
		date = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		[delta setHour:0];
		[delta setMinute:1];
		future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		while ([future compare:now] == NSOrderedAscending) {
			(*minutes)++;
			
			future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:future options:0];
		}
		
		[delta setMinute:*minutes];
		date = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		[delta setMinute:0];
		[delta setSecond:1];
		future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:date options:0];
		
		while ([future compare:now] == NSOrderedAscending) {
			(*seconds)++;
			
			future = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:future options:0];
		}
		
		[delta setSecond:*seconds];
		
		[delta release];
	}
	
	[now release];
}

@end
