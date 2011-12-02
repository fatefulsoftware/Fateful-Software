//
//  BetterTabBarController.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 1/18/09.
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
#import <UIKit/UIKit.h>
#import "BetterTabBarController.h"
#import "FSNotificationCenter.h"

@implementation BetterTabBarController

- (void)popNavigationControllersToRoot {
	id controller;
	
	for (controller in self.viewControllers)
		if ([controller isKindOfClass:[UINavigationController class]])
			[(UINavigationController *)controller popToRootViewControllerAnimated:NO];
}

- (void)setSelectedIndex:(NSUInteger)value {
	[super setSelectedIndex:value];
	
	[self popNavigationControllersToRoot];
}

- (void)setSelectedViewController:(UIViewController *)value {
	[super setSelectedViewController:value];
	
	[self popNavigationControllersToRoot];
}

#pragma mark Deallocation

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[FSNotificationCenter shared] removeObserver:self];
	
	[super dealloc];
}

#pragma mark -

@end