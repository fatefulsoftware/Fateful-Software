//
//  BaseViewController.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 11/9/09.
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

#import "BaseViewController.h"
#import "DeviceDetection.h"
#import "FSNotificationCenter.h"

@implementation BaseViewController

@synthesize loading, visible;

#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
		[self initialize];
	
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidHide:(NSNotification *)notification {
	if (!self.loading)
		return;
	
	// expand "modal" activity indicator view in case it was sized short when the keyboard was shown
	CGRect fullscreen = [[UIScreen mainScreen] applicationFrame];
	activityIndicator.frame = fullscreen; 
}

- (NSString *)nibName {
	return [DeviceDetection detectDevice] == MODEL_IPAD ? [[super nibName] stringByAppendingString:@"-ipad"] : [super nibName];
}

- (void)viewDidUnload {
	[activityIndicator release];
	activityIndicator = nil;
	
	[spinner release];
	spinner = nil;
	
	[super viewDidUnload];
}

#pragma mark -

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
		[self initialize];
	
	return self;
}

#pragma mark -

#pragma mark Initialization

- (void)initialize {
	activityIndicator = nil;
	spinner = nil;
}

#pragma mark -

- (BOOL)loading {
	return activityIndicator && !activityIndicator.hidden;
}

- (void)setLoading:(BOOL)value {	
	if (value) {
		if (!activityIndicator) {
			CGRect fullscreen = [[UIScreen mainScreen] applicationFrame];
			activityIndicator = [[UIWindow alloc] initWithFrame:fullscreen];
			activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			activityIndicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
			activityIndicator.opaque = NO;
			
			spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
			[spinner startAnimating];
			
			[activityIndicator addSubview:spinner];
			
			[activityIndicator makeKeyAndVisible];
		}
		
		spinner.center = CGPointMake(activityIndicator.frame.size.width / 2, activityIndicator.frame.size.height / 2);
		
		activityIndicator.hidden = NO;
	} else if (activityIndicator) {
		activityIndicator.hidden = YES;
	}
}

- (BOOL)visible {
	if (self.modalViewController)
		return NO;
	
	if (self.navigationController) {
		if (self.navigationController.topViewController != self)
			return NO;
		
		if (self.tabBarController && self.tabBarController.selectedViewController != self.navigationController)
			return NO;
		
		return YES;
	} else if (!self.tabBarController) {
		return self.parentViewController != nil;
	}
	
	if (self.tabBarController && self.tabBarController.selectedViewController != self)
		return NO;
	
	return YES;
}

- (void)pushViewController:(UIViewController *)viewControler {
	[self.navigationController pushViewController:viewControler animated:YES];
}

- (void)popViewController {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Deallocation

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[FSNotificationCenter shared] removeObserver:self];
	
	[activityIndicator release];
	activityIndicator = nil;
	
	[spinner release];
	spinner = nil;
	
	[super dealloc];
}

#pragma mark -

@end
