//
//  BetterButton.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 12/5/09.
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

#import "BetterButton.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation BetterButton

@synthesize activityIndicatorStyle, color, radius, arrow, externalLabel, icon, textColor, image, title, borderColor, borderWidth, enabled, isActivityIndicatorVisible, style, textStyle, fillStyle, shapeStyle, borderStyle, boxStyle;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
		[self initialize];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame])
		[self initialize];
	
	return self;
}

- (void)initialize {
	color = [UIColor redColor];
	[color retain];
	
	textColor = [UIColor blackColor];
	[textColor retain];
	
	borderColor = nil;
	
	radius = 4;
	
	arrow = loaded = NO;
	
	externalLabel = nil;
	
	icon = image = nil;
	
	borderWidth = 0;
	
	externalLabel = nil;
	
	self.font = [UIFont boldSystemFontOfSize:10];
	
	activityIndicator = nil;
	activityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
}

- (BOOL)enabled {
	return self.userInteractionEnabled;
}

- (void)setEnabled:(BOOL)value {
	self.userInteractionEnabled = value;
	self.alpha = value ? 1 : .5;
}

- (NSString *)title {
	return [self titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)value {
	[self setTitle:value forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)value forState:(UIControlState)state {
	[super setTitle:value forState:state];
	
	[self updateAppearance];
}

- (UIImage *)icon {
	return icon;
}

- (void)setIcon:(UIImage *)newIcon {	
	[icon release];
	icon = newIcon;
	[icon retain];
	
	[self setNeedsDisplay];
}

- (UIImage *)image {
	return image;
}

- (void)setImage:(UIImage *)newImage {	
	[image release];
	image = newImage;
	[image retain];
	
	[self setNeedsDisplay];
}

- (UIColor *)color {
	return color;
}

- (void)setColor:(UIColor *)newColor {
	[color release];
	color = newColor;
	[color retain];
	
	[self updateAppearance];
}

- (UIColor *)textColor {
	return textColor;
}

- (void)setTextColor:(UIColor *)newColor {
	[textColor release];
	textColor = newColor;
	[textColor retain];
	
	[self updateAppearance];
}

- (UIColor *)borderColor {
	return borderColor;
}

- (void)setBorderColor:(UIColor *)newColor {
	[borderColor release];
	borderColor = newColor;
	[borderColor retain];
	
	[self updateAppearance];
}

- (CGFloat)borderWidth {
	return borderWidth;
}

- (void)setBorderWidth:(CGFloat)width {
	borderWidth = width;
	
	[self updateAppearance];
}

- (float)radius {
	return radius;
}

- (void)setRadius:(float)value {
	if (value == radius)
		return;
	
	radius = value;
	
	[self updateAppearance];
}

- (BOOL)arrow {
	return arrow;
}

- (void)setArrow:(BOOL)value {
	if (arrow == value)
		return;
	
	arrow = value;
	
	[self setNeedsDisplay];
}

- (UILabel *)externalLabel {
	return externalLabel;
}

- (void)setExternalLabel:(UILabel *)label {
	[externalLabel release];
	externalLabel = label;
	[externalLabel retain];
}

- (void)setHidden:(BOOL)value {
	[super setHidden:value];
	
	if (self.externalLabel)
		self.externalLabel.hidden = self.hidden;
}

- (TTStyle *)style {
	NSMutableArray *styles;
	TTStyle *s, *currentStyle, *lastStyle;
	
	styles = [NSMutableArray arrayWithCapacity:1];
	
	if (self.radius > 0 && self.shapeStyle)
		[styles addObject:self.shapeStyle];
	
	if (self.color && self.fillStyle)
		[styles addObject:self.fillStyle];
	
	if (self.borderColor && self.borderWidth > 0 && self.borderStyle)
		[styles addObject:self.borderStyle];
	
	if (self.title && self.textStyle) {
		if (self.boxStyle)
			[styles addObject:self.boxStyle];
		
		[styles addObject:self.textStyle];
	}

	if ([styles count] == 0)
		return nil;
	
	s = [styles objectAtIndex:0];
	
	[styles removeObjectAtIndex:0];
	
	lastStyle = s;
	
	for (currentStyle in styles) {
		lastStyle.next = currentStyle;
		
		lastStyle = currentStyle;
	}
	
	return s;
}

- (TTTextStyle *)textStyle {
	return [TTTextStyle styleWithFont:[self.font fontWithSize:16] color:self.textColor next:nil];
}

- (TTBoxStyle *)boxStyle {
	if (!self.borderWidth)
		return nil;
		
	return [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(self.borderWidth * 2, self.borderWidth * 2, self.borderWidth * 2, self.borderWidth * 2) next:nil];
}

- (TTStyle *)fillStyle {
	return [TTSolidFillStyle styleWithColor:self.color next:nil];
}

- (TTShapeStyle *)shapeStyle {
	return [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:self.radius] next:nil];
}

- (TTStyle *)borderStyle {
	return [TTSolidBorderStyle styleWithColor:self.borderColor width:self.borderWidth next:nil];
}

- (void)updateAppearance {
	[self setStyle:self.style forState:UIControlStateNormal];
}

- (void)willMoveToSuperview:(UIView *)superview {
	[super willMoveToSuperview:superview];
	
	[self updateAppearance];
	
	if (self.externalLabel)
		self.externalLabel.hidden = self.hidden;
	
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context;
	float half;
	
	[super drawRect:rect];
	
	context = UIGraphicsGetCurrentContext();
	
	half = rect.size.height / 2;
	
	if (self.arrow) {		
		CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
		CGContextSetLineWidth(context, 2);
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, rect.size.width - 15, half - 10);
		CGContextAddLineToPoint(context, rect.size.width - 5, half);
		CGContextAddLineToPoint(context, rect.size.width - 15, half + 10);
		CGContextStrokePath(context);
	}
	
	// draw images right side up
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	if (self.icon && (!activityIndicator || activityIndicator.hidden))
		CGContextDrawImage(context, CGRectMake(20, half - (self.icon.size.height / 2), self.icon.size.width, self.icon.size.height), [self.icon CGImage]);
	
	if (self.image && (!activityIndicator || activityIndicator.hidden))
		CGContextDrawImage(context, CGRectMake((rect.size.width - self.image.size.width) / 2, (rect.size.height - self.image.size.height) / 2, self.image.size.width, self.image.size.height), [image CGImage]);
	
	CGContextRestoreGState(context);
}

- (void)showActivityIndicator {
	if (!activityIndicator)
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorStyle];
	
	activityIndicator.frame = CGRectMake((self.frame.size.width - activityIndicator.frame.size.width) / 2, (self.frame.size.height - activityIndicator.frame.size.height) / 2, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
	
	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];
	
	[self updateAppearance];
	
	if (!activityIndicator.superview)
		[self addSubview:activityIndicator];
}

- (void)hideActivityIndicator {
	if (!activityIndicator)
		return;
	
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
	
	[self updateAppearance];
}

- (BOOL)isActivityIndicatorVisible {
	return activityIndicator ? !activityIndicator.hidden : NO;
}

- (void)dealloc {
	[color release];
	color = nil;
	
	[textColor release];
	textColor = nil;
	
	[externalLabel release];
	externalLabel = nil;
	
	[icon release];
	icon = nil;
	
	[image release];
	image = nil;
	
	[activityIndicator release];
	activityIndicator = nil;
	
	[super dealloc];
}

@end