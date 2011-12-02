//
//  ValidatorField.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 5/17/10.
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

#import "ValidatorField.h"
#import "Validator.h"

@implementation ValidatorField

@synthesize type, field, criterion;

#pragma mark NSObject

- (id)init {
    if (self = [super init]) {
		type = ValidatorRuleTypeRequired;
		field = criterion = nil;
	}

    return self;
}

#pragma mark -

#pragma mark Deallocation

- (void)dealloc {
	[field release];
	field = nil;
	
	[criterion release];
	criterion = nil;
	
    [super dealloc];
}

#pragma mark -

@end
