//
//  MainView.m
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import "MainView.h"
#import "Algorithm.h"
int counterxx = 0;
@interface MainView ()
// Class extensions and utility functions
CGFloat ulConvertY(CGFloat ulFromY, CGFloat NOPOINTS);
- (CGRect)statusBarFrameViewRect;
@end

@implementation MainView

@synthesize usScorePlayer;
@synthesize usScoreComputer;
@synthesize usDice1;
@synthesize usDice2;
@synthesize board;
@synthesize text;
@synthesize animationLock;
@synthesize fDrawText;
@synthesize hbm1;
@synthesize hbm2;
@synthesize hbm3;
@synthesize hbm4;
@synthesize hbm5;
@synthesize hbm6;
@synthesize grabbedStone;
@synthesize animatedDice1;
@synthesize animatedDice2;
@synthesize mainViewController;

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder]))
	{
		// Initialize variables
        self.usDice1 = 1;
        self.usDice2 = 1;
        self.fDrawText = NO;
        self.isAnimating = NO;
        
        // Load images
        self.hbm1 = [UIImage imageNamed:@"dice1.png"];
        self.hbm2 = [UIImage imageNamed:@"dice2.png"];
        self.hbm3 = [UIImage imageNamed:@"dice3.png"];
        self.hbm4 = [UIImage imageNamed:@"dice4.png"];
        self.hbm5 = [UIImage imageNamed:@"dice5.png"];
        self.hbm6 = [UIImage imageNamed:@"dice6.png"];
        self.grabbedStone = [[StoneView alloc] initWithFrame:[self rectCalc:0:0]:PLAYER];
        self.grabbedStone.hidden = YES;
        [self addSubview:grabbedStone];
        
        // Keep the background transparent
	}
    return self;
}

CGFloat ulConvertY(CGFloat ulFromY, CGFloat NOPOINTS)
{
	return (((DIVISIONSY + 2) * NOPOINTS) - ulFromY);
}

