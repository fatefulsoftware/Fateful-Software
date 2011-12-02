//
//  Validator.m
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

#import "Validator.h"
#import "ValidatorField.h"

NSString *const ValidatorRuleRequired = @"Required", *const ValidatorRuleEmail = @"Email", *const ValidatorRuleMinimumLength = @"Minimum Length", *const ValidatorRuleMaximumLength = @"Maximum Length", *const ValidatorRuleMatch = @"Does not match";

@implementation Validator

@synthesize target, customValidator, requiredFields, emailFields, minimumLengthFields, maximumLengthFields, matchFields;

- (id)init {
	if (self = [super init])
		[self initialize];
	
	return self;
}

- (void)initialize {
	requiredFields = [[NSMutableArray alloc] initWithCapacity:0];	
	emailFields = [[NSMutableArray alloc] initWithCapacity:0];
	minimumLengthFields = [[NSMutableArray alloc] initWithCapacity:0];
	maximumLengthFields = [[NSMutableArray alloc] initWithCapacity:0];
	matchFields = [[NSMutableArray alloc] initWithCapacity:0];
	
	target = nil;
}

#pragma mark Class Methods

+ (BOOL)isEmailAddress:(NSString *)email {
	return [email rangeOfString:@"@"].location != NSNotFound && [email rangeOfString:@"."].location != NSNotFound;
}

+ (NSString *)stringForRuleType:(ValidatorRuleType)type {
	if (type == ValidatorRuleTypeRequired)
		return ValidatorRuleRequired;
	else if (type == ValidatorRuleTypeEmail)
		return ValidatorRuleEmail;
	else if (type == ValidatorRuleTypeMinimumLength)
		return ValidatorRuleMinimumLength;
	else if (type == ValidatorRuleTypeMaximumLength)
		return ValidatorRuleMaximumLength;
	else if (type == ValidatorRuleTypeMatch)
		return ValidatorRuleMatch;
	
	return nil;
}

#pragma mark -

- (void)addRequiredFields:(id)field, ... {
	va_list argument_list;
	
	if (field)
		[requiredFields addObject:field];
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id)))
		[requiredFields addObject:field];
	
	va_end(argument_list);
}

- (void)addRequiredField:(id)field {
	[requiredFields addObject:field];
}

- (void)addEmailFields:(id)field, ... {
	va_list argument_list;
	
	if (field)
		[emailFields addObject:field];
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id)))
		[emailFields addObject:field];
	
	va_end(argument_list);
}

- (void)addEmailField:(id)field {
	[emailFields addObject:field];
}

- (void)addMinimumLengthField:(id)field length:(NSUInteger)length {
	ValidatorField *validatorField;
	
	validatorField = [ValidatorField new];
	validatorField.field = field;
	validatorField.criterion = [NSNumber numberWithUnsignedInt:length];
	
	[minimumLengthFields addObject:validatorField];
	
	[validatorField release];
}

- (void)addMinimumLengthFieldsAndLengths:(id)field, ... {
	va_list argument_list;
	NSUInteger i;
	id lastField;
	ValidatorField *validatorField;
	
	lastField = field;
	
	i = 0;
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id))) {
		if (i % 2 == 0) {
			validatorField = [ValidatorField new];
			validatorField.field = lastField;
			validatorField.criterion = field;
			
			[minimumLengthFields addObject:validatorField];
			
			[validatorField release];
		} else {
			lastField = field;
		}
	}
	
	va_end(argument_list);
}

- (void)addMaximumLengthField:(id)field length:(NSUInteger)length {
	ValidatorField *validatorField;
	
	validatorField = [ValidatorField new];
	validatorField.field = field;
	validatorField.criterion = [NSNumber numberWithUnsignedInt:length];
	
	[maximumLengthFields addObject:validatorField];
	
	[validatorField release];
}

- (void)addMaximumLengthFieldsAndLengths:(id)field, ... {
	va_list argument_list;
	NSUInteger i;
	id lastField;
	ValidatorField *validatorField;
	
	lastField = field;
	
	i = 0;
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id))) {
		if (i % 2 == 0) {
			validatorField = [ValidatorField new];
			validatorField.field = lastField;
			validatorField.criterion = field;
			
			[maximumLengthFields addObject:validatorField];
			
			[validatorField release];
		} else {
			lastField = field;
		}
	}
	
	va_end(argument_list);
}

- (void)addMatchField:(id)field withField:(id)otherField {
	ValidatorField *validatorField;
	
	validatorField = [ValidatorField new];
	validatorField.field = field;
	validatorField.criterion = otherField;
	
	[matchFields addObject:validatorField];
	
	[validatorField release];
}

- (void)addMatchFieldsAndFields:(id)field, ... {
	va_list argument_list;
	NSUInteger i;
	id lastField;
	ValidatorField *validatorField;
	
	lastField = field;
	
	i = 0;
	
	va_start(argument_list, field);
	
	while ((field = va_arg(argument_list, id))) {
		if (i % 2 == 0) {
			validatorField = [ValidatorField new];
			validatorField.field = lastField;
			validatorField.criterion = field;
			
			[matchFields addObject:validatorField];
			
			[validatorField release];
		} else {
			lastField = field;
		}
	}
	
	va_end(argument_list);
}

- (void)clearFields {
	[requiredFields removeAllObjects];
	[emailFields removeAllObjects];
	[minimumLengthFields removeAllObjects];
	[maximumLengthFields removeAllObjects];
	[matchFields removeAllObjects];
}

