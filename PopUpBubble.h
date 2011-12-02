//
//  PopUpBubble.h
//  Fateful Software
//
//  Created by Jason Jaskolka on 10/5/09.
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

#import <UIKit/UIKit.h>

@interface PopUpBubble : UIView {
	NSString *text;
	CGFloat padding;
	UIFont *font;
	UIColor *backgroundColor, *borderColor, *textColor;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic) CGFloat padding;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *backgroundColor, *borderColor, *textColor;

+ (PopUpBubble *)showWithText:(NSString *)text pointingAt:(UIView *)view;
- (CGSize)bubbleSize;
- (CGSize)size;
- (PopUpBubble *)positionAboveView:(UIView *)view;

@end