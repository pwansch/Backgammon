//
//  MainView.m
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import "MainView.h"
#import "Algorithm.h"

@interface MainView ()
// Class extensions and utility functions
CGFloat ulConvertY(CGFloat ulFromY, CGFloat NOPOINTS);
@end

@implementation MainView

@synthesize usScorePlayer;
@synthesize usScoreComputer;
@synthesize usDice1;
@synthesize usDice2;
@synthesize board;
@synthesize text;
@synthesize fDrawText;
@synthesize hbm1;
@synthesize hbm2;
@synthesize hbm3;
@synthesize hbm4;
@synthesize hbm5;
@synthesize hbm6;

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder]))
	{
		// Initialize variables
        self.usScorePlayer = 0;
        self.usScoreComputer = 0;
        self.usDice1 = 1;
        self.usDice2 = 1;
        self.fDrawText = NO;
        
        // Load images
        self.hbm1 = [UIImage imageNamed:@"dice1.png"];
        self.hbm2 = [UIImage imageNamed:@"dice2.png"];
        self.hbm3 = [UIImage imageNamed:@"dice3.png"];
        self.hbm4 = [UIImage imageNamed:@"dice4.png"];
        self.hbm5 = [UIImage imageNamed:@"dice5.png"];
        self.hbm6 = [UIImage imageNamed:@"dice6.png"];
		
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

	// Calculate block size, starting point and offset
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), self.bounds.size.height / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    
	// Obtain graphics context and set defaults
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.0);
    
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
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Middle stripe
    rectPaint.origin.x = ptlOffset.x + 7 * NOPOINTS + 1;
    rectPaint.size.width = NOPOINTS;
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Right side
    rectPaint.origin.x = ptlOffset.x + 8 * NOPOINTS;
    rectPaint.size.width = 6 * NOPOINTS + 2;
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Right stripe
    rectPaint.origin.x = ptlOffset.x + DIVISIONSX * NOPOINTS + 1;
    rectPaint.size.width = NOPOINTS + 1;
    rectIntersect = CGRectIntersection(rectPaint, rect);
    if (!CGRectIsNull(rectIntersect)) {
        CGContextAddRect(context, rectIntersect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
        
	// Draw scores player
    UIFont *font = [UIFont systemFontOfSize:20];
    rectPaint = CGRectMake(ptlOffset.x + 8 * NOPOINTS, ptlOffset.y + ulConvertY(8 * NOPOINTS, NOPOINTS) + (2 * NOPOINTS - font.pointSize) / 2, 3 * NOPOINTS, font.pointSize);
        
    if (CGRectIntersectsRect(rectPaint, rect)) {
        [[UIColor whiteColor] set];
        NSString *score = [NSString stringWithFormat:@"%d", self.usScorePlayer];
        [score drawInRect:rectPaint withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    }
        
	// Draw scores computer
    rectPaint = CGRectMake(ptlOffset.x + 11 * NOPOINTS, ptlOffset.y + ulConvertY(8 * NOPOINTS, NOPOINTS) + (2 * NOPOINTS - font.pointSize) / 2, 3 * NOPOINTS, font.pointSize);
    if (CGRectIntersectsRect(rectPaint, rect)) {
        [[UIColor blackColor] set];
        NSString *score = [NSString stringWithFormat:@"%d", self.usScoreComputer];
        [score drawInRect:rectPaint withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
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
        
    // Draw lower shadow TODO: if portrait then dont add -1
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
                switch (self.board.fWho[idx]) {
                    case COMPUTER:
                        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                        break;
                    case PLAYER:
                        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        break;
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
                switch (self.board.fWho[idx]) {
                    case COMPUTER:
                        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                        break;
                    case PLAYER:
                        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        break;
                }
                CGRect rectStone = CGRectMake((idx == 1) ? (ptl.x + 4) : (ptl.x + 3), ptl.y - NOPOINTS - 4, NOPOINTS - 2, NOPOINTS - 2);
                CGContextAddEllipseInRect(context, rectStone);
                CGContextDrawPath(context, kCGPathFillStroke);
				if (j == 4 || j == 13) {
					ptl.y = rectPaint.origin.y - NOPOINTS / 2 + 4;
					continue;
				}
				if (j == 8) {
					ptl.y = rectPaint.origin.y + 4;
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
                case 1: [hbm1 drawAtPoint:ptl]; break;
                case 2: [hbm2 drawAtPoint:ptl]; break;
                case 3: [hbm3 drawAtPoint:ptl]; break;
                case 4: [hbm4 drawAtPoint:ptl]; break;
                case 5: [hbm5 drawAtPoint:ptl]; break;
                case 6: [hbm6 drawAtPoint:ptl]; break;
            }
        }
            
        // 2. Wuerfel zeichnen
        rectPaint = CGRectMake(ptl.x + (self.hbm1.size.width * 1.5), ptl.y, self.hbm1.size.width, self.hbm1.size.height);
        if (CGRectIntersectsRect(rectPaint, rect)) {
            ptl.x = rectPaint.origin.x;
            ptl.y = rectPaint.origin.y;
            switch (self.usDice2) {
                case 1: [hbm1 drawAtPoint:ptl]; break;
                case 2: [hbm2 drawAtPoint:ptl]; break;
                case 3: [hbm3 drawAtPoint:ptl]; break;
                case 4: [hbm4 drawAtPoint:ptl]; break;
                case 5: [hbm5 drawAtPoint:ptl]; break;
                case 6: [hbm6 drawAtPoint:ptl]; break;
            }
        }
        
        // Ausgabetext zeichnen
        if (self.fDrawText) {
            // Draw text
            UIFont *font = [UIFont systemFontOfSize:20];
            rectPaint = CGRectMake(ptlOffset.x, (ptlOffset.y + NOPOINTS - font.pointSize) / 2 - 4, NOPOINTS * (DIVISIONSX + 2), font.pointSize);
            if (CGRectIntersectsRect(rectPaint, rect)) {
                [[UIColor whiteColor] set];
                [self.text drawInRect:rectPaint withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
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
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), self.bounds.size.height / (DIVISIONSY + 2));
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

- (void)invalidateIndex:(short)index {
    // Calculate index
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), self.bounds.size.height / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGRect rGetRectl[NOINDEXES] = {
        {ptlOffset.x + 7 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 14 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 13 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 12 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 11 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 10 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 9 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 8 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 6 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 5 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 4 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 3 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 2 * NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + NOPOINTS + 1, ptlOffset.y + 8 * NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 2 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 3 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 4 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 5 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 6 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 8 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 9 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 10 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 11 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 12 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 13 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 14 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS},
        {ptlOffset.x + 7 * NOPOINTS + 1, ptlOffset.y + NOPOINTS, NOPOINTS + 1, 5 * NOPOINTS}};
   	if (index >= 0 && index < NOINDEXES) {
        [self setNeedsDisplayInRect:rGetRectl[index]];
    }
}

- (void)invalidateDice {
    CGFloat NOPOINTS = MIN(self.bounds.size.width / (DIVISIONSX + 2), self.bounds.size.height / (DIVISIONSY + 2));
    CGPoint ptlOffset = CGPointMake((self.bounds.size.width - ((DIVISIONSX + 2) * NOPOINTS)) / 2, (self.bounds.size.height - ((DIVISIONSY + 2) * NOPOINTS)) / 2);
    CGPoint ptl;
    ptl.x = (ptlOffset.x + NOPOINTS + (6 * NOPOINTS - (self.hbm1.size.width * 2.5)) / 2);
    ptl.y = (ptlOffset.y + 6 * NOPOINTS + ((2 * NOPOINTS - self.hbm1.size.height) / 2));
    CGRect rectUpdate = CGRectMake(ptl.x, ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    [self setNeedsDisplayInRect:rectUpdate];
    rectUpdate = CGRectMake(ptl.x + (self.hbm1.size.width * 1.5), ptl.y, self.hbm1.size.width, self.hbm1.size.height);
    [self setNeedsDisplayInRect:rectUpdate];
}

- (PBOARD)getBoardPointer {
    return &board;
}

@end
