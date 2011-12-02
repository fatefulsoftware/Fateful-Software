//
//  RoundedRectangleView.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 12/10/09.
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

#import "RoundedRectangleView.h"

@implementation RoundedRectangleView

@synthesize radius, color, shiny;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
		[self initialize];

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
		[self initialize];

	return self;
}

- (void)initialize {
	self.color = [UIColor colorWithRed:164.0/255 green:180.0/255 blue:190.0/255 alpha:1];
	self.opaque = self.opaque;
	self.backgroundColor = self.backgroundColor;
	radius = 0;
	shiny = NO;
}

- (BOOL)opaque {
	return NO;
}

- (UIColor *)backgroundColor {
	return [UIColor clearColor];
}

- (UIColor *)color {
	return color;
}

- (void)setColor:(UIColor *)newColor {
	[color release];
	color = newColor;
	[color retain];
	
	[self setNeedsDisplay];
}

- (BOOL)shiny {
	return shiny;
}

- (void)setShiny:(BOOL)value {
	shiny = value;
	
	[self setNeedsDisplay];
}

- (TTStyle *)style {
	TTStyle *style;
	
	style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:(radius > 0) ? radius : (self.frame.size.height / 2)] next:[TTSolidFillStyle styleWithColor:color next:nil]];
	
	if (shiny)
		style.next = [TTReflectiveFillStyle styleWithColor:color next:nil];
	
	return style;
}

- (void)dealloc {
	[color release];
	color = nil;
	
    [super dealloc];
}

@end
