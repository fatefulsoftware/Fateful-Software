//
//  NSBundleExtensions.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 4/12/09.
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

#import "NSBundleExtensions.h"

@implementation NSBundle (NSBundleExtensions)

- (NSString *)pathForDocumentOrResource:(NSString *)filename {
	NSString *path;
	
	path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filename];
	return [[NSFileManager defaultManager] fileExistsAtPath:path] ? path : [self pathForResource:filename ofType:@""];
}

+ (NSString *)pathForDocument:(NSString *)filename {
	return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filename];
}

+ (BOOL)enabledConfigWithKey:(NSString *)key {
	NSString *value;
	
	value = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
	
	if (value && ([value caseInsensitiveCompare:@"yes"] || [value caseInsensitiveCompare:@"true"] || [value caseInsensitiveCompare:@"1"]))
		return YES;
	
	return NO;
}

+ (BOOL)disabledConfigWithKey:(NSString *)key {
	NSString *value;
	
	value = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
	
	if (value && ([value caseInsensitiveCompare:@"no"] || [value caseInsensitiveCompare:@"false"] || [value caseInsensitiveCompare:@"0"] || [value caseInsensitiveCompare:@"-1"]))
		return YES;
	
	return NO;
}

@end
