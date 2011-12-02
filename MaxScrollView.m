//
//  MaxScrollView.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 11/8/09.
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

#import "MaxScrollView.h"

@implementation MaxScrollView

#pragma mark Initialization

- (void)initialize {
	activeField = nil;
	
	extraFields = [[NSMutableArray alloc] initWithCapacity:0];
	extraContainers = [[NSMutableArray alloc] initWithCapacity:0];
	keyboard = NO;
}

#pragma mark -

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
		[self initialize];
	
	return self;
}

#pragma mark -

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame])
		[self initialize];
	
	return self;
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	[MaxScrollView performSelector:@selector(observeTextFieldDidBeginEditing:) target:self subviews:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark -

+ (CGPoint)pointOfView:(UIView *)view inSuperview:(UIView *)parent {
	CGFloat x, y;
	
	x = y = 0;
	
	while (view && view.superview) {
		x += view.frame.origin.x;
		y += view.frame.origin.y;
		
		if (parent && view.superview == parent)
			break;
		
		view = view.superview;
	}
	
	return CGPointMake(x, y);
}

- (CGPoint)pointInSuperview:(UIView *)parent {
	return [[self class] pointOfView:self inSuperview:parent];
}

+ (void)performSelector:(SEL)selector target:(id<NSObject>)target subviews:(UIView *)parent {
	NSEnumerator *enumerator;
	UIView *view;
	
	enumerator = [parent.subviews objectEnumerator];
	while (view = [enumerator nextObject]) {
		[target performSelector:selector withObject:view];
		
		[MaxScrollView performSelector:selector target:target subviews:view];
	}
}

- (void)observeTextFieldDidBeginEditing:(UIView *)view {
	if ([view isKindOfClass:[UITextField class]])
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:view];
	else if ([view isKindOfClass:[UITextView class]])
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:view];
}

#pragma mark Notifications

- (void)textFieldDidBeginEditing:(NSNotification *)notification {
	[activeField release];
	activeField = [[notification object] retain];
}

- (void)keyboardDidShow:(NSNotification *)notification {
	CGRect frame, myFrame, applicationFrame;
	NSUInteger index;
	UIInterfaceOrientation orientation;
	
	if (keyboard)
		return;
	
	keyboard = YES;
	
	if (!self.scrollEnabled)
		return;
	
	index = [extraFields indexOfObject:activeField];
	
	if (index == NSNotFound) {
		frame.origin = [[self class] pointOfView:activeField inSuperview:self];
		frame.size = activeField.frame.size;
	} else {
		frame = [(NSValue *)[extraContainers objectAtIndex:index] CGRectValue];
	}
		
	originalSize = self.frame.size;
	
	applicationFrame = [UIScreen mainScreen].applicationFrame;
	orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	myFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, UIInterfaceOrientationIsLandscape(orientation) ? applicationFrame.size.width : applicationFrame.size.height + 20);
	myFrame.size.height -= [((NSValue *)[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey]) CGRectValue].size.height;
	myFrame.size.height -= [self pointInSuperview:nil].y;
	self.frame = myFrame;
	
	[self scrollRectToVisible:frame animated:YES];
}

- (void)keyboardDidHide:(NSNotification *)notification {
	if (self.scrollEnabled)
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, originalSize.width, originalSize.height);
	
	keyboard = NO;
}

#pragma mark -

#pragma mark UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[activeField resignFirstResponder];
}

#pragma mark -

- (void)addExtraField:(UIControl *)field withContainer:(UIView *)container {
	[self addExtraField:field withRect:(container ? container : field).frame];
}

- (void)addExtraField:(UIControl *)field withRect:(CGRect)rect {
	[extraFields addObject:field];
	
	[extraContainers addObject:[NSValue valueWithCGRect:rect]];
	
	[self observeTextFieldDidBeginEditing:field];
}

#pragma mark Deallocation

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[activeField release];
	activeField = nil;
	
	[extraFields release];
	extraFields = nil;
	
	[extraContainers release];
	extraContainers = nil;
	
	[super dealloc];
}

#pragma mark -

@end