// Custom drawing
- (void)drawRect:(CGRect)rect
{
    CGRect rectPaint, rectIntersect;
    CGPoint pointBorder[4];
    CGPoint ptl;

	// Obtain graphics context and set defaults
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font = [UIFont systemFontOfSize:14];
    } else {
        font = [UIFont systemFontOfSize:28];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dictionaryWhite = @{NSFontAttributeName: font,  NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *dictionaryBlack = @{NSFontAttributeName: font,  NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor blackColor]};
    
	// Calculate block size, starting point and offset
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    
    // Draw the background in green
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f].CGColor);
    rectPaint = CGRectMake(0, 0, (DIVISIONSX + 2) * NOPOINTS + 2 * ptlOffset.x, NOPOINTS + 2 * ptlOffset.y);
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFill);
    }
        
    rectPaint = CGRectMake(0, ptlOffset.y + ulConvertY(NOPOINTS, NOPOINTS), (DIVISIONSX + 2) * NOPOINTS + 2 * ptlOffset.x, NOPOINTS + 2 * ptlOffset.y);
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFill);
    }
        
    rectPaint = CGRectMake(0, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS, NOPOINTS) - 1, NOPOINTS + ptlOffset.x, DIVISIONSY * NOPOINTS + 2);
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFill);
    }
        
    rectPaint = CGRectMake(ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS, NOPOINTS) - 1, NOPOINTS + ptlOffset.x, DIVISIONSY * NOPOINTS + 2);
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFill);
    }

    // Draw the board using a brown fill color and black stroke color
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.5f green:0.5f blue:0.0f alpha:1.0f].CGColor);
        
	// Left side
    rectPaint = CGRectMake(ptlOffset.x + NOPOINTS, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS + 1, NOPOINTS), 6 * NOPOINTS + 2, DIVISIONSY * NOPOINTS + 1);
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectPaint);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Middle stripe
    rectPaint.origin.x = ptlOffset.x + 7 * NOPOINTS + 1;
    rectPaint.size.width = NOPOINTS;
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectPaint);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Right side
    rectPaint.origin.x = ptlOffset.x + 8 * NOPOINTS;
    rectPaint.size.width = 6 * NOPOINTS + 2;
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectPaint);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Right stripe
    rectPaint.origin.x = ptlOffset.x + DIVISIONSX * NOPOINTS + 1;
    rectPaint.size.width = NOPOINTS + 1;
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectPaint);
        CGContextDrawPath(context, kCGPathFillStroke);
    } 
        
	// Draw scores player
    rectPaint = CGRectMake(ptlOffset.x + 8 * NOPOINTS, ptlOffset.y + ulConvertY(8 * NOPOINTS, NOPOINTS) + (2 * NOPOINTS - font.pointSize) / 2 - 4, 3 * NOPOINTS, font.pointSize * 2);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        NSString *score = [NSString stringWithFormat:@"%d", self.usScorePlayer];
        [score drawInRect:rectPaint withAttributes:dictionaryWhite];
    }
        
	// Draw scores computer
    rectPaint = CGRectMake(ptlOffset.x + 11 * NOPOINTS, ptlOffset.y + ulConvertY(8 * NOPOINTS, NOPOINTS) + (2 * NOPOINTS - font.pointSize) / 2 - 4, 3 * NOPOINTS, font.pointSize * 2);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        NSString *score = [NSString stringWithFormat:@"%d", self.usScoreComputer];
        [score drawInRect:rectPaint withAttributes:dictionaryBlack];
    }
        
    // Draw board borders
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
        
    // Lower border
    int offset = NOPOINTS / 4;
	pointBorder[0].x = ptlOffset.x + NOPOINTS + 1;
	pointBorder[0].y = ptlOffset.y + ulConvertY(NOPOINTS + 1, NOPOINTS) + 1;
	pointBorder[1].x = ptlOffset.x + NOPOINTS + offset + 1;
	pointBorder[1].y = ptlOffset.y + ulConvertY(NOPOINTS - offset + 1, NOPOINTS);
	pointBorder[2].x = ptlOffset.x + ((DIVISIONSX+1) * NOPOINTS) + offset + 1;
	pointBorder[2].y = ptlOffset.y + ulConvertY(NOPOINTS - offset + 1, NOPOINTS);
	pointBorder[3].x = ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS + 2;
	pointBorder[3].y = ptlOffset.y + ulConvertY(NOPOINTS + 1, NOPOINTS) + 1;
    rectPaint = CGRectMake(pointBorder[0].x, pointBorder[0].y, pointBorder[2].x - pointBorder[0].x, offset);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        CGContextAddLines(context, pointBorder, 4);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
    // Right border
	pointBorder[0].x = ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS + 2;
	pointBorder[0].y = ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS + 2, NOPOINTS) + 2;
	pointBorder[1].x = ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS + offset;
	pointBorder[1].y = ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS - offset + 2, NOPOINTS);
	pointBorder[2].x = ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS + offset;
	pointBorder[2].y = ptlOffset.y + ulConvertY(NOPOINTS - offset, NOPOINTS);
	pointBorder[3].x = ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS + 2;
	pointBorder[3].y = ptlOffset.y + ulConvertY(NOPOINTS, NOPOINTS);
    rectPaint = CGRectMake(pointBorder[0].x, pointBorder[0].y, offset, pointBorder[2].y - pointBorder[0].y);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        CGContextAddLines(context, pointBorder, 4);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
    // Draw shadows
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        
    // Draw lower shadow
    int shadowOffset = 1;
    if (ptlOffset.x < ptlOffset.y) {
       shadowOffset=0;
    }
            
    rectPaint = CGRectMake(ptlOffset.x + NOPOINTS + NOPOINTS / 2, ptlOffset.y + ulConvertY(NOPOINTS - offset + 1, NOPOINTS), DIVISIONSX * NOPOINTS - shadowOffset, offset - 1);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        CGContextAddRect(context, rectPaint);
        CGContextDrawPath(context, kCGPathFill);
    }
		
    // Draw right shadow
    rectPaint = CGRectMake(ptlOffset.x + (DIVISIONSX + 1) * NOPOINTS + offset, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS - NOPOINTS / 2 + 1, NOPOINTS), offset, DIVISIONSY * NOPOINTS - 2);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        CGContextAddRect(context, rectPaint);
        CGContextDrawPath(context, kCGPathFill);
    } 
    
	// Dreiecke werden gezeichnet
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
		
    // Rechts oben
    rectPaint = CGRectMake(ptlOffset.x + 7 * NOPOINTS, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS, NOPOINTS) - 1, NOPOINTS + 1, 5 * NOPOINTS);
    for (int i = 0; i < 6; i++) {
        rectPaint.origin.x += NOPOINTS;
        if (CGRectIntersectsRect(rectPaint, rect)) {
            if ((i % 2) == 0) {
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            }
            else {
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3f green:0.0f blue:0.0f alpha:1.0f].CGColor);
            }
                
            pointBorder[0].x = rectPaint.origin.x;
            pointBorder[0].y = rectPaint.origin.y;
            pointBorder[1].x = rectPaint.origin.x + NOPOINTS / 2;
            pointBorder[1].y = rectPaint.origin.y + rectPaint.size.height;
            pointBorder[2].x = rectPaint.origin.x + rectPaint.size.width;
            pointBorder[2].y = rectPaint.origin.y;
            CGContextAddLines(context, pointBorder, 3);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
        
    // Links oben
    rectPaint = CGRectMake(ptlOffset.x, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS, NOPOINTS) - 1, NOPOINTS + 1, 5 * NOPOINTS);
    for (int i = 0; i < 6; i++)
    {
        rectPaint.origin.x += NOPOINTS;
        if (CGRectIntersectsRect(rectPaint, rect)) {
            if ((i % 2) == 0) {
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            }
            else {
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3f green:0.0f blue:0.0f alpha:1.0f].CGColor);
            }
                
            pointBorder[0].x = rectPaint.origin.x;
            pointBorder[0].y = rectPaint.origin.y;
            pointBorder[1].x = rectPaint.origin.x + NOPOINTS / 2;
            pointBorder[1].y = rectPaint.origin.y + rectPaint.size.height;
            pointBorder[2].x = rectPaint.origin.x + rectPaint.size.width;
            pointBorder[2].y = rectPaint.origin.y;
            CGContextAddLines(context, pointBorder, 3);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
      
    // Links unten
    rectPaint = CGRectMake(ptlOffset.x, ptlOffset.y + ulConvertY(6 * NOPOINTS, NOPOINTS), NOPOINTS + 1, 5 * NOPOINTS);
    for (int i = 0; i < 6; i++) {
        rectPaint.origin.x += NOPOINTS;
        if (CGRectIntersectsRect(rectPaint, rect)) {
            if ((i % 2) == 0) {
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            }
            else {
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3f green:0.0f blue:0.0f alpha:1.0f].CGColor);
            }
                
            pointBorder[0].x = rectPaint.origin.x;
            pointBorder[0].y = rectPaint.origin.y + rectPaint.size.height;
            pointBorder[1].x = rectPaint.origin.x + NOPOINTS / 2;
            pointBorder[1].y = rectPaint.origin.y;
            pointBorder[2].x = rectPaint.origin.x + rectPaint.size.width;
            pointBorder[2].y = rectPaint.origin.y + rectPaint.size.height;
            CGContextAddLines(context, pointBorder, 3);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
        
    // Rechts unten
    rectPaint = CGRectMake(ptlOffset.x + 7 * NOPOINTS, ptlOffset.y + ulConvertY(6 * NOPOINTS, NOPOINTS), NOPOINTS + 1, 5 * NOPOINTS);
    for (int i = 0; i < 6; i++)
    {
        rectPaint.origin.x += NOPOINTS;
        if (CGRectIntersectsRect(rectPaint, rect)) {
            if ((i % 2) == 0) {
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            }
            else {
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3f green:0.0f blue:0.0f alpha:1.0f].CGColor);
            }
                
            pointBorder[0].x = rectPaint.origin.x;
            pointBorder[0].y = rectPaint.origin.y + rectPaint.size.height;
            pointBorder[1].x = rectPaint.origin.x + NOPOINTS / 2;
            pointBorder[1].y = rectPaint.origin.y;
            pointBorder[2].x = rectPaint.origin.x + rectPaint.size.width;
            pointBorder[2].y = rectPaint.origin.y + rectPaint.size.height;
            CGContextAddLines(context, pointBorder, 3);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    int idx;
        
    // Spielsteine zeichnen am board
    // Oben
    rectPaint = CGRectMake(ptlOffset.x + NOPOINTS + 1, ptlOffset.y + ulConvertY((DIVISIONSY + 1) * NOPOINTS, NOPOINTS), NOPOINTS, 5 * NOPOINTS);
    for (int i = 14; i < 28; i++) {
        if (i == 20)
            idx = 27;
        if (i > 20)
            idx = i - 1;
        if (i < 20)
            idx = i;
            
        // Abmessungen des Startstuecks
        ptl.x = rectPaint.origin.x - 3;
        ptl.y = rectPaint.origin.y + NOPOINTS + 4;
            
        if (self.board.usNo[idx] > 0 && CGRectIntersectsRect(rectPaint, rect))
        {
            // Zeichnen der einzelnen Steine
            for (int j = 0; j < self.board.usNo[idx]; j++)
            {
                if (self.board.fWho[idx] == COMPUTER) {
                    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                } else if (self.board.fWho[idx] == PLAYER) {
                    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                }
                CGRect rectStone = CGRectMake((idx == 26) ? (ptl.x + 4) : (ptl.x + 3), ptl.y - NOPOINTS - 4, NOPOINTS - 2, NOPOINTS - 2);
                CGContextAddEllipseInRect(context, rectStone);
                CGContextDrawPath(context, kCGPathFillStroke);
                if (j == 4 || j == 13) {
                    ptl.y = rectPaint.origin.y + NOPOINTS + NOPOINTS / 2 + 4;
                    continue;
                }
                if (j == 8) {
                    ptl.y = rectPaint.origin.y + NOPOINTS + 4;
                    continue;
                }
                ptl.y += NOPOINTS;
            }
        }
        rectPaint.origin.x += NOPOINTS;
    }
        
	// Unten
    rectPaint = CGRectMake(ptlOffset.x + NOPOINTS + 1, ptlOffset.y + ulConvertY(6 * NOPOINTS, NOPOINTS), NOPOINTS, 5 * NOPOINTS);
	for (int i = 13; i >= 0; i--) {
		if (i == 7)
			idx = 0;
		if (i > 7)
			idx = i;
		if (i < 7)
			idx = i + 1;
            
        // Abmessungen des Startstuecks
        ptl.x = rectPaint.origin.x - 3;
        ptl.y = rectPaint.origin.y + rectPaint.size.height + 4;
            
		if (self.board.usNo[idx] > 0 && CGRectIntersectsRect(rectPaint, rect))
		{
            // Zeichnen der einzelnen Steine
			for (int j = 0; j < self.board.usNo[idx]; j++)
			{
                if (self.board.fWho[idx] == COMPUTER) {
                    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                } else if (self.board.fWho[idx] == PLAYER) {
                    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                }
                CGRect rectStone = CGRectMake((idx == 1) ? (ptl.x + 4) : (ptl.x + 3), ptl.y - NOPOINTS - 4, NOPOINTS - 2, NOPOINTS - 2);
                CGContextAddEllipseInRect(context, rectStone);
                CGContextDrawPath(context, kCGPathFillStroke);
				if (j == 4 || j == 13) {
					ptl.y = rectPaint.origin.y + rectPaint.size.height + 4 - NOPOINTS / 2 + 4;
					continue;
				}
				if (j == 8) {
					ptl.y = rectPaint.origin.y + rectPaint.size.height + 4;
					continue;
				}
				ptl.y -= NOPOINTS;
			}
        }
		rectPaint.origin.x += NOPOINTS;
    }
        
        // 1. Wuerfel zeichnen
        ptl.x = (ptlOffset.x + NOPOINTS + (6 * NOPOINTS - (self.hbm1.size.width * 2.5)) / 2);
        ptl.y = (ptlOffset.y + 6 * NOPOINTS + ((2 * NOPOINTS - self.hbm1.size.height) / 2));

        rectPaint = CGRectMake(ptl.x, ptl.y, self.hbm1.size.width, self.hbm1.size.height);
        if (CGRectIntersectsRect(rectPaint, rect)) {
            ptl.x = rectPaint.origin.x;
            ptl.y = rectPaint.origin.y;
            switch (self.usDice1) {
                case 1: [self.hbm1 drawAtPoint:ptl]; break;
                case 2: [self.hbm2 drawAtPoint:ptl]; break;
                case 3: [self.hbm3 drawAtPoint:ptl]; break;
                case 4: [self.hbm4 drawAtPoint:ptl]; break;
                case 5: [self.hbm5 drawAtPoint:ptl]; break;
                case 6: [self.hbm6 drawAtPoint:ptl]; break;
            }
        }
            
        // 2. Wuerfel zeichnen
        rectPaint = CGRectMake(ptl.x + (self.hbm1.size.width * 1.5), ptl.y, self.hbm1.size.width, self.hbm1.size.height);
        if (CGRectIntersectsRect(rectPaint, rect)) {
            ptl.x = rectPaint.origin.x;
            ptl.y = rectPaint.origin.y;
            switch (self.usDice2) {
                case 1: [self.hbm1 drawAtPoint:ptl]; break;
                case 2: [self.hbm2 drawAtPoint:ptl]; break;
                case 3: [self.hbm3 drawAtPoint:ptl]; break;
                case 4: [self.hbm4 drawAtPoint:ptl]; break;
                case 5: [self.hbm5 drawAtPoint:ptl]; break;
                case 6: [self.hbm6 drawAtPoint:ptl]; break;
            }
        }
        
        // Ausgabetext zeichnen
        if (self.fDrawText) {
            // Draw text
            rectPaint = CGRectMake(ptlOffset.x, statusBarFrame.size.height + (ptlOffset.y + NOPOINTS - statusBarFrame.size.height - font.pointSize * 2) / 2, NOPOINTS * (DIVISIONSX + 2), font.pointSize * 2);
            if (CGRectIntersectsRect(rectPaint, rect)) {
                [[UIColor whiteColor] set];
                [self.text drawInRect:rectPaint withAttributes:dictionaryWhite];
            }
        }
}

