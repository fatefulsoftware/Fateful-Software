//
//  PopUpBubble.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 10/5/09.
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

#import "PopUpBubble.h"
#import "UIViewTraversalAdditions.h"
#import "CGContextRoundedRect.h"

@implementation PopUpBubble

@synthesize text, padding, font, textColor, backgroundColor, borderColor;

- (id)init {
	if (self = [super init]) {
		padding = 10;
		
		text = nil;
		
		font = [UIFont systemFontOfSize:12];
		[font retain];
		
		backgroundColor = [UIColor colorWithRed:1 green:1 blue:.6 alpha:1];
		[backgroundColor retain];
		
		borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[borderColor retain];
		
		textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[textColor retain];
		
		self.opaque = NO;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		padding = 10;
		
		text = nil;
		
		font = [UIFont systemFontOfSize:12];
		[font retain];
		
		backgroundColor = [UIColor yellowColor];
		[backgroundColor retain];
		
		borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[borderColor retain];
		
		textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[textColor retain];
		
		self.opaque = NO;
	}
	
	return self;
}

+ (PopUpBubble *)showWithText:(NSString *)text pointingAt:(UIView *)view {
	PopUpBubble *bubble;
	
	bubble = [[[PopUpBubble alloc] initWithFrame:CGRectZero] autorelease];
	bubble.text = text;
	return [bubble positionAboveView:view];
}

- (CGSize)bubbleSize {
	CGSize size;
	
	size = [text sizeWithFont:font];
	
	return CGSizeMake(size.width + (padding * 2), size.height + (padding * 2));
}

- (CGSize)size {
	CGSize size;
	
	size = [self bubbleSize];
	
	size.height += padding;
	
	return size;
}

- (PopUpBubble *)positionAboveView:(UIView *)view {
	CGPoint location;
	CGSize size;
	
	location = [view locationInView:[view rootView]];
	size = [self size];
	self.frame = CGRectMake(location.x + view.frame.size.width - size.width, location.y - size.height, size.width, size.height);
	[[view rootView] addSubview:self];
	[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
	
	return self;
}

- (void)timerFired:(NSTimer *)timer {
	[self removeFromSuperview];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context;
	CGAffineTransform transform;
	CGSize size;
	
	context = UIGraphicsGetCurrentContext();

	size = [self bubbleSize];
	rect = CGRectMake(0, 0, size.width, size.height);
	
	CGContextClearRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height + padding));
	CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
	CGContextSetLineWidth(context, 1);
	
	CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
	CGContextAddRoundedRect(context, rect, padding);
	CGContextFillPath(context);
	
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextAddRoundedRect(context, rect, padding);
	CGContextStrokePath(context);
	
	CGContextSelectFont(context, [[font fontName] cStringUsingEncoding:NSUTF8StringEncoding], [font pointSize], kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetFillColorWithColor(context, [textColor CGColor]);
	transform = CGAffineTransformIdentity;
	transform.d = -1;
	CGContextSetTextMatrix(context, transform);
	CGContextShowTextAtPoint(context, padding, size.height - padding + font.descender, [text cStringUsingEncoding:NSUTF8StringEncoding], [text length]);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, size.width / 2, size.height);
	CGContextAddLineToPoint(context, size.width * .75, size.height);
	CGContextAddLineToPoint(context, size.width / 2, size.height + padding);
	CGContextAddLineToPoint(context, size.width / 2, size.height);
	CGContextClosePath(context);
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextStrokePath(context);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, size.width / 2, size.height);
	CGContextAddLineToPoint(context, size.width * .75, size.height);
	CGContextAddLineToPoint(context, size.width / 2, size.height + padding);
	CGContextAddLineToPoint(context, size.width / 2, size.height);
	CGContextClosePath(context);
	CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
	CGContextFillPath(context);
	
	CGContextSetStrokeColorWithColor(context, [backgroundColor CGColor]);
	CGContextStrokeRect(context, CGRectMake((size.width / 2) + 1, size.height - 1, (size.width / 4) - 2, 1));
	CGContextFillRect(context, CGRectMake((size.width / 2) + 1, size.height - 1, (size.width / 4) - 2, 1));
}

- (void)dealloc {
	[text release];
	text = nil;
	
	[font release];
	font = nil;
	
	[backgroundColor release];
	backgroundColor = nil;
	
	[borderColor release];
	borderColor = nil;
	
	[textColor release];
	textColor = nil;
	
    [super dealloc];
}

@end