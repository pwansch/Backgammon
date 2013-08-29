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
    - (BOOL)fQueryDice:(unsigned short)sDist;
    - (void)SortasDice;
    - (void)RollDice;
    - (void)initializeGame;
    - (void)CalcMoves;
@end

@implementation MainViewController

@synthesize gameButton;
@synthesize undoButton;
@synthesize infoButton;
@synthesize flipsidePopoverController;
@synthesize activityIndicator;
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
@synthesize fAnimation;
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
@synthesize sGrabbedIdx;

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
    
    MainView *mainView = (MainView *)self.view;
    mainView.mainViewController = self;
    
    // Initialize settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.fAnimation = [defaults boolForKey:kAnimationKey];
    self.m_sound = [defaults boolForKey:kSoundKey];
    mainView.usScoreComputer = [defaults integerForKey:kScoreComputerKey];
    mainView.usScorePlayer = [defaults integerForKey:kScorePlayerKey];
    
    // Initialize variables
    [self initializeGame];
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
	// Save the settings
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.fAnimation = [defaults boolForKey:kAnimationKey];
    self.m_sound = [defaults boolForKey:kSoundKey];
    MainView *mainView = (MainView *)self.view;
    mainView.usScoreComputer = [defaults integerForKey:kScoreComputerKey];
    mainView.usScorePlayer = [defaults integerForKey:kScorePlayerKey];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)flipsideViewControllerResetScores
{
    MainView *mainView = (MainView *)self.view;
    mainView.usScoreComputer = 0;
    mainView.usScorePlayer = 0;
    [mainView invalidateScore];
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
    if(!self.fGameOver) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to start a new game?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    } else {
        [self initializeGame];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        [self initializeGame];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	// Release any retained subviews of the main view
	self.gameButton = nil;
	self.undoButton = nil;
    self.infoButton = nil;
    self.flipsidePopoverController = nil;
    self.activityIndicator = nil;
    MainView *mainView = (MainView *)self.view;
    mainView.grabbedStone = nil;
    
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
    mainView.grabbedStone.hidden = YES;
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
    
    // Set the text and stop the spinner
    mainView.fDrawText = YES;
    mainView.text = [[NSString alloc] initWithFormat: @"Tap the dice to roll."];
    [self.activityIndicator stopAnimating];
    
	// Draw the view
	[mainView setNeedsDisplay];
}

