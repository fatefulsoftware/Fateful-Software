//
//  BetterButton.h
//  Fateful Software
//
//  Created by Jason Jaskolka on 12/5/09.
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
#import "Three20/TTStyle.h"
#import "Three20/TTButton.h"
#import <CoreGraphics/CoreGraphics.h>

@interface BetterButton : TTButton {
	UIColor *color, *textColor, *borderColor;
	float radius;
	BOOL arrow, loaded;
	UILabel *externalLabel;
	UIImage *icon, *image;
	CGFloat borderWidth;
	UIActivityIndicatorView *activityIndicator;
	UIActivityIndicatorViewStyle activityIndicatorStyle;
}

@property (nonatomic, retain) UIColor *color, *textColor, *borderColor;
@property (nonatomic, assign) float radius, borderWidth;
@property (nonatomic, assign) BOOL arrow, enabled;
@property (nonatomic, readonly) BOOL isActivityIndicatorVisible;
@property (nonatomic, retain) IBOutlet UILabel *externalLabel;
@property (nonatomic, retain) IBOutlet UIImage *icon, *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
@property (nonatomic, readonly) TTShapeStyle *shapeStyle;
@property (nonatomic, readonly) TTStyle  *fillStyle, *borderStyle, *style;
@property (nonatomic, readonly) TTTextStyle *textStyle;
@property (nonatomic, readonly) TTBoxStyle *boxStyle;

- (void)initialize;

- (void)updateAppearance;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end