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
#define kAnimationKey       @"animation"
#define kSoundKey			@"sound"
#define kScoreComputerKey	@"scoreComputer"
#define kScorePlayerKey     @"scorePlayer"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *gameButton;
@property (strong, nonatomic) IBOutlet UIButton *undoButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, atomic) SystemSoundID bumpId;
@property (assign, atomic) SystemSoundID diceId;
@property (assign, atomic) SystemSoundID endId;
@property (assign, atomic) SystemSoundID illegalId;
@property (assign, atomic) SystemSoundID lostId;
@property (assign, atomic) SystemSoundID newId;
@property (assign, atomic) SystemSoundID pickupId;
@property (assign, atomic) SystemSoundID placeId;
@property (assign, atomic) SystemSoundID startId;
@property (assign, atomic) SystemSoundID undoId;
@property (assign, atomic) SystemSoundID wonId;
@property (assign, atomic) BOOL m_sound;
@property (assign, atomic) unsigned short usScoreComputer;
@property (assign, atomic) unsigned short usScorePlayer;
@property (assign, atomic) BOOL fAnimation;
@property (assign, atomic) BOOL fGameOver;
@property (assign, atomic) BOOL fStart;
@property (assign, atomic) BOOL fDice;
@property (assign, nonatomic) BOOL fGrabbed;
@property (assign, atomic) BOOL fUndo;
@property (assign, atomic) unsigned short usDice1Old;
@property (assign, atomic) unsigned short usDice2Old;
@property (assign, atomic) BOOL fPlayer;
@property (assign, atomic) BOOL fWait;
@property (assign, atomic) BOARD boardUndo;
@property (assign, atomic) short sMoves;
@property (assign, nonatomic) short sGrabbedIdx;

- (IBAction)showInfo:(id)sender;
- (IBAction)newGame:(id)sender;
- (void)playSound:(SystemSoundID)soundID;

@end

// Declare global variables
short asDice[4];

