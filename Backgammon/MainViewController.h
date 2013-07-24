//
//  MainViewController.h
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;

@end
