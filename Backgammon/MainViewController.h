//
//  MainViewController.h
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import <AudioToolbox/AudioToolbox.h>
#import "FlipsideViewController.h"

#define kVersionKey			@"version"
#define kSoundKey			@"sound"

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

- (IBAction)showInfo:(id)sender;
- (IBAction)newGame:(id)sender;
- (void)playSound:(SystemSoundID)soundID;
- (void)initializeGame;

@end