- (BOOL)validate {
	id field;
	NSUInteger secondsPerYear;
	ValidatorField *validatorField;
	
	for (field in requiredFields) {
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field withObject:nil])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] > 0)
				continue;
		} else if ([field respondsToSelector:@selector(isSelected)]) {
			if ([field isSelected])
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	for (field in emailFields)
		if ([field respondsToSelector:@selector(text)] && [field text] && [[field text] length] > 0 && ![Validator isEmailAddress:[field text]])
			return NO;
	
	secondsPerYear = 365 * 24 * 60 * 60;
	
	for (field in minimumLengthFields) {
		validatorField = field;		
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] >= [validatorField.criterion unsignedIntValue])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] timeIntervalSinceNow] >= ([validatorField.criterion unsignedIntValue] * secondsPerYear))
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	for (field in maximumLengthFields) {
		validatorField = field;		
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] <= [validatorField.criterion unsignedIntValue])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] timeIntervalSinceNow] <= ([validatorField.criterion unsignedIntValue] * secondsPerYear))
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	for (field in matchFields) {
		validatorField = field;		
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				return NO;
			
			continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] isEqualToString:[validatorField.criterion text]])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] compare:[validatorField.criterion date]] == NSOrderedSame)
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	return YES;
}

- (BOOL)validateWithNewField:(id)newField value:(id)value {
	id field;
	NSString *text;
	NSUInteger secondsPerYear;
	ValidatorField *validatorField;
	
	for (field in requiredFields) {
		if (newField == field)
			text = value;
		else
			text = [field respondsToSelector:@selector(text)] ? [field text] : nil;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field withObject:text])
				continue;
		} else if (text) {
			if ([text length] > 0)
				continue;
		} else if ([field respondsToSelector:@selector(isSelected)]) {
			if ([field isSelected])
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	for (field in emailFields) {
		if (field == newField)
			text = value;
		else
			text = [field respondsToSelector:@selector(text)] ? [field text] : nil;
		
		if (text) {
			if ([text length] == 0 || [Validator isEmailAddress:text])
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	secondsPerYear = 365 * 24 * 60 * 60;
	
	for (field in minimumLengthFields) {
		validatorField = field;
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;		
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] >= [validatorField.criterion unsignedIntValue])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] timeIntervalSinceNow] >= ([validatorField.criterion unsignedIntValue] * secondsPerYear))
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	for (field in maximumLengthFields) {
		validatorField = field;
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] <= [validatorField.criterion unsignedIntValue])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] timeIntervalSinceNow] <= ([validatorField.criterion unsignedIntValue] * secondsPerYear))
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	for (field in matchFields) {
		validatorField = field;
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] isEqualToString:[validatorField.criterion text]])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] compare:[validatorField.criterion date]] == NSOrderedSame)
				continue;
		} else {
			continue;
		}
		
		return NO;
	}
	
	return YES;
}

- (BOOL)validateWithInvalidFields:(NSArray **)invalid {
	id field;
	NSUInteger secondsPerYear;
	NSMutableArray *invalidFields;
	ValidatorField *validatorField;
	
	invalidFields = [NSMutableArray arrayWithCapacity:0];
	
	for (field in requiredFields) {
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field withObject:nil])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] > 0)
				continue;
		} else if ([field respondsToSelector:@selector(isSelected)]) {
			if ([field isSelected])
				continue;
		} else {
			continue;
		}
		
		validatorField = [ValidatorField new];
		validatorField.field = field;
		validatorField.type = ValidatorRuleTypeRequired;		
		[invalidFields addObject:validatorField];		
		[validatorField release];
	}
	
	for (field in emailFields) {
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if (![field text] || [[field text] length] == 0 || [Validator isEmailAddress:[field text]])
				continue;
		} else {
			continue;
		}
		
		validatorField = [ValidatorField new];
		validatorField.field = field;
		validatorField.type = ValidatorRuleTypeEmail;		
		[invalidFields addObject:validatorField];		
		[validatorField release];
	}
	
	secondsPerYear = 365 * 24 * 60 * 60;
	
	for (field in minimumLengthFields) {
		validatorField = field;
		validatorField.type = ValidatorRuleTypeMinimumLength;
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] >= [validatorField.criterion unsignedIntValue])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] timeIntervalSinceNow] >= ([validatorField.criterion unsignedIntValue] * secondsPerYear))
				continue;
		} else {
			continue;
		}
		
		[invalidFields addObject:validatorField];
	}
	
	for (field in maximumLengthFields) {
		validatorField = field;
		validatorField.type = ValidatorRuleTypeMaximumLength;
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] length] <= [validatorField.criterion unsignedIntValue])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] timeIntervalSinceNow] <= ([validatorField.criterion unsignedIntValue] * secondsPerYear))
				continue;
		} else {
			continue;
		}
		
		[invalidFields addObject:validatorField];
	}
	
	for (field in matchFields) {
		validatorField = field;
		validatorField.type = ValidatorRuleTypeMatch;
		field = validatorField.field;
		
		if (target && customValidator) {
			if ([target performSelector:customValidator withObject:field])
				continue;
		} else if ([field respondsToSelector:@selector(text)]) {
			if ([field text] && [[field text] isEqualToString:[validatorField.criterion text]])
				continue;
		} else if ([field respondsToSelector:@selector(date)]) {
			if ([field date] && [[field date] compare:[validatorField.criterion date]] == NSOrderedSame)
				continue;
		} else {
			continue;
		}
		
		[invalidFields addObject:validatorField];
	}
				 
	*invalid = invalidFields;
	
	return [invalidFields count] == 0;
}

- (void)dealloc {
	[requiredFields release];
	requiredFields = nil;
	
	[emailFields release];
	emailFields = nil;
	
	[minimumLengthFields release];
	minimumLengthFields = nil;
	
	[maximumLengthFields release];
	maximumLengthFields = nil;
	
	[matchFields release];
	matchFields = nil;
	
	target = nil;
	
	[super dealloc];
}

@end
