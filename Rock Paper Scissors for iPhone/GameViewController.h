//
//  GameViewController.h
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/28/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AVFoundation/AVFoundation.h>
#import "MenuViewController.h"

enum weaponChoice
{
    weaponChoiceRock,
    weaponChoicePaper,
    weaponChoiceScissors
};

enum winnerOutcome
{
    outcomeLeftPlayerWon,
    outcomeRightPlayerWon,
    outcomeTie
};


@interface GameViewController : UIViewController <UIViewControllerTransitioningDelegate, MenuViewControllerDelegate, ADBannerViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *segmentedControlButtonItem;

// Popover for meny on iPad.
@property (weak, nonatomic) UIPopoverController *menuPopover;

// Weapon choice buttons.
@property (weak, nonatomic) IBOutlet UIButton *rockButton;
@property (weak, nonatomic) IBOutlet UIButton *paperButton;
@property (weak, nonatomic) IBOutlet UIButton *scissorsButton;

// Names of players at top.
@property (weak, nonatomic) IBOutlet UILabel *leftPlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPlayerNameLabel;

// Says which weapon beat what the other.
@property (weak, nonatomic) IBOutlet UILabel *result;

// Score label.
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

// Images at top indicating which weapon the player chose.
@property (weak, nonatomic) IBOutlet UIImageView *leftPlayerWeapon;
@property (weak, nonatomic) IBOutlet UIImageView *rightPlayerWeapon;

// Controls current game difficulty.
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyControl;
@property enum difficulty currentDifficulty;

// Shade for darkening view controller when menu is open.
@property (weak, nonatomic) IBOutlet UIImageView *shadeImageView;

// Advertisement at bottom of view controller.
@property (weak, nonatomic) IBOutlet ADBannerView *ad;

// Toolbar at bottom.
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

// Two player mode player names.
@property (strong, nonatomic) NSString *leftPlayerName, *rightPlayerName;

// Enum values.
@property enum difficulty gameDifficulty;
@property enum mode gameMode;
@property enum weaponChoice leftPlayerWeaponChoice, rightPlayerWeaponChoice;

// Outcome values.
@property enum winnerOutcome outcome;

// Option variables.
@property NSInteger playerVsPlayerWinningScore, playerVsComputerWinningScore;
@property BOOL weaponSoundOn, clicksOn;

@property NSInteger leftPlayerScore, rightPlayerScore;

// Sounds.
@property (strong, nonatomic) AVAudioPlayer *clickSound;
@property (strong, nonatomic) AVAudioPlayer *rockSound;
@property (strong, nonatomic) AVAudioPlayer *paperSound;
@property (strong, nonatomic) AVAudioPlayer *scissorsSound;
@property (strong, nonatomic) AVAudioPlayer *tieSound;

// UIAlertViews.
@property (strong, nonatomic) UIAlertView *playerVsComputerPlayerWonAlert;
@property (strong, nonatomic) UIAlertView *playerVsComputerOpponentWonAlert;
@property (strong, nonatomic) UIAlertView *playerVsPlayerPlayerWonAlert;
@property (strong, nonatomic) UIAlertView *resetAlert;
@property (strong, nonatomic) UIAlertView *player1NameDialog;
@property (strong, nonatomic) UIAlertView *player2NameDialog;

// Flags for when a player in PvP mode has chosen or not.
@property BOOL leftPlayerHasChosen, rightPlayerHasChosen;

// For controlling constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineBottomSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewBottomSpace;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIView *spacingView;

// Methods for bottom controls.
- (IBAction)changeDifficulty:(id)sender;

// Processes choices.
- (IBAction)processRound:(UIButton *)sender;
- (void)processPlayerChoice:(UIButton *)sender;
- (void)processComputerChoice;

// Processes winner.
- (void)processPlayerVsComputerWinner;
- (void)processPlayerVsPlayerWinner;

- (void)askForPlayerNames;
- (void)promptPlayer1ToPlay;

- (void)playSound:(AVAudioPlayer *)sound;

- (void)resetGame;

- (IBAction)openMenu:(id)sender;

@end