- (IBAction)undo:(id)sender {
    if(!self.fGameOver && self.fUndo) {
        MainView *mainView = (MainView *)self.view;
        [mainView.animationLock lock];
        while (mainView.isAnimating) {
            [mainView.animationLock wait];
        }
        
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

        // Do not draw text
        mainView.fDrawText = NO;
        [mainView invalidateText];
        // Stop spinner
        [self.activityIndicator stopAnimating];
        
        [mainView.animationLock unlock];
    }
    else {
        // Unable to show undo
        [self playSound:illegalId];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.fGameOver) {
        MainView *mainView = (MainView *)self.view;
        short index = [mainView getTouchIndex:touches];
        short leftIndex = [mainView leftIndex:index];
        short rightIndex = [mainView rightIndex:index];
        
        // Rollling the dice?
        if (self.fDice && [mainView touchDice:touches]) {
            [self RollDice];
        } else {
		    // Darf der Stein denn weggenommen werden?
		    if (self.fPlayer && !self.fDice && !self.fGrabbed) {
                if ((index != -1) && (mainView.board.fWho[index] == PLAYER) && (mainView.board.usNo[index] > 0)) {
                    index = index;
                } else if ((leftIndex != -1) && (mainView.board.fWho[leftIndex] == PLAYER) && (mainView.board.usNo[leftIndex] > 0)) {
                    index = leftIndex;
                } else if ((rightIndex != -1) && (mainView.board.fWho[rightIndex] == PLAYER) && (mainView.board.usNo[rightIndex] > 0)) {
                    index = rightIndex;
                } else {
                    index = -1;
                }
                
                if (index != -1) {
                    [mainView.animationLock lock];
                    while (mainView.isAnimating) {
                        [mainView.animationLock wait];
                    }
                    [self playSound:pickupId];
                    // Take piece away
                    self.fGrabbed = YES;
                    self.sGrabbedIdx = index;
                    mainView.grabbedStone.frame = [mainView rectCalc:sGrabbedIdx:0];
                    mainView.grabbedStone.hidden = NO;
                    PBOARD pBoard = [mainView getBoardPointer];
                    pBoard->usNo[index]--;
                    [mainView invalidateIndex:index];
                    [mainView.animationLock unlock];
                }
                else {
                    [self playSound:illegalId];
                }
            }
		    else {
                [self playSound:illegalId];
            }
        }
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.fGameOver) {
        // Ignore
        
    }
	else
	{
		if(self.fWait) {
            // Waiting for a move to finish
        }
		else
		{
			if (self.fGrabbed) {
                // A stone was picked up
                MainView *mainView = (MainView *)self.view;
                UITouch *touch = [touches anyObject];
                CGPoint point = [touch locationInView:mainView];
                CGRect frame = mainView.grabbedStone.frame;
                frame.origin.x = point.x - (frame.size.width / 2);
                frame.origin.y = point.y - (frame.size.height / 2);
                mainView.grabbedStone.frame = frame;
            }
			else
			{
				if (self.fDice) {
                    // Dice are being rolled
                    
                }
				else {
                    // Ignore
                }
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    MainView *mainView = (MainView *)self.view;
	
    if (self.fGrabbed && !self.fGameOver && self.fPlayer && !self.fDice)
	{
        [mainView.animationLock lock];
        while (mainView.isAnimating) {
            [mainView.animationLock wait];
        }
        
		// Stone is being dragged
        short index = [mainView getTouchIndex:touches];
        short leftIndex = [mainView leftIndex:index];
        short rightIndex = [mainView rightIndex:index];
        PBOARD pBoard = [mainView getBoardPointer];
        self.fGrabbed = NO;
        mainView.grabbedStone.hidden = YES;
		BOOL fBalken;
		BOOL fWarn;
        BOOL fValid;
        BOOL fValidPlayer;
        
    left_or_right:
		fBalken = NO;
		fWarn = NO;
        fValid = NO;
        fValidPlayer = NO;
        
        if (index != -1) {
			// Platz ist unbesetzt
			if (mainView.board.usNo[index] == 0 && index != 0) {
				pBoard->fWho[index] = PLAYER;
            }
        }
        
		if (sGrabbedIdx == 27)
			sGrabbedIdx = 26;
        
		if (mainView.board.usNo[27] > 0 && sGrabbedIdx != 26) {
			fValid = NO;
        }
		else {
			if (mainView.board.fWho[index] == COMPUTER && mainView.board.usNo[index] == 1 && [self fQueryDice:(sGrabbedIdx - index)]) {
				// Stein wird geschlagen
				fValid = YES;
				pBoard->usNo[index] = 0;
				pBoard->fWho[index] = PLAYER;
				// Stein vom Computer wird auf Balken gelegt
				pBoard->usNo[0]++;
                [mainView.animationLock unlock];
				fBalken = YES;
				[self playSound:bumpId];
			}
			else
			{
				// Is the move valid and has the player moved the pointer at all
				// is the move valid and has the player moved the pointer at all
				fValid = (index != 0 && index < sGrabbedIdx && index != -1) &&
                ((index == 1 && fIsFinish(PLAYER, mainView.board) && [self fQueryDice:(sGrabbedIdx - index)]) ||
                 (index != 1 && mainView.board.fWho[index] == PLAYER && [self fQueryDice:(sGrabbedIdx - index)]));
			}
		}
        
        // Ueberpruefen, ob Steine rausgeschafft werden koennen
        BOARD hilfBoard;
		for (int k = 0; k < NOINDEXES; k++) {
			hilfBoard.fWho[k] = mainView.board.fWho[k];
			hilfBoard.usNo[k] = mainView.board.usNo[k];
        }
		hilfBoard.usNo[sGrabbedIdx]++;
        // In Hilfboard steht jetzt der urspruengliche Zustand vor dem Aufheben des
        // letzten Steins, ich muss jetzt lediglich feststellen ob das ok ist, dass
        // der Stein so ins Ziel gebracht wird.
		if (!fValid && index == 1 && fIsFinish(PLAYER, mainView.board) && !fIsPlayerMovePossibleHilf(hilfBoard, asDice))
		{
			[self SortasDice];
			// der groesste Wuerfel steht jetzt in asDice[3]
			// der Zug muss ja sowieso mit dem groessten Wuerfel zuerst gemacht werden
			// also mit asDice[3]
			for (int k = sGrabbedIdx + 1; k <= asDice[3]; k++)
			{
				// befindet sich dort ein Player-Stein dann gilts nicht
				if (mainView.board.fWho[k] == PLAYER && mainView.board.usNo[k] > 0)
					goto invalid;
			}
			asDice[3] = -1;
			fValid = YES;
		}
        
    invalid:if (sGrabbedIdx == 26)
        sGrabbedIdx = 27;
        
		if (fValid)
		{
			// Zug war gueltig
			[self playSound:placeId];
			pBoard->usNo[index]++;
			self.sMoves--;
			// ueberpruefen ob der Zug den Sieg bedeutet
			if (mainView.board.usNo[1] == 15)
				self.fGameOver = YES;
            
			if (!self.fGameOver)
				if (self.sMoves == 0 || !fIsPlayerMovePossible(mainView.board, asDice))
				{
					// no remaining moves - it's the computers turn
					fValidPlayer = NO;
					if (self.sMoves > 0)
					{
						// kann ich vielleicht noch einen Zug machen
						// ueberpruefen, ob Steine rausgeschafft werden koennen
						if (fIsFinish(PLAYER, mainView.board))
						{
							[self SortasDice];
							// der groesste Wuerfel steht jetzt in asDice[3]
							for (int k = asDice[3] + 1; k > 1; k--)
								if (mainView.board.usNo[k] > 0 && mainView.board.fWho[k] == PLAYER)
								{
									fValidPlayer = YES;
									break;
								}
						}
					}
					if (!fValidPlayer)
						self.fPlayer = NO;
				}
		}
		else
		{
            if (leftIndex != index) {
                index = leftIndex;
                goto left_or_right;
            } else if (rightIndex != index) {
                index = rightIndex;
                leftIndex = index;
                goto left_or_right;
            }
            
			fWarn = YES;
            pBoard->usNo[sGrabbedIdx]++;
            [mainView.animationLock unlock];
			index = sGrabbedIdx;
		}
        
        // Invalidate index
        [mainView invalidateIndex:index];
        
		if (fBalken) {
            [mainView invalidateIndex:0];
        }
        
		// Set back to system arrow cursor
        mainView.fDrawText = NO;
        [mainView invalidateText];
        // Stop spinner
        [self.activityIndicator stopAnimating];
        
        
		if (fWarn)
			[self playSound:illegalId];
        
		if (self.fGameOver)
		{
			[self playSound:wonId];
			short sWhatSum = sWhat(mainView.board, PLAYER);
			mainView.usScorePlayer += sWhatSum;
            mainView.fDrawText = YES;
			switch (sWhatSum)
			{
				case 1: mainView.text = [[NSString alloc] initWithFormat: @"You win."]; break;
				case 2: mainView.text = [[NSString alloc] initWithFormat: @"You win (Gammon)."]; break;
				case 3: mainView.text = [[NSString alloc] initWithFormat: @"You win (Backgammon)."]; break;
			}
            
			// invalidate display
            [mainView invalidateScore];
            [mainView invalidateText];
            [mainView.animationLock unlock];
			return;
		}
        [mainView.animationLock unlock];
        
		if (!self.fPlayer)
		{
			self.fDice = YES;
			self.fUndo = NO;
			[self RollDice];
        }
	}
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
    if (self.flipsidePopoverController != nil) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
    
    // Change the location of the buttons
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        gameButton.frame = CGRectMake(20, self.view.bounds.size.height - 79, 60, 30);
        undoButton.frame = CGRectMake(20, self.view.bounds.size.height - 44, 60, 30);
    } else {
        gameButton.frame = CGRectMake(20, self.view.bounds.size.height - 44, 60, 30);
        undoButton.frame = CGRectMake(88, self.view.bounds.size.height - 44, 60, 30);
    }
}

- (BOOL)fQueryDice:(unsigned short)sDist {
    for (int i = 0; i < 4; i++) {
        if (asDice[i] == sDist) {
            asDice[i] = - 1;
            return YES;
        }
    }
    return NO;
}

- (void)SortasDice {
    for (int i = 0; i < 4; i++)
        for (int j = i + 1; j < 4; j++)
            if (asDice[j] < asDice[i])
            {
                // vertauschen der beiden
                short sSwap = asDice[i];
                asDice[i] = asDice[j];
                asDice[j] = sSwap;
            }
}

- (void)RollDice {
    MainView *mainView = (MainView *)self.view;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
	if(!self.fGameOver)
	{
        BOOL fFirst;
        unsigned short usDice1Old_, usDice2Old_;
        
		// roll the dices
		if (self.fDice)
		{
			// Display wait cursor
			self.fWait = YES;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.activityIndicator startAnimating];
                mainView.fDrawText = NO;
                [mainView invalidateText];
            });
            // Start spinner
            
            [self playSound:diceId];
			// Requester tosses the dice
			BOOL fRepeat = NO;
            comp: if (self.fPlayer)
            {
                BOARD hilfBoard;
                for (int i = 0; i < NOINDEXES; i++) {
                    hilfBoard.fWho[i] = mainView.board.fWho[i];
                    hilfBoard.usNo[i] = mainView.board.usNo[i];
                    self.boardUndo = hilfBoard;
                }
            }
            
            if(self.fAnimation) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                [mainView animateDice];
                });
                [NSThread sleepForTimeInterval:1.1];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [mainView stopAnimateDice];
                });
            }

            mainView.usDice1 = 1 + (abs(random() % 6));
            mainView.usDice2 = 1 + (abs(random() % 6));
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [mainView invalidateDice];
            });
            
			if (self.fPlayer)
			{
				self.usDice1Old = mainView.usDice1;
				self.usDice2Old = mainView.usDice2;
			}
            
			if (self.fStart)
			{
				fFirst = YES;
				self.fStart = NO;
				// Augenzahl des Spielers
				usDice1Old_ = mainView.usDice1;
				usDice2Old_ = mainView.usDice2;

				// eine kurze Zeit warten
				[NSThread sleepForTimeInterval:0.750];
                [self playSound:diceId];
                
				// computer tosses the dice
                if(self.fAnimation) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                    [mainView animateDice];
                    });
                    [NSThread sleepForTimeInterval:1.1];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mainView stopAnimateDice];
                    });
                }

                mainView.usDice1 = 1 + (abs(random() % 6));
                mainView.usDice2 = 1 + (abs(random() % 6));
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [mainView invalidateDice];
                });
                
				// eine kurze Zeit warten
				[NSThread sleepForTimeInterval:.750];
				if ((mainView.usDice1 + mainView.usDice2) == (usDice1Old_ + usDice2Old_))
				{
					// beide haben die selbe Augenzahl
					self.fStart = YES;
					self.fWait = NO;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        mainView.fDrawText = YES;
                        mainView.text = [[NSString alloc] initWithFormat: @"Tap the dice to roll."];
                        [mainView invalidateText];
                        // Stop spinner
                        [self.activityIndicator stopAnimating];
                    });
					return;
				}
                
				if ((mainView.usDice1 + mainView.usDice2) > (usDice1Old_ + usDice2Old_))
					// Computer hat mehr gewuerfelt und beginnt daher
					self.fPlayer = NO;
				else
				{
					// Spieler hat mehr gewuerfelt und beginnt
					mainView.usDice1 = usDice1Old_;
					mainView.usDice2 = usDice2Old_;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mainView invalidateDice];
                    });
					self.fDice = NO;
					self.fUndo = NO;
					self.fPlayer = YES;
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
					fFirst = NO;
					self.fWait = NO;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        mainView.fDrawText = NO;
                        [mainView invalidateText];
                        // Stop spinner
                        [self.activityIndicator stopAnimating];
                    });
                    
					return;
				}
			}
            
			self.fDice = NO;
			self.fUndo = NO;
            
			if (!self.fPlayer)
			{
				// hier kommt der Zug des Computers hin
				// eventuell wird hier fgameOver yes gesetzt, dann geht gar nichts mehr
				// er zieht halt hier solange er kann
                [self playSound:pickupId];
                [self CalcMoves];
				[self playSound:placeId];
                
				if (mainView.usDice1 == mainView.usDice2)
				{
					[self playSound:pickupId];
					[self CalcMoves];
					[self playSound:placeId];
				}
				if (mainView.board.usNo[26] == 15)
				{
					[self playSound:lostId];
					self.fGameOver = YES;
					short sWhatSum = sWhat(mainView.board, COMPUTER);
					mainView.usScoreComputer += sWhatSum;
                    self.fWait = NO;
                    
                    // invalidate display
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        mainView.fDrawText = YES;
                        switch (sWhatSum)
                        {
                            case 1: mainView.text = [[NSString alloc] initWithFormat: @"Computer wins."]; break;
                            case 2: mainView.text = [[NSString alloc] initWithFormat: @"Computer wins (Gammon)."]; break;
                            case 3: mainView.text = [[NSString alloc] initWithFormat: @"Computer wins (Backgammon)."]; break;
                        }
                        [mainView invalidateScore];
                        [mainView invalidateText];
                        [self.activityIndicator stopAnimating];
                    });
                    
					return;
				}
                
				if (!self.fGameOver)
				{
                    while (mainView.isAnimating) {
                        [NSThread sleepForTimeInterval:.01];
                    }
					self.fPlayer = YES;
					self.fDice = YES;
					if (!fFirst)
					{
						if (!fRepeat)
							self.fUndo = YES;
					}
					else
						fFirst = NO;
					self.fWait = NO;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        mainView.fDrawText = YES;
                        mainView.text = [[NSString alloc] initWithFormat: @"Tap the dice to roll."];
                        [mainView invalidateText];
                        // Stop spinner
                        [self.activityIndicator stopAnimating];
                    });
				}
			}
			else
			{
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
                
				// kann der Spieler ueberhaupt einen Zug machen?
				if (!fIsPlayerMovePossible(mainView.board, asDice))
				{
					// der Spieler kann ueberhaupt keinen Zug mehr machen
					// und es kommt der Computer dran
					// ueberpruefen, ob Steine rausgeschafft werden koennen
					BOOL fValidPlayer = NO;
					if (fIsFinish(PLAYER, mainView.board))
					{
						[self SortasDice];
						// der groesste Wuerfel steht jetzt in asDice[3]
						for (int k = asDice[3] + 1; k > 1; k--)
							if (mainView.board.usNo[k] > 0 && mainView.board.fWho[k] == PLAYER) {
								fValidPlayer = YES;
								break;
							}
					}
                    
					if (!fValidPlayer)
					{
						self.fPlayer = NO;
						fRepeat = YES;
						goto comp;
					}
				}
				self.fWait = NO;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    mainView.fDrawText = NO;
                    [mainView invalidateText];
                    // Stop spinner
                    [self.activityIndicator stopAnimating];
                });
			}
		}
		else
			[self playSound:illegalId];
	}
	return;
    });
}

