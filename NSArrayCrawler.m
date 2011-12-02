//
//  NSArrayCrawler.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/5/09.
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

#import "NSArrayCrawler.h"
#import "NSDictionaryCrawler.h"

@implementation NSArray (NSArrayCrawler)

- (NSDictionary *)valuesForMutableKeysInDescendants:(NSMutableArray *)keys {
	NSEnumerator *enumerator;
	id item;
	NSMutableDictionary *dict;
	NSMutableArray *remainingKeys;
	
	dict = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
	remainingKeys = [NSMutableArray arrayWithCapacity:[keys count]]; // copy so we don't remove from original array
	[remainingKeys addObjectsFromArray:keys];
	
	enumerator = [self objectEnumerator];	
	while (item = [enumerator nextObject])
		if ([item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSArray class]])
			[dict addEntriesFromDictionary:[item valuesForMutableKeysInDescendants:remainingKeys]]; // recursion craziness!!!
	
	return dict;
}

- (NSDictionary *)valuesForKeysInDescendants:(NSArray *)keys {
	NSMutableArray *remainingKeys;
	
	if ([keys isKindOfClass:[NSMutableArray class]]) {
		remainingKeys = (NSMutableArray *)keys;
	} else {
		remainingKeys = [NSMutableArray arrayWithCapacity:[keys count]];
		[remainingKeys addObjectsFromArray:keys];
	}
	
	return [self valuesForMutableKeysInDescendants:remainingKeys];
}

- (id)firstObjectMatchedWithTarget:(id<NSObject>)target selector:(SEL)selector criteria:(id)criteria {
	NSEnumerator *enumerator;
	id item;
	
	enumerator = [self objectEnumerator];
	while (item = [enumerator nextObject])
		if ([target performSelector:selector withObject:item withObject:criteria])
			return item;
	
	return nil;
}

@end
