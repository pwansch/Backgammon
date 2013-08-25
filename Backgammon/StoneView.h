//
//  StoneView.h
//  Backgammon
//
//  Created by Peter Wansch on 8/18/13.
//
//

#import <UIKit/UIKit.h>

@interface StoneView : UIView

@property (assign, nonatomic) BOOL fWho;

- (id)initWithFrame:(CGRect)frame :(BOOL)fWho;

@end