//
//  HorizontalRuleView.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/3/09.
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

#import "HorizontalRuleView.h"

@implementation HorizontalRuleView

@synthesize color;

- (id)initWithCoder:(NSCoder *)coder {
	NSString *defaultColorString = nil;
	int defaultColor;
	
	if (self = [super initWithCoder:coder]) {
		defaultColorString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Default Horizontal Rule Color"];
		
		if (defaultColorString) {
			defaultColor = [defaultColorString intValue];
			self.color = [UIColor colorWithRed:(defaultColor & 0xFF0000) >> 16 green:(defaultColor & 0xFF00) >> 8 blue:defaultColor & 0xFF alpha:1];
		} else {
			self.color = [UIColor blackColor];
		}
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)rect {
	NSString *defaultColorString = nil;
	int defaultColor;
	
	if (self = [super initWithFrame:rect]) {
		defaultColorString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Default Horizontal Rule Color"];
		
		if (defaultColorString && [defaultColorString length] != 0) {
			defaultColor = [defaultColorString intValue];
			self.color = [UIColor colorWithRed:((defaultColor & 0xFF0000) >> 16) / 256 green:((defaultColor & 0xFF00) >> 8) / 256 blue:(defaultColor & 0xFF) / 256 alpha:1];
		} else {
			self.color = [UIColor blackColor];
		}
	}
	
	return self;
}

- (void)layoutSubviews {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1); // TODO: optional height
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context;
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)); // let layoutSubviews set the dimensions
}

- (void)dealloc {
	[color release];
	
    [super dealloc];
}

@end