- (short)getTouchIndex:(NSSet *)touches {
    short sGetIdx[DIVISIONSX + 2][DIVISIONSY + 2] = {
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1},
        {-1,13,13,13,13,13,-1,-1,14,14,14,14,14,-1},
        {-1,12,12,12,12,12,-1,-1,15,15,15,15,15,-1},
        {-1,11,11,11,11,11,-1,-1,16,16,16,16,16,-1},
        {-1,10,10,10,10,10,-1,-1,17,17,17,17,17,-1},
        {-1, 9, 9, 9, 9, 9,-1,-1,18,18,18,18,18,-1},
        {-1, 8, 8, 8, 8, 8,-1,-1,19,19,19,19,19,-1},
        {-1, 0, 0, 0, 0, 0,-1,-1,27,27,27,27,27,-1},
        {-1, 7, 7, 7, 7, 7,-1,-1,20,20,20,20,20,-1},
        {-1, 6, 6, 6, 6, 6,-1,-1,21,21,21,21,21,-1},
        {-1, 5, 5, 5, 5, 5,-1,-1,22,22,22,22,22,-1},
        {-1, 4, 4, 4, 4, 4,-1,-1,23,23,23,23,23,-1},
        {-1, 3, 3, 3, 3, 3,-1,-1,24,24,24,24,24,-1},
        {-1, 2, 2, 2, 2, 2,-1,-1,25,25,25,25,25,-1},
        {-1, 1, 1, 1, 1, 1,-1,-1,26,26,26,26,26,-1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}};
    
    // Get touch position
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
    
    // Calculate index
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);

    short x = (point.x - ptlOffset.x) / NOPOINTS;
    short y = (point.y - ptlOffset.y) / NOPOINTS;
    if (y < 0)
        y=0;
    if (y > DIVISIONSY + 1)
        y = DIVISIONSY + 1;
    if (x < 0)
        x=0;
    if (x > DIVISIONSX + 1)
        x = DIVISIONSX + 1;
    y = (DIVISIONSY + 1) - y;
    return sGetIdx[x][y];
}

