//
//  MainViewController.m
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import "MainViewController.h"
#import "MainView.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize bumpId;
@synthesize diceId;
@synthesize endId;
@synthesize illegalId;
@synthesize lostId;
@synthesize newId;
@synthesize pickupId;
@synthesize placeId;
@synthesize startId;
@synthesize undoId;
@synthesize wonId;
@synthesize m_sound;
@synthesize usScoreComputer;
@synthesize usScorePlayer;
@synthesize sFast;
@synthesize fGameOver;
@synthesize fStart;
@synthesize fDice;
@synthesize fGrabbed;
@synthesize fUndo;
@synthesize usDice1Old;
@synthesize usDice2Old;
@synthesize fPlayer;
@synthesize fWait;
@synthesize boardUndo;
@synthesize sMoves;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Initialize the randomizer
    srandom(time(NULL));
    
    // Create system sounds
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bump" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &bumpId);
    path = [[NSBundle mainBundle] pathForResource:@"dice" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &diceId);
    path = [[NSBundle mainBundle] pathForResource:@"end" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &endId);
    path = [[NSBundle mainBundle] pathForResource:@"illegal" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &illegalId);
    path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &lostId);
    path = [[NSBundle mainBundle] pathForResource:@"new" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &newId);
    path = [[NSBundle mainBundle] pathForResource:@"pickup" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &pickupId);
    path = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &placeId);
    path = [[NSBundle mainBundle] pathForResource:@"start" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &startId);
    path = [[NSBundle mainBundle] pathForResource:@"undo" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &undoId);
    path = [[NSBundle mainBundle] pathForResource:@"won" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &wonId);
    
    // Initialize settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.m_sound = [defaults boolForKey:kSoundKey];
    self.usScoreComputer = [defaults integerForKey:kScoreComputerKey];
    self.usScorePlayer = [defaults integerForKey:kScorePlayerKey];
    self.sFast = [defaults integerForKey:kFastKey];
    
    // Initialize variables
    [self initializeGame];
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
	// Save the settings
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.m_sound = [defaults boolForKey:kSoundKey];
    self.usScoreComputer = [defaults integerForKey:kScoreComputerKey];
    self.usScorePlayer = [defaults integerForKey:kScorePlayerKey];
    self.sFast = [defaults integerForKey:kFastKey];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)showInfo:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        if (!self.flipsidePopoverController) {
            FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
            controller.delegate = self;
            
            self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (IBAction)newGame:(id)sender {
	[self initializeGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	// Release any retained subviews of the main view
    
    // Dispose sounds
    AudioServicesDisposeSystemSoundID(bumpId);
    AudioServicesDisposeSystemSoundID(diceId);
    AudioServicesDisposeSystemSoundID(endId);
    AudioServicesDisposeSystemSoundID(illegalId);
    AudioServicesDisposeSystemSoundID(lostId);
    AudioServicesDisposeSystemSoundID(newId);
    AudioServicesDisposeSystemSoundID(pickupId);
    AudioServicesDisposeSystemSoundID(placeId);
    AudioServicesDisposeSystemSoundID(startId);
    AudioServicesDisposeSystemSoundID(undoId);
    AudioServicesDisposeSystemSoundID(wonId);
}

- (void) playSound:(SystemSoundID)soundID {
	if (self.m_sound) {
		AudioServicesPlaySystemSound(soundID);
	}
}

- (void)initializeGame {
    MainView *mainView = (MainView *)self.view;
    
	// Play the new game sound
	[self playSound:newId];
    
	// Initialize the game
    self.fGameOver = NO;
	mainView.usDice1 = 1;
	mainView.usDice2 = 1;
	self.fStart = YES;
	self.fDice = YES;
	self.fGrabbed = NO;
	self.fUndo = NO;
	self.usDice1Old = mainView.usDice1;
	self.usDice2Old = mainView.usDice2;
	self.fPlayer = YES;
	self.fWait = NO;
    
    // Initialize board
    BOARD boardHilf;
    for (int i = 0; i < NOINDEXES; i++) {
        boardHilf.usNo[i] = 0;
    }
    boardHilf.fWho[0] = COMPUTER;
    boardHilf.fWho[27] = PLAYER;
    boardHilf.fWho[2] = COMPUTER;
    boardHilf.usNo[2] = 2;
    boardHilf.fWho[13] = COMPUTER;
    boardHilf.usNo[13] = 5;
    boardHilf.fWho[18] = COMPUTER;
    boardHilf.usNo[18] = 3;
    boardHilf.fWho[20] = COMPUTER;
    boardHilf.usNo[20] = 5;
    boardHilf.fWho[7] = PLAYER;
    boardHilf.usNo[7] = 5;
    boardHilf.fWho[9] = PLAYER;
    boardHilf.usNo[9] = 3;
    boardHilf.fWho[14] = PLAYER;
    boardHilf.usNo[14] = 5;
    boardHilf.fWho[25] = PLAYER;
    boardHilf.usNo[25] = 2;
    mainView.board = boardHilf;
    self.boardUndo = boardHilf;
    
    // Set the text
    mainView.fDrawText = YES;
    mainView.text = [[NSString alloc] initWithFormat: @"Tap the dice to roll them."];
    
	// Draw the view
	[mainView setNeedsDisplay];
}

- (IBAction)undo:(id)sender {
    if(!self.fGameOver && self.fUndo) {
        MainView *mainView = (MainView *)self.view;
        
        // Play the undo game sound
        [self playSound:undoId];
        
        for (int i = 0; i < NOINDEXES; i++) {
            if ((mainView.board.usNo[i] != self.boardUndo.usNo[i]) || (mainView.board.fWho[i] != self.boardUndo.fWho[i])) {
                PBOARD pBoard = [mainView getBoardPointer];
                pBoard->fWho[i] = self.boardUndo.fWho[i];
                pBoard->usNo[i] = self.boardUndo.usNo[i];
                [mainView invalidateIndex:i];
            }
        }
        
        mainView.usDice1 = self.usDice1Old;
        mainView.usDice2 = self.usDice2Old;
        self.fDice = NO;
        self.fUndo = NO;
        self.fPlayer = YES;
        
        // Invalidate dice
        [mainView invalidateDice];
        
        if (mainView.usDice1 == mainView.usDice2)
        {
            self.sMoves = 4;
            for (int i = 0; i < 4; i++)
                asDice[i] = mainView.usDice1;
        }
        else
        {
            self.sMoves = 2;
            asDice[0] = mainView.usDice1;
            asDice[1] = mainView.usDice2;
            asDice[2] = - 1;
            asDice[3] = - 1;
        }
    }
    else {
        // Unable to show undo
        [self playSound:illegalId];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    MainView *mainView = (MainView *)self.view;
    short index = [mainView getTouchIndex:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    MainView *mainView = (MainView *)self.view;
    short index = [mainView getTouchIndex:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    MainView *mainView = (MainView *)self.view;
    short index = [mainView getTouchIndex:touches];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation !=	UIInterfaceOrientationPortraitUpsideDown);
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Dismiss popover if it is displayed
    
    // Change the location of the buttons
}

@end
