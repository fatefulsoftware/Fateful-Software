//
//  ValidatorViewController.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 11/18/09.
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

#import "ValidatorViewController.h"

@implementation ValidatorViewController

@synthesize validator, submitButton, validateOnTextChange, autoFocusNextField, showRequiredLabels;

#pragma mark BaseViewController

- (void)initialize {
	[super initialize];
	
	validator = [Validator new];
	validator.target = self;
	validator.customValidator = @selector(validateField:withValue:);
	
	submitButton = nil;
	
	validateOnTextChange = autoFocusNextField = showRequiredLabels = NO;
	
	requiredLabels = [[NSMutableArray alloc] initWithCapacity:0];
	textFields = [[NSMutableArray alloc] initWithCapacity:0];
}

#pragma mark -

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([submitButton isKindOfClass:[UIControl class]]) {
		[submitButton addTarget:self action:@selector(didPressSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
	} else if ([submitButton isKindOfClass:[UIBarButtonItem class]]) {
		[submitButton setTarget:self];
		[submitButton setAction:@selector(didPressSubmitButton:)];
	}
	
	[self layoutRequiredLabels];
}

- (void)viewDidUnload {
	[validator release];
	validator = nil;
	
	[submitButton release];
	submitButton = nil;
	
	[super viewDidUnload];
}

#pragma mark -

- (void)layoutRequiredLabels {
	UIView *view;
	UILabel *label;
	
	if (!self.view)
		return;
	
	for (view in requiredLabels)
		[view removeFromSuperview];
	
	if (!showRequiredLabels)
		return;
	
	[requiredLabels removeAllObjects];
	
	for (view in validator.requiredFields) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x + view.frame.size.width, 10, 10, 21)];
		
		label.textColor = [UIColor redColor];
		label.text = @"*";
		label.backgroundColor = [UIColor clearColor];
		label.font = [label.font fontWithSize:24];
		
		[requiredLabels addObject:label];
		[view.superview addSubview:label];
		
		[label release];
	}
}

- (BOOL)validateField:(id)field withValue:(id)value {
	if (value && [value isKindOfClass:[NSString class]])
		return [value length] > 0;
	
	if ([field respondsToSelector:@selector(text)])
		return [field text] && [[field text] length] > 0;
	
	return YES;
}

- (BOOL)showRequiredLabels {
	return showRequiredLabels;
}

- (void)setShowRequiredLabels:(BOOL)value {
	showRequiredLabels = value;
	
	[self layoutRequiredLabels];
}

- (void)clearFields {
	id field;
	
	[validator clearFields];
	
	for (field in validator.requiredFields) {
		if ([field isKindOfClass:[UITextField class]])
			((UITextField *)field).delegate = nil;
		else if ([field isKindOfClass:[UITextView class]])
			((UITextView *)field).delegate = nil;
	}
	
	[self layoutRequiredLabels];
}

#pragma mark Actions

- (IBAction)didPressSubmitButton:(id)sender {
	id field;
	
	if (validateOnTextChange) {
		for (field in validator.requiredFields)
			if ([field isKindOfClass:[UITextField class]] || [field isKindOfClass:[UITextView class]])
				[field resignFirstResponder];
				
		
		return;
	}
	
	[self validate];
}

#pragma mark -

- (void)viewDidValidate {
}

- (void)viewDidInvalidate {
	if (validateOnTextChange)
		return; // don't annoy user with every character change
	
	[[[[UIAlertView alloc] initWithTitle:@"Invalid" message:@"Missing a required field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

- (BOOL)validate {
	if ([validator validate]) {
		[self viewDidValidate];
		
		return YES;
	} else {
		[self viewDidInvalidate];
		
		return NO;
	}
}

- (BOOL)validateWithNewField:(id)field value:(id)value {
	if ([validator validateWithNewField:field value:value]) {
		[self viewDidValidate];
		
		return YES;
	} else {
		[self viewDidInvalidate];
		
		return NO;
	}
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {	
	if (!validateOnTextChange)
		return YES;
	
	[self validateWithNewField:textField value:[textField.text stringByReplacingCharactersInRange:range withString:string]];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSUInteger index, count;
	UITextField *field;
	BOOL found;
	
	if (!autoFocusNextField)
		return YES;
	
	[textField resignFirstResponder];
	
	index = [textFields indexOfObject:textField];
	
	if (index == ([textFields count] - 1)) {
		[self didPressSubmitButton:textField];
		
		return YES;
	}
	
	count = [textFields count];
	
	found = NO;
	
	for (index++; index < count; index++) {
		field = [textFields objectAtIndex:index];
		
		if (!field.hidden && field.enabled) {
			[field becomeFirstResponder];
			
			found = YES;
			
			break;
		}
	}
	
	if (!found)
		[self didPressSubmitButton:textField];
	
	return YES;
}

#pragma mark -

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	if (!validateOnTextChange)
		return;
	
	[self validateWithNewField:textView value:textView.text];
}

#pragma mark -

- (void)addRequiredFields:(id)field, ... {
	va_list argument_list;
	
	if (field)
		[self addRequiredField:field];
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id)))
		[self addRequiredField:field];
	
	va_end(argument_list);
}

- (void)addRequiredField:(id)field {
	if ([field isKindOfClass:[UITextField class]]) {
		((UITextField *)field).delegate = self;
		
		[textFields addObject:field];
	} else if ([field isKindOfClass:[UITextView class]]) {
		((UITextView *)field).delegate = self;
		
		[textFields addObject:field];
	}
	
	[validator addRequiredField:field];
	
	[self layoutRequiredLabels];
}

- (void)addEmailFields:(id)field, ... {
	va_list argument_list;
	
	if (field)
		[self addEmailField:field];
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id)))
		[self addEmailField:field];
	
	va_end(argument_list);
}

- (void)addEmailField:(id)field {
	if ([field isKindOfClass:[UITextField class]])
		[field setDelegate:self];
	
	[validator addEmailField:field];
}

#pragma mark Deallocation

- (void)dealloc {
	[requiredLabels release];
	requiredLabels = nil;
	
	[textFields release];
	textFields = nil;
	
	[validator release];
	validator = nil;
	
	[submitButton release];
	submitButton = nil;
	
    [super dealloc];
}

#pragma mark -

@end