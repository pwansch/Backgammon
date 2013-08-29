//
//  FlipsideViewController.m
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	// Load settings
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.animationSwitch.on = [defaults boolForKey:kAnimationKey];
	self.soundSwitch.on = [defaults boolForKey:kSoundKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
	// Save settings and write to disk
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.animationSwitch.on forKey:kAnimationKey];
	[defaults setBool:self.soundSwitch.on forKey:kSoundKey];
	[defaults synchronize];
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)reset:(id)sender
{
	// Save settings and write to disk
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:kScoreComputerKey];
    [defaults setInteger:0 forKey:kScorePlayerKey];
	[defaults synchronize];
    
    [self.delegate flipsideViewControllerResetScores];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view
    self.animationSwitch = nil;
	self.soundSwitch = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation !=	UIInterfaceOrientationPortraitUpsideDown);
    }
}

@end
