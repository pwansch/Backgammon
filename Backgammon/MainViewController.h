//
//  MainViewController.h
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import <AudioToolbox/AudioToolbox.h>
#import "FlipsideViewController.h"
#import "Algorithm.h"

#define kVersionKey			@"version"
#define kSoundKey			@"sound"
#define kScoreComputerKey	@"scoreComputer"
#define kScorePlayerKey     @"scorePlayer"
#define kFastKey            @"fast"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (assign, nonatomic) SystemSoundID bumpId;
@property (assign, nonatomic) SystemSoundID diceId;
@property (assign, nonatomic) SystemSoundID endId;
@property (assign, nonatomic) SystemSoundID illegalId;
@property (assign, nonatomic) SystemSoundID lostId;
@property (assign, nonatomic) SystemSoundID newId;
@property (assign, nonatomic) SystemSoundID pickupId;
@property (assign, nonatomic) SystemSoundID placeId;
@property (assign, nonatomic) SystemSoundID startId;
@property (assign, nonatomic) SystemSoundID undoId;
@property (assign, nonatomic) SystemSoundID wonId;
@property (assign, nonatomic) BOOL m_sound;
@property (assign, nonatomic) unsigned short usScoreComputer;
@property (assign, nonatomic) unsigned short usScorePlayer;
@property (assign, nonatomic) short sFast;
@property (assign, nonatomic) BOOL fGameOver;
@property (assign, nonatomic) BOOL fStart;
@property (assign, nonatomic) BOOL fDice;
@property (assign, nonatomic) BOOL fGrabbed;
@property (assign, nonatomic) BOOL fUndo;
@property (assign, nonatomic) unsigned short usDice1Old;
@property (assign, nonatomic) unsigned short usDice2Old;
@property (assign, nonatomic) BOOL fPlayer;
@property (assign, nonatomic) BOOL fWait;
@property (assign, nonatomic) BOARD boardUndo;
@property (assign, nonatomic) short sMoves;

- (IBAction)showInfo:(id)sender;
- (IBAction)newGame:(id)sender;
- (void)playSound:(SystemSoundID)soundID;
- (void)initializeGame;

@end

// Declare global variables
short asDice[4];