- (void)CalcMoves {
    MainView *mainView = (MainView *)self.view;
    BOOL fSwapped = NO;
    BOOL fThrow;
    short sMove[8];
    short i, j, k, l, sTarget, sOnes;
    unsigned short usDice, _usDice1, _usDice2;
    BOARD hilfBoard, hilfBoard2;
    
    usDice = 0;
    if (mainView.usDice1 > mainView.usDice2)
    {
        _usDice1 = mainView.usDice1;
        _usDice2 = mainView.usDice2;
    }
    else
    {
        _usDice1 = mainView.usDice2;
        _usDice2 = mainView.usDice1;
    }
    
    sMove[0] = 43;
    sMove[5] = 43;
    
    /* befindet sich mehr als ein Stein am Balken */
    if (mainView.board.usNo[0] > 1)
    {
        /* kann ich einen seiner Steine rausschlagen? */
        if (mainView.board.usNo[_usDice1 + 1] == 1 && mainView.board.fWho[_usDice1 + 1] == PLAYER)
        {
            /* Spielerstein wird rausgeschlagen */
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :YES :self.fAnimation];
            goto nextDice;
        }
        
        /* eventuell muss ich einen meiner Steine sichern */
        if (mainView.board.fWho[_usDice1 + 1] == COMPUTER && mainView.board.usNo[_usDice1 + 1] == 1)
        {
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :NO :self.fAnimation];
            goto nextDice;
        }
        
        if (mainView.board.fWho[_usDice1 + 1] == COMPUTER)
        {
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :NO :self.fAnimation];
            goto nextDice;
        }
        
        if (mainView.board.usNo[_usDice1 + 1] == 0)
        {
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :NO :self.fAnimation];
            goto nextDice;
        }
        
    nextDice: /* kann ich einen seiner Steine rausschlagen? */
        if (mainView.board.usNo[_usDice2 + 1] == 1 && mainView.board.fWho[_usDice2 + 1] == PLAYER)
        {
            /* Spielerstein wird rausgeschlagen */
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :YES :self.fAnimation];
            return;
        }
        
        /* eventuell Stein sichern */
        if (mainView.board.fWho[_usDice2 + 1] == COMPUTER && mainView.board.usNo[_usDice2 + 1] == 1)
        {
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :NO :self.fAnimation];
            return;
        }
        
        if (mainView.board.fWho[_usDice2 + 1] == COMPUTER)
        {
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :NO :self.fAnimation];
            return;
        }
        
        if (mainView.board.usNo[_usDice2 + 1] == 0)
        {
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :NO :self.fAnimation];
            return;
        }
        
        return;
    }
    
    /* befindet sich ein Stein am Balken ? */
    if (mainView.board.usNo[0] == 1)
    {
        /* es befindet sich ein Stein am Balken */
        if (mainView.board.usNo[_usDice1 + 1] == 1 && mainView.board.fWho[_usDice1 + 1] == PLAYER)
        {
            /* Spielerstein wird rausgeschlagen */
            usDice = _usDice2;
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :YES :self.fAnimation];
            goto calc;
        }
        
        if (mainView.board.usNo[_usDice2 + 1] == 1 && mainView.board.fWho[_usDice2 + 1] == PLAYER)
        {
            /* Spielerstein wird rausgeschlagen */
            usDice = _usDice1;
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :YES :self.fAnimation];
            goto calc;
        }
        
        /* eventuell muss ich einen meiner Steine sichern */
        if (mainView.board.fWho[_usDice1 + 1] == COMPUTER && mainView.board.usNo[_usDice1 + 1] == 1)
        {
            usDice = _usDice2;
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :NO :self.fAnimation];
            goto calc;
        }
        
        if (mainView.board.fWho[_usDice2 + 1] == COMPUTER && mainView.board.usNo[_usDice2 + 1] == 1)
        {
            usDice = _usDice1;
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :NO :self.fAnimation];
            goto calc;
        }
        
        if (mainView.board.fWho[_usDice1 + 1] == COMPUTER)
        {
            usDice = _usDice2;
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :NO :self.fAnimation];
            goto calc;
        }
        
        if (mainView.board.fWho[_usDice2 + 1] == COMPUTER)
        {
            usDice = _usDice1;
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :NO :self.fAnimation];
            goto calc;
        }
        
        if (mainView.board.usNo[_usDice1 + 1] == 0)
        {
            usDice = _usDice2;
            [mainView draw:0 :_usDice1 + 1 :COMPUTER :NO :self.fAnimation];
            goto calc;
        }
        
        if (mainView.board.usNo[_usDice2 + 1] == 0)
        {
            usDice = _usDice1;
            [mainView draw:0 :_usDice2 + 1 :COMPUTER :NO :self.fAnimation];
            goto calc;
        }
        
        /* der Stein vom Balken kann nicht ins Spiel gebracht werden */
        if (usDice == 0)
            return;
        
    calc: for (i = 25; i > 1; i--)
    {
        /* hilfBoard = board */
        for (k = 0; k < NOINDEXES; k++) {
            hilfBoard.fWho[k] = mainView.board.fWho[k];
            hilfBoard.usNo[k] = mainView.board.usNo[k];
        }
        /* kann von der Position ueberhaupt ein Zug gemacht werden ? */
        if (hilfBoard.usNo[i] > 0 && hilfBoard.fWho[i] == COMPUTER)
        {
            /* zumindest ist ein Computer-Stein auf der Position */
            sTarget = i + usDice;
            if (sTarget > 26 || (sTarget == 26 && !fIsFinish(COMPUTER, hilfBoard)) ||
                (hilfBoard.usNo[sTarget] > 1 && hilfBoard.fWho[sTarget] == PLAYER))
                continue;
            /* der Zug ist prinzipiell gÅltig */
            /* set up hilfBoard */
            hilfBoard.usNo[i]--;
            
            /* ist am Target ein Player-Stein ? */
            if (hilfBoard.usNo[sTarget] == 1 && hilfBoard.fWho[sTarget] == PLAYER)
            {
                /* Player-Stein wird rausgeschmissen */
                hilfBoard.fWho[sTarget] = COMPUTER;
                hilfBoard.usNo[27]++;
                fThrow = YES;
            }
            else
            {
                hilfBoard.usNo[sTarget]++;
                hilfBoard.fWho[sTarget] = COMPUTER;
                fThrow = NO;
            }
            
            /* Zug von Wuerfel 1 ist erfolgreich vollzogen */
            /* Eintragen des Zuges */
            if (fThrow && fCanComputerThrowOne(hilfBoard))
                sOnes = -1;
            else
                sOnes = sGetComputerOnes(hilfBoard);
            
            if (sMove[5] >= sOnes)
            {
                sMove[5] = sOnes;
                sMove[6] = i;
                sMove[7] = i + usDice;
            }
        }
    }
        
        /* ausfuehren des Zugs */
        if (sMove[5] != 43)
        {
            if (mainView.board.fWho[sMove[7]] == PLAYER && mainView.board.usNo[sMove[7]] == 1)
            {
                /* Player-Stein wird rausgeschmissen */
                short sFrom = sMove[6];
                short sTo = sMove[7];
                [mainView draw:sFrom :sTo :COMPUTER :YES :self.fAnimation];
            }
            else
            {
                short sFrom = sMove[6];
                short sTo = sMove[7];
                [mainView draw:sFrom :sTo :COMPUTER :NO :self.fAnimation];
            }
        }
        return;
    }
    
    /* es befinden sich keine Steine am Balken */
