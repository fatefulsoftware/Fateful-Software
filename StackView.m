//
//  StackView.m
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

#import "StackView.h"
#import "HorizontalRuleView.h"

@implementation StackView

@synthesize separateWithRules;

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		loaded = NO;
		self.separateWithRules = NO;
	}
	
	return self;
}

- (void)layoutSubviews {
	[self stackViews];
	loaded = YES;
}

- (void)stackViews {
	NSEnumerator *enumerator;
	UIView *view, *lastView;
	NSInteger i;
	
	if (separateWithRules) {
		for (i = 0; i < [self.subviews count]; i++)
			if ([[self.subviews objectAtIndex:i] isKindOfClass:[HorizontalRuleView class]])
				[[self.subviews objectAtIndex:i] removeFromSuperview];
			
		for (i = [self.subviews count] - 1; i >= 1; i--) // go backwards to avoid index shift adjustments
			[self insertSubview:[[[HorizontalRuleView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)] autorelease] atIndex:i];
	}
	
	enumerator = [self.subviews objectEnumerator];
	if (view = [enumerator nextObject]) {
		// first view
		view.frame = CGRectMake(0, 0, self.frame.size.width, view.frame.size.height);
		lastView = view;
		
		// stack them
		while (view = [enumerator nextObject]) {
			view.frame = CGRectMake(0, lastView.frame.origin.y + lastView.frame.size.height, self.frame.size.width, view.frame.size.height);
			lastView = view;
		}
	}
}

- (void)didAddSubview:(UIView *)subview {
	[super didAddSubview:subview];
	
	if (!loaded)
		return;
	
	[self stackViews];
}

- (CGFloat)contentHeight {
	NSEnumerator *enumerator;
	UIView *view;
	CGFloat height = 0;
	
	enumerator = [self.subviews objectEnumerator];
	while (view = [enumerator nextObject])
		height += view.frame.size.height;
	
	return height;
}

@end
