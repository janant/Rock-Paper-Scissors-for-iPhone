//
//  MenuViewController.h
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/28/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

enum mode
{
    gameModePlayerVsComputer,
    gameModePlayerVsPlayer
};

enum difficulty
{
    difficultyEasy,
    difficultyMedium,
    difficultyHard
};

enum dismissPopoverOption
{
    optionChangeToPlayerVsPlayerMode,
    optionChangeToPlayerVsComputerMode,
    optionExitGame,
    optionChangePlayerNames,
    optionNone
};

@protocol MenuViewControllerDelegate <NSObject>

- (void)dismissingViewController;
- (void)resetScore;
- (void)exitGame;
- (void)changedToGameMode:(enum mode)mode;
- (void)changePlayerNames;
- (void)changedDifficulty:(enum difficulty)difficulty;
- (void)dismissPopoverWithOptions:(enum dismissPopoverOption)option;
- (void)optionsChanged;

@end

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSUserDefaults *userDefaults;
}

@property (strong, nonatomic) UISwitch *weaponsSoundSwitch;
@property (strong, nonatomic) UISwitch *clicksSoundSwitch;

@property (strong, nonatomic) UIStepper *winningScorePlayerVsComputer, *winningScorePlayerVsPlayer;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AVAudioPlayer *clickSound;

@property (weak, nonatomic) id <MenuViewControllerDelegate> delegate;

@property enum difficulty currentDifficulty;

@property enum mode gameMode;

- (IBAction)closeMenu:(UIBarButtonItem *)sender;
- (IBAction)cancel:(id)sender;
- (void)playClickSound;

@end