start: for (i = 25; i > 1; i--)
{
    /* hilfBoard = board */
    for (k = 0; k < NOINDEXES; k++) {
        hilfBoard.fWho[k] = mainView.board.fWho[k];
        hilfBoard.usNo[k] = mainView.board.usNo[k];
    }
    /* kann von der Position ueberhaupt ein Zug gemacht werden ? */
    if (hilfBoard.usNo[i] > 0 && hilfBoard.fWho[i] == COMPUTER)
    {
        /* zumindest ist ein Computer-Stein auf der Position */
        sTarget = i + _usDice1;
        if (sTarget > 26 || (sTarget == 26 && !fIsFinish(COMPUTER, hilfBoard)) ||
            (hilfBoard.usNo[sTarget] > 1 && hilfBoard.fWho[sTarget] == PLAYER))
            continue;
        /* der Zug ist prinzipiell gÅltig */
        /* set up hilfBoard */
        hilfBoard.usNo[i]--;
        /* ist am Target ein Player-Stein ? */
        if (hilfBoard.usNo[sTarget] == 1 && hilfBoard.fWho[sTarget] == PLAYER)
        {
            /* Player-Stein wird rausgeschmissen */
            hilfBoard.fWho[sTarget] = COMPUTER;
            hilfBoard.usNo[27]++;
            fThrow = YES;
        }
        else
        {
            hilfBoard.usNo[sTarget]++;
            hilfBoard.fWho[sTarget] = COMPUTER;
            fThrow = NO;
        }
        /* Zug von Wuerfel 1 ist vollzogen */
        
        /* Eintragen des Zuges */
        if (fThrow && fCanComputerThrowOne(hilfBoard))
            sOnes = -4;
        else
        {
            if (sTarget == 26)
                sOnes = -3;
            else
                if (sTarget > 19 && sGetComputerOnes(hilfBoard) == 0 && i < 20 && fIsComputerAlmostFinish(hilfBoard))
                {
                    if (hilfBoard.usNo[sTarget] > 3)
                        sOnes = -1;
                    else
                        sOnes = -2;
                }
                else
                    sOnes = sGetComputerOnes(hilfBoard);
        }
        
        if (sMove[5] >= sOnes)
        {
            sMove[5] = sOnes;
            sMove[6] = i;
            sMove[7] = i + _usDice1;
        }
        
        for (j = 25; j > 1; j--)
        {
            /* hilfBoard2 = board */
            for (k = 0; k < NOINDEXES; k++) {
                hilfBoard2.fWho[k] = hilfBoard.fWho[k];
                hilfBoard2.usNo[k] = hilfBoard.usNo[k];
            }
            /* kann von der Position ueberhaupt ein Zug gemacht werden ? */
            if (hilfBoard2.usNo[j] > 0 && hilfBoard2.fWho[j] == COMPUTER)
            {
                /* zumindest ist ein Computer-Stein auf der Position */
                sTarget = j + _usDice2;
                if (sTarget > 26 || (sTarget == 26 && !fIsFinish(COMPUTER, hilfBoard2)) ||
                    (hilfBoard2.usNo[sTarget] > 1 && hilfBoard2.fWho[sTarget] == PLAYER))
                    continue;
                /* der Zug ist prinzipiell gueltig */
                /* set up hilfBoard2 */
                hilfBoard2.usNo[j]--;
                /* ist am Target ein Player-Stein ? */
                if (hilfBoard2.usNo[sTarget] == 1 && hilfBoard2.fWho[sTarget] == PLAYER)
                {
                    /* Player-Stein wird rausgeschmissen */
                    hilfBoard2.fWho[sTarget] = COMPUTER;
                    hilfBoard2.usNo[27]++;
                    fThrow = YES;
                }
                else
                {
                    hilfBoard2.usNo[sTarget]++;
                    hilfBoard2.fWho[sTarget] = COMPUTER;
                    fThrow = NO;
                }
                
                /* Eintragen des Zuges */
                if (fThrow && fCanComputerThrowOne(hilfBoard2))
                    sOnes = -7;
                else
                    if (sTarget == 26 && (i + _usDice1) == 26)
                        sOnes = -8;
                    else
                        if (sTarget == 26 || (i + _usDice1) == 26)
                            sOnes = -6;
                        else
                        /* zwei gehen im letzten Spielverlauf zugleich in die Home area */
                            if (sTarget > 19 && (i + _usDice1) > 19 && sGetComputerOnes(hilfBoard2) == 0 && i < 20 && j < 20 && fIsComputerAlmostFinish(hilfBoard2))
                            {
                                sOnes = -4;
                                if (hilfBoard2.usNo[sTarget] > 3 && hilfBoard2.usNo[i + _usDice1] > 3)
                                    sOnes = -3;
                                if (hilfBoard2.usNo[sTarget] > 3 && hilfBoard2.usNo[i + _usDice1] < 4)
                                    sOnes = -4;
                                if (hilfBoard2.usNo[sTarget] < 4 && hilfBoard2.usNo[i + _usDice1] < 4)
                                    sOnes = -5;
                            }
                            else
                            /* eines der beiden geht im letzten Spielverlauf in die Home area */
                                if (((sTarget > 19 && j < 20) || ((i + _usDice1) > 19 && i < 20)) && sGetComputerOnes(hilfBoard2) == 0 && fIsComputerAlmostFinish(hilfBoard2))
                                {
                                    if ((hilfBoard2.usNo[sTarget] > 3 && sTarget > 19) || (hilfBoard2.usNo[i + _usDice1] > 3 && (i + _usDice1) > 19))
                                        sOnes = -1;
                                    else
                                        sOnes = -2;
                                }
                                else
                                    sOnes = sGetComputerOnes(hilfBoard2);
                
                if (sMove[0] >= sOnes)
                {
                    sMove[0] = sOnes;
                    sMove[1] = i;
                    sMove[2] = i + _usDice1;
                    sMove[3] = j;
                    sMove[4] = j + _usDice2;
                }
            }
        }
    }
}
    
    if (sMove[0] != 43)
    {
        /* die zu machenden Zuege stehen jetzt in sMove */
        /* erster Zug von sMove[1] nach sMove[2] */
        
        if (mainView.board.fWho[sMove[2]] == PLAYER && mainView.board.usNo[sMove[2]] == 1)
        {
            /* Player-Stein wird rausgeschmissen */
            short sFrom = sMove[1];
            short sTo = sMove[2];
            [mainView draw:sFrom :sTo :COMPUTER :YES :self.fAnimation];
        }
        else
        {
            short sFrom = sMove[1];
            short sTo = sMove[2];
            [mainView draw:sFrom :sTo :COMPUTER :NO :self.fAnimation];
        }
        
        if (mainView.board.fWho[sMove[4]] == PLAYER && mainView.board.usNo[sMove[4]] == 1)
        {
            /* Player-Stein wird rausgeschmissen */
            short sFrom = sMove[3];
            short sTo = sMove[4];
            [mainView draw:sFrom :sTo :COMPUTER :YES :self.fAnimation];
        }
        else
        {
            short sFrom = sMove[3];
            short sTo = sMove[4];
            [mainView draw:sFrom :sTo :COMPUTER :NO :self.fAnimation];
        }
    }
    else
        if (sMove[5] != 43)
        {
            /* es war nur mehr ein Zug mit dem ersten Wuerfel moeglich */
            if (mainView.board.fWho[sMove[7]] == PLAYER && mainView.board.usNo[sMove[7]] == 1)
            {
                /* Player-Stein wird rausgeschmissen */
                short sFrom = sMove[6];
                short sTo = sMove[7];
                [mainView draw:sFrom :sTo :COMPUTER :YES :self.fAnimation];
            }
            else
            {
                short sFrom = sMove[6];
                short sTo = sMove[7];
                [mainView draw:sFrom :sTo :COMPUTER :NO :self.fAnimation];
            }
            
            if (fIsFinish(COMPUTER, mainView.board))
            {
                /* ist mit dem zweiten Wuerfel _usDice2 ein Zug moeglich? */
                for (l = 26 - _usDice2; l < 26; l++)
                {
                    /* kann ich einen Stein ins Ziel bringen? */
                    if (mainView.board.usNo[l] > 0 && mainView.board.fWho[l] == COMPUTER)
                    {
                        /* ich kann einen Stein ins Ziel bringen */
                        [mainView draw:l :26 :COMPUTER :NO :self.fAnimation];
                        break;
                    }
                }
            }
        }
        else
        {
            if (!fSwapped)
            {
                /* beide sind 43, daher _usDice1 und _usDice2 umdrehen */
                fSwapped = YES;
                usDice = _usDice1;
                _usDice1 = _usDice2;
                _usDice2 = usDice;
                goto start;
            }
            /* es sind mit beiden Wuerfeln _usDice1 und _usDice2 keine Zuege mehr mîglich */
            
            if (fIsFinish(COMPUTER, mainView.board))
            {
                /* _usDice1 ist kleiner als _usDice2 */
                /* ist mit dem zweiten Wuerfel _usDice2 ein Zug moeglich? */
                for (l = 26 - _usDice2; l < 26; l++)
                {
                    /* kann ich einen Stein ins Ziel bringen? */
                    if (mainView.board.usNo[l] > 0 && mainView.board.fWho[l] == COMPUTER)
                    {
                        /* ich kann einen Stein ins Ziel bringen */
                        [mainView draw:l :26 :COMPUTER :NO :self.fAnimation];
                        break;
                    }
                }
                /* ist mit dem ersten WÅrfel _usDice1 ein Zug mîglich? */
                for (l = 26 - _usDice1; l < 26; l++)
                {
                    /* kann ich einen Stein ins Ziel bringen? */
                    if (mainView.board.usNo[l] > 0 && mainView.board.fWho[l] == COMPUTER)
                    {
                        /* ich kann einen Stein ins Ziel bringen */
                        [mainView draw:l :26 :COMPUTER :NO :self.fAnimation];
                        break;
                    }
                }
            }
        }
}

@end
