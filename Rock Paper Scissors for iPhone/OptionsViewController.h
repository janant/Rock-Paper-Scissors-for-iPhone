//
//  OptionsViewController.h
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/29/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol OptionsViewControllerDelegate <NSObject>

- (void)dismissPopover;

@end

@interface OptionsViewController : UITableViewController
{
    NSUserDefaults *userDefaults;
}

@property (strong, nonatomic) UISwitch *weaponsSoundSwitch;
@property (strong, nonatomic) UISwitch *clicksSoundSwitch;

@property (strong, nonatomic) UIStepper *winningScorePlayerVsComputer, *winningScorePlayerVsPlayer;

@property (strong, nonatomic) AVAudioPlayer *clickSound;

@property (weak, nonatomic) id <OptionsViewControllerDelegate> delegate;

- (IBAction)saveOptions:(id)sender;
- (IBAction)cancelOptions:(id)sender;
- (void)playClickSound;

@end