- (BOOL)touchDice:(NSSet *)touches {
    // Get touch position
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
    
    // Calculate index
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGPoint ptl;
    ptl.x = (ptlOffset.x + NOPOINTS + (6 * NOPOINTS - (self.hbm1.size.width * 2.5)) / 2);
    ptl.y = (ptlOffset.y + 6 * NOPOINTS + ((2 * NOPOINTS - self.hbm1.size.height) / 2));
    CGRect rectDice1 = CGRectMake(ptl.x, ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    CGRect rectDice2 = CGRectMake(ptl.x + (self.hbm1.size.width * 1.5), ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    return (CGRectContainsPoint(rectDice1, point) || CGRectContainsPoint(rectDice2, point));
}

- (void)invalidateIndex:(short)index {
    // Calculate index
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGRect rGetRectl[NOINDEXES] = {
        {ptlOffset.x + 7 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 14 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 13 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 12 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 11 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 10 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 9 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 8 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 6 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 5 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 4 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 3 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 2 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + NOPOINTS, ptlOffset.y + 8 * NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 2 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 3 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 4 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 5 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 6 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 8 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 9 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 10 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 11 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 12 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 13 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 14 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1},
        {ptlOffset.x + 7 * NOPOINTS, ptlOffset.y + NOPOINTS - 1, NOPOINTS + 1, 5 * NOPOINTS + 1}};
   	if (index >= 0 && index < NOINDEXES) {
        [self setNeedsDisplayInRect:rGetRectl[index]];
    }
}

- (short)leftIndex:(short)index {
    if (index == 20) {
        return 27;
    }
    
    if (index == 27) {
        return 19;
    }
    
    if (index > 14 && index < 27) {
        return index - 1;
    }

    if (index == 0) {
        return 8;
    }
    
    if (index == 7) {
        return 0;
    }
    
    if (index > 0 && index < 13) {
        return index + 1;
    }
    
    return -1;
}

- (short)rightIndex:(short)index {
    if (index == 27) {
        return 20;
    }
    
    if (index == 19) {
        return 27;
    }
    
    if (index > 13 && index < 26) {
        return index + 1;
    }
    
    if (index == 8) {
        return 0;
    }
    
    if (index == 0) {
        return 7;
    }
    
    if (index > 1 && index < 14) {
        return index - 1;
    }
    
    return -1;
}

- (CGRect)rectCalc:(short)index :(short)taken {
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGRect rGetRectl[NOINDEXES] = {
        {ptlOffset.x + 3 + 7 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 4 + 14 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 13 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 12 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 11 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 10 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 9 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 8 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 6 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 5 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 4 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 3 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 2 * NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + NOPOINTS, ptlOffset.y + 8 * NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 2 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 3 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 4 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 5 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 6 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 8 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 9 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 10 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 11 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 12 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 13 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 4 + 14 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2},
        {ptlOffset.x + 3 + 7 * NOPOINTS, ptlOffset.y + NOPOINTS, NOPOINTS - 2, NOPOINTS - 2}};

    CGRect rect = rGetRectl[index];
    if (index < 14) {
        // untere Haelfte
        if ((self.board.usNo[index] + taken) < 6)
            rect.origin.y += (5 - (self.board.usNo[index] + taken)) * NOPOINTS;
        else
        {
            if ((self.board.usNo[index] + taken) > 5 && (self.board.usNo[index] + taken) < 10)
                rect.origin.y += (9 - (self.board.usNo[index] + taken)) * NOPOINTS + NOPOINTS / 2 + 4;
            else
            {
                if ((self.board.usNo[index] + taken) > 9 && (self.board.usNo[index] + taken) < 15)
                    rect.origin.y += (14 - (self.board.usNo[index] + taken)) * NOPOINTS;
                else
                    rect.origin.y += (18 - (self.board.usNo[index] + taken)) * NOPOINTS + NOPOINTS / 2 + 4;
            }
        }
    }
    else
    {
        // obere Haelfte
        if ((self.board.usNo[index] + taken) < 6)
            rect.origin.y += ((self.board.usNo[index] + taken) - 1) * NOPOINTS;
        else
        {
            if ((self.board.usNo[index] + taken) > 5 && (self.board.usNo[index] + taken) < 10)
                rect.origin.y += ((self.board.usNo[index] + taken) - 6) * NOPOINTS + NOPOINTS / 2;
            else
            {
                if ((self.board.usNo[index] + taken) > 9 && (self.board.usNo[index] + taken) < 15)
                    rect.origin.y += ((self.board.usNo[index] + taken) - 10) * NOPOINTS;
                else
                    rect.origin.y += ((self.board.usNo[index] + taken) - 14) * NOPOINTS + NOPOINTS / 2;
            }
        }
    }
    return rect;
}

- (void)invalidateDice {
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGPoint ptl;
    ptl.x = (ptlOffset.x + NOPOINTS + (6 * NOPOINTS - (self.hbm1.size.width * 2.5)) / 2);
    ptl.y = (ptlOffset.y + 6 * NOPOINTS + ((2 * NOPOINTS - self.hbm1.size.height) / 2));
    CGRect rectUpdate = CGRectMake(ptl.x, ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    [self setNeedsDisplayInRect:rectUpdate];
    rectUpdate = CGRectMake(ptl.x + (self.hbm1.size.width * 1.5), ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    [self setNeedsDisplayInRect:rectUpdate];
}

- (void)animateDice {
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGPoint ptl;
    ptl.x = (ptlOffset.x + NOPOINTS + (6 * NOPOINTS - (self.hbm1.size.width * 2.5)) / 2);
    ptl.y = (ptlOffset.y + 6 * NOPOINTS + ((2 * NOPOINTS - self.hbm1.size.height) / 2));
    CGRect rectDice1 = CGRectMake(ptl.x, ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    CGRect rectDice2 = CGRectMake(ptl.x + (self.hbm1.size.width * 1.5), ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    
    // Set up the image views
    self.animatedDice1 = [[UIImageView alloc] initWithFrame:rectDice1];
    self.animatedDice2 = [[UIImageView alloc] initWithFrame:rectDice2];
    
    // Load the images into an array
    NSMutableArray *imageArray1 = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *imageArray2 = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        switch (1 + (abs(random() % 6))) {
            case 1: [imageArray1 addObject:hbm1]; break;
            case 2: [imageArray1 addObject:hbm2]; break;
            case 3: [imageArray1 addObject:hbm3]; break;
            case 4: [imageArray1 addObject:hbm4]; break;
            case 5: [imageArray1 addObject:hbm5]; break;
            case 6: [imageArray1 addObject:hbm6]; break;
        }
        switch (1 + (abs(random() % 6))) {
            case 1: [imageArray2 addObject:hbm1]; break;
            case 2: [imageArray2 addObject:hbm2]; break;
            case 3: [imageArray2 addObject:hbm3]; break;
            case 4: [imageArray2 addObject:hbm4]; break;
            case 5: [imageArray2 addObject:hbm5]; break;
            case 6: [imageArray2 addObject:hbm6]; break;
        }
    }
    
    // Animate and remove the view
    self.animatedDice1.animationImages = imageArray1;
    self.animatedDice1.animationDuration = 1;
    self.animatedDice1.animationRepeatCount = 1;
    self.animatedDice2.animationImages = imageArray2;
    self.animatedDice2.animationDuration = 1;
    self.animatedDice2.animationRepeatCount = 1;
    [self addSubview:self.animatedDice1];
    [self addSubview:self.animatedDice2];
    [self.animatedDice1 startAnimating];
    [self.animatedDice2 startAnimating];
}

- (void)stopAnimateDice {
    [self.animatedDice1 stopAnimating];
    [self.animatedDice2 stopAnimating];
    [self.animatedDice1 removeFromSuperview];
    [self.animatedDice2 removeFromSuperview];
    self.animatedDice1 = nil;
    self.animatedDice2 = nil;
}

- (void)invalidateText {
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font = [UIFont systemFontOfSize:14];
    } else {
        font = [UIFont systemFontOfSize:28];
    }
    CGRect rectUpdate = CGRectMake(ptlOffset.x, statusBarFrame.size.height + (ptlOffset.y + NOPOINTS - statusBarFrame.size.height - font.pointSize * 2) / 2, NOPOINTS * (DIVISIONSX + 2), font.pointSize * 2);
    [self setNeedsDisplayInRect:rectUpdate];
}

- (void)invalidateScore {
    CGRect statusBarFrame = [self statusBarFrameViewRect];
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), (self.bounds.size.height - statusBarFrame.size.height) / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font = [UIFont systemFontOfSize:14];
    } else {
        font = [UIFont systemFontOfSize:28];
    }
    CGRect rectUpdate = CGRectMake(ptlOffset.x + 8 * NOPOINTS, ptlOffset.y + ulConvertY(8 * NOPOINTS, NOPOINTS) + (2 * NOPOINTS - font.pointSize) / 2 - 4, 3 * NOPOINTS, font.pointSize * 2);
    [self setNeedsDisplayInRect:rectUpdate];
    rectUpdate = CGRectMake(ptlOffset.x + 11 * NOPOINTS, ptlOffset.y + ulConvertY(8 * NOPOINTS, NOPOINTS) + (2 * NOPOINTS - font.pointSize) / 2 - 4, 3 * NOPOINTS, font.pointSize * 2);
    [self setNeedsDisplayInRect:rectUpdate];
}

- (PBOARD)getBoardPointer {
    return &board;
}

- (CGRect)statusBarFrameViewRect
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.window convertRect:statusBarFrame fromWindow: nil];
    CGRect statusBarViewRect = [self convertRect:statusBarWindowRect fromView: nil];
    return statusBarViewRect;
}

