//
//  TileView.m
//  Fateful Software
//
//  Created by Jason Jaskolka on 12/19/09.
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

#import <CoreGraphics/CoreGraphics.h>
#import "TileView.h"

@implementation TileView

@synthesize image;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
		[self initialize];

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
		[self initialize];

	return self;
}

- (void)initialize {
	image = nil;
}

- (UIImage *)image {
	return image;
}

- (void)setImage:(UIImage *)newImage {
	[image release];
	image = newImage;
	[image retain];
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	int i, j;
	CGImageRef cgImage;
	CGContextRef context;
	CGRect imageRect;
	CGFloat w, h;
	
	[super drawRect:rect];
	
	if (!image)
		return;
	
	context = UIGraphicsGetCurrentContext();
	cgImage = [image CGImage];
	w = image.size.width;
	h = image.size.height;
	imageRect = CGRectMake(0, 0, w, h);
	
	for (j = 0; j < rect.size.width; j += w) {
		imageRect.origin.y = 0;
		
		for (i = 0; i < rect.size.height; i += h) {
			CGContextDrawImage(context, imageRect, cgImage);
			
			imageRect.origin.y += h;
		}
		
		imageRect.origin.x += w;
	}
}

- (void)dealloc {
	[image release];
	image = nil;
	
    [super dealloc];
}

@end