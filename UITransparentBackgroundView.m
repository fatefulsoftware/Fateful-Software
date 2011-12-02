//
//  UITransparentBackgroundView.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/22/09.
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

#import "UITransparentBackgroundView.h"

@implementation UITransparentBackgroundView

+ (UIView *)makeBackgroundTransparentForView:(UIView *)view {
	NSEnumerator *enumerator;
	UIView *child;
	const CGFloat *components;
	
	if (view.backgroundColor) {
		components = CGColorGetComponents([view.backgroundColor CGColor]);
		
		if (components[0] == 1.0 && components[1] == 1.0 && components[2] == 1.0) {
			view.backgroundColor = [UIColor clearColor];
			view.opaque = NO;
		}
	}
	
	enumerator = [view.subviews objectEnumerator];
	while (child = [enumerator nextObject])
		[UITransparentBackgroundView makeBackgroundTransparentForView:child];
	
	return view;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[UITransparentBackgroundView makeBackgroundTransparentForView:self];
}

@end