- (void)draw:(unsigned short) usFromIndex :(unsigned short) usToIndex :(BOOL)usToWho :(BOOL) fUpdateBar :(BOOL) fAnimation{
    [self.animationLock lock];
    
    while (self.isAnimating) {
        [self.animationLock wait];
    }
    self.isAnimating = YES;
    /* Zuerst wird der alte Stein geloescht */
    PBOARD pBoard = [self getBoardPointer];
    if (pBoard->usNo[usFromIndex] > 0) {
        pBoard->usNo[usFromIndex]--;
    }
    
    if (fAnimation) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            [self invalidateIndex:usFromIndex];
            
            
            
            
            StoneView *stoneView = [[StoneView alloc] initWithFrame:[self rectCalc:usFromIndex:1]:self.board.fWho[usFromIndex]];
            [self addSubview:stoneView];
            CGRect toRect = [self rectCalc:usToIndex:1];
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{ stoneView.frame = toRect; }
                             completion:^(BOOL finished) {
                                 [self.animationLock lock];
                                pBoard->fWho[usToIndex] = usToWho;
                                 
                                 if (!fUpdateBar) {
                                pBoard->usNo[usToIndex]++;
                                 }
                                [self invalidateIndex:usToIndex];
                                if (fUpdateBar) {
                                    pBoard->usNo[27]++;
                                    [self invalidateIndex:27];
                                    // Play bump sound
                                    [mainViewController playSound:mainViewController.bumpId];
                                    
                                }
                                [stoneView removeFromSuperview];
                                self.isAnimating = NO;
                                 [self.animationLock signal];
                                 
                             [self.animationLock unlock];
                             }
             ];
            stoneView = nil;
        });
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self invalidateIndex:usFromIndex];
            [self.animationLock unlock];
            pBoard->fWho[usToIndex] = usToWho;
            if (!fUpdateBar) {
            pBoard->usNo[usToIndex]++;
            }
            [self invalidateIndex:usToIndex];

            /* muss ich den Spielerbalken aktualisieren ? */
            if (fUpdateBar) {
                pBoard->usNo[27]++;
                [self invalidateIndex:27];
                // Play bump sound
                [mainViewController playSound:mainViewController.bumpId];

            }
            // Reset animating
            self.isAnimating = NO;
            [self.animationLock signal];
            [self.animationLock unlock];
        });
    }
    
    while (self.isAnimating) {
        [self.animationLock wait];
    }
    
    
    [self.animationLock unlock];
}

@end
