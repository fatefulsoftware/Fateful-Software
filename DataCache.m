//
//  DataCache.m
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

#import "DataCache.h"
#import "NSBundleExtensions.h"

NSString *const DataCacheResponseKey = @"Response", *const DataCacheItemKey = @"Item", *const DataCacheDateKey = @"Date";

@implementation DataCache

@synthesize autosave;

- (id)init {
	NSString *cacheMinutesString, *path;
	
	if (self = [super init]) {
		autosave = [NSBundle enabledConfigWithKey:@"Autosave Cache"];
		removeExpired = ![NSBundle disabledConfigWithKey:@"Remove Expired Cache"];
		disabled = [NSBundle disabledConfigWithKey:@"Disable Cache"];
		
		policies = [NSMutableDictionary dictionaryWithCapacity:0];
		[policies retain];
		
		cache = nil;
		
		if (!disabled) {
			cacheMinutes = 60;
			
			cacheMinutesString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Cache Minutes"];
			
			if (cacheMinutesString)
				cacheMinutes = [cacheMinutesString doubleValue];
			
			path = [[NSBundle mainBundle] pathForDocumentOrResource:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Cache File"]];
			
			if ([[NSFileManager defaultManager] fileExistsAtPath:path])			
				cache = [[NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:path] mutabilityOption:NSPropertyListMutableContainersAndLeaves format:nil errorDescription:nil] retain];
		}
		
		if (!cache)
			cache = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return self;
}

+ (DataCache *)shared {
	static DataCache *cache = nil;
	
	if (!cache)
		cache = [DataCache new];
	
	return cache;
}

- (void)addCachePolicyForPattern:(NSString *)pattern duration:(NSTimeInterval)duration {
	[policies setObject:[NSNumber numberWithDouble:duration] forKey:pattern];
}

- (id)retrieveFromCacheIgnoreExpiration:(NSString *)key response:(NSURLResponse **)response {
	NSDictionary *item;
	
	item = [cache objectForKey:key];
	
	*response = [item objectForKey:DataCacheResponseKey];
	
	if ([*response isKindOfClass:[NSNull class]])
		*response = nil;
	
	return [item objectForKey:DataCacheItemKey];
}

- (id)retrieveFromCache:(NSString *)key response:(NSURLResponse **)response {
	NSDictionary *dict;
	NSTimeInterval minutes;
	NSString *pattern;
	
	if (disabled)
		return nil;
	
	dict = [cache objectForKey:key];
	
	if (!dict)
		return nil;
	
	minutes = cacheMinutes;
	
	for (pattern in policies) {
		if ([key rangeOfString:pattern].location != NSNotFound) {
			minutes = [[policies objectForKey:pattern] doubleValue];
			
			break;
		}
	}
	
	if ([[NSDate date] timeIntervalSinceDate:(NSDate *)[dict objectForKey:DataCacheDateKey]] > (minutes * 60)) {
		if (!removeExpired)
			return nil;
		
		[cache removeObjectForKey:key];
		
		if (autosave)
			[self save];
		
		return nil;
	}
	
	*response = [dict objectForKey:DataCacheResponseKey];
	
	if ([*response isKindOfClass:[NSNull class]])
		*response = nil;
	
	return [dict objectForKey:DataCacheItemKey];
}

- (id)storeIntoCache:(id)item response:(NSURLResponse *)response withKey:(NSString *)key {
	id resp;
	
	if (!item)
		item = [NSNull null];
	
	if (response)
		resp = response;
	else
		resp = [NSNull null];
	
	[cache setObject:[NSDictionary dictionaryWithObjectsAndKeys:item, DataCacheItemKey, [NSDate date], DataCacheDateKey, resp, DataCacheResponseKey, nil] forKey:key];
	
	if (autosave)
		[self save];
	
	return item;
}

- (void)save {
	if (disabled)
		return;
	
	[cache writeToFile:[NSBundle pathForDocument:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Cache File"]] atomically:YES];
}

- (void)removeWithKey:(NSString *)key {
	[cache removeObjectForKey:key];
	
	if (autosave)
		[self save];
}

- (void)dealloc {
	[self save];
	
	[cache release];
	cache = nil;
	
	[policies release];
	policies = nil;
	
	[super dealloc];
}

@end
