//
//  Validator.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	ValidatorRuleTypeEmail,
	ValidatorRuleTypeMinimumLength,
	ValidatorRuleTypeRequired,
	ValidatorRuleTypeMaximumLength,
	ValidatorRuleTypeMatch
} ValidatorRuleType;

@interface Validator : NSObject {
	@protected
	
	NSMutableArray *requiredFields, *emailFields, *minimumLengthFields, *maximumLengthFields, *matchFields;
	id<NSObject> target;
	SEL customValidator;
}

@property (nonatomic, assign) IBOutlet id<NSObject> target;
@property (nonatomic, assign) IBOutlet SEL customValidator;
@property (nonatomic, readonly) NSArray *requiredFields, *emailFields, *minimumLengthFields, *maximumLengthFields, *matchFields;

+ (BOOL)isEmailAddress:(NSString *)email;
+ (NSString *)stringForRuleType:(ValidatorRuleType)type;

- (void)initialize;
- (void)addRequiredFields:(id)field, ...;
- (void)addRequiredField:(id)field;
- (void)addEmailFields:(id)field, ...;
- (void)addEmailField:(id)field;
- (void)addMinimumLengthField:(id)field length:(NSUInteger)length;
- (void)addMinimumLengthFieldsAndLengths:(id)field, ...;
- (void)addMaximumLengthField:(id)field length:(NSUInteger)length;
- (void)addMaximumLengthFieldsAndLengths:(id)field, ...;
- (void)addMatchField:(id)field withField:(id)otherField;
- (void)addMatchFieldsAndFields:(id)field, ...;
- (void)clearFields;
- (BOOL)validate;
- (BOOL)validateWithNewField:(id)newField value:(id)value;
- (BOOL)validateWithInvalidFields:(NSArray **)invalid;

@end
