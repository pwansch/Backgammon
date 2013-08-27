//
//  MainView.h
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import <UIKit/UIKit.h>
#import "Algorithm.h"
#import "StoneView.h"
#import "MainViewController.h"

@interface MainView : UIView

@property (assign, atomic) unsigned short usScorePlayer;
@property (assign, atomic) unsigned short usScoreComputer;
@property (assign, atomic) unsigned short usDice1;
@property (assign, atomic) unsigned short usDice2;
@property (assign, atomic) BOARD board;
@property (assign, atomic) BOOL fDrawText;
@property (assign, atomic) BOOL isAnimating;
@property (strong, atomic) NSString *text;
@property (strong, nonatomic) NSCondition* animationLock;
@property (strong, nonatomic) UIImage *hbm1;
@property (strong, nonatomic) UIImage *hbm2;
@property (strong, nonatomic) UIImage *hbm3;
@property (strong, nonatomic) UIImage *hbm4;
@property (strong, nonatomic) UIImage *hbm5;
@property (strong, nonatomic) UIImage *hbm6;
@property (strong, nonatomic) StoneView *grabbedStone;
@property (strong, nonatomic) UIImageView *animatedDice1;
@property (strong, nonatomic) UIImageView *animatedDice2;
@property (strong, nonatomic) MainViewController *mainViewController;

- (short)getTouchIndex:(NSSet *)touches;
- (BOOL)touchDice:(NSSet *)touches;
- (void)invalidateIndex:(short)index;
- (short)leftIndex:(short)index;
- (short)rightIndex:(short)index;
- (CGRect)rectCalc:(short)index :(short)taken;
- (void)invalidateDice;
- (void)animateDice;
- (void)stopAnimateDice;
- (void)invalidateText;
- (void)invalidateScore;
- (PBOARD)getBoardPointer;
- (void)draw:(unsigned short) usFromIndex :(unsigned short) usToIndex :(BOOL)usToWho :(BOOL) fUpdateBar :(BOOL) fAnimation;

@end


