//
//  SwipeView.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 6/30/09.
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

#import "SwipeView.h"

@implementation SwipeView

- (void)willMoveToSuperview:(UIView *)view {
	self.backgroundColor = [UIColor clearColor];
	self.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	firstTouch = [(UITouch *)[touches anyObject] locationInView:(UIView *)self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGFloat horizontalDistance, verticalDistance, horizontalThreshold, verticalThreshold;
	CGPoint point;
	
	point = [(UITouch *)[touches anyObject] locationInView:self];
	
	horizontalDistance = point.x - firstTouch.x;
	verticalDistance = point.y - firstTouch.y;
	
	horizontalThreshold = SWIPE_THRESHOLD * self.frame.size.width;
	verticalThreshold = SWIPE_THRESHOLD * self.frame.size.height;
	
	if (horizontalDistance >= horizontalThreshold)
		[self viewDidSwipeRight:horizontalDistance];
	else if (-horizontalDistance >= horizontalThreshold)
		[self viewDidSwipeLeft:-horizontalDistance];
	
	if (verticalDistance >= verticalThreshold)
		[self viewDidSwipeDown:verticalDistance];
	else if (-verticalDistance >= verticalThreshold)
		[self viewDidSwipeUp:-verticalDistance];
}

- (void)viewDidSwipeRight:(CGFloat)distance {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SwipedRight" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:distance] forKey:@"Distance"]];
}

- (void)viewDidSwipeLeft:(CGFloat)distance {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SwipedLeft" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:distance] forKey:@"Distance"]];
}

- (void)viewDidSwipeUp:(CGFloat)distance {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SwipedUp" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:distance] forKey:@"Distance"]];
}

- (void)viewDidSwipeDown:(CGFloat)distance {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SwipedDown" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:distance] forKey:@"Distance"]];
}

@end