//
//  MapAddress.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/1/09.
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
#import "MapAddress.h"

@implementation MapAddress

@synthesize address, city, state;

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.address = [decoder decodeObjectForKey:@"address"];
		self.city = [decoder decodeObjectForKey:@"city"];
		self.state = [decoder decodeObjectForKey:@"state"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:address forKey:@"address"];
	[encoder encodeObject:city forKey:@"city"];
	[encoder encodeObject:state forKey:@"state"];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\n%@, %@", address, city, state];
}

- (BOOL)isEqual:(id)object {
	MapAddress *mapAddress;
	
	if (!object || ![object isKindOfClass:[MapAddress class]])
		return NO;
	
	mapAddress = (MapAddress *)object;
	
	return [mapAddress.address compare:address options:NSCaseInsensitiveSearch] == NSOrderedSame && [mapAddress.city compare:city options:NSCaseInsensitiveSearch] == NSOrderedSame && [mapAddress.state compare:state options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

- (void)dealloc {
	[address release];
	[city release];
	[state release];
	
	[super dealloc];
}

@end