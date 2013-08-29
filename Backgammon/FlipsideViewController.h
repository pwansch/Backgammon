//
//  FlipsideViewController.h
//  Backgammon
//
//  Created by Peter Wansch on 7/23/13.
//
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)flipsideViewControllerResetScores;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *soundSwitch;

- (IBAction)done:(id)sender;
- (IBAction)reset:(id)sender;

@end
