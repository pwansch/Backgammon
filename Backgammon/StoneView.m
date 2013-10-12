//
//  StoneView.m
//  Backgammon
//
//  Created by Peter Wansch on 8/18/13.
//
//

#import "StoneView.h"
#import "Algorithm.h"

@implementation StoneView
- (id)initWithFrame:(CGRect)frame :(BOOL)fWho
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.fWho = fWho;
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	// Obtain graphics context and set defaults
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.0);
    
    if (self.fWho == COMPUTER) {
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    } else if (self.fWho == PLAYER) {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }

    CGContextAddEllipseInRect(context, self.bounds);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
