//
//  MainMenuViewController.h
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/29/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AVFoundation/AVFoundation.h>
#import "OptionsViewController.h"

@interface MainMenuViewController : UIViewController <ADBannerViewDelegate, UIPopoverControllerDelegate, OptionsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playerVsComputerButton;
@property (weak, nonatomic) IBOutlet UIButton *playerVsPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;

@property (weak, nonatomic) IBOutlet ADBannerView *ad;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomSpacing;
@property (weak, nonatomic) IBOutlet UIView *spacerView;

@property (weak, nonatomic) UIPopoverController *optionsPopover;

@property (strong, nonatomic) AVAudioPlayer *clickSound;

@property BOOL clickSoundOn;

- (void)playClickSound;

@end
