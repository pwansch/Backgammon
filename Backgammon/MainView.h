//
//  MainView.h
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import <UIKit/UIKit.h>
#import "Algorithm.h"

@interface MainView : UIView

@property (assign, nonatomic) unsigned short usScorePlayer;
@property (assign, nonatomic) unsigned short usScoreComputer;
@property (assign, nonatomic) unsigned short usDice1;
@property (assign, nonatomic) unsigned short usDice2;
@property (assign, nonatomic) BOARD board;
@property (assign, nonatomic) BOOL fDrawText;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *hbm1;
@property (strong, nonatomic) UIImage *hbm2;
@property (strong, nonatomic) UIImage *hbm3;
@property (strong, nonatomic) UIImage *hbm4;
@property (strong, nonatomic) UIImage *hbm5;
@property (strong, nonatomic) UIImage *hbm6;

- (short)getTouchIndex:(NSSet *)touches;
- (void)invalidateIndex:(short)index;
- (void)invalidateDice;
- (PBOARD)getBoardPointer;

@end
