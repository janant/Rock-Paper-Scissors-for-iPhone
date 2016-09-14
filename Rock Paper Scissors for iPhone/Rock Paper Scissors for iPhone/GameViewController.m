//
//  GameViewController.m
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/28/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import "GameViewController.h"
#import "SlideUpAnimatedTransition.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Open Menu Popover"])
    {
        self.menuPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        self.menuPopover.delegate = self;
        
        MenuViewController *menu = (MenuViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        menu.delegate = self;
        menu.gameMode = _gameMode;
    }
    if ([segue.identifier isEqualToString:@"Open Menu"])
    {
        MenuViewController *menu = (MenuViewController *)segue.destinationViewController;
        menu.modalPresentationStyle = UIModalPresentationCustom;
        menu.transitioningDelegate = self;
        menu.delegate = self;
        menu.currentDifficulty = _currentDifficulty;
        
        menu.gameMode = _gameMode;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.shadeImageView.alpha = 0.3;
        }];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        switch (toInterfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                _segmentedControlButtonItem.width = 941;
                break;
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                _segmentedControlButtonItem.width = 685;
                break;
            default:
                break;
        }
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

- (void)dismissPopoverWithOptions:(enum dismissPopoverOption)option
{
    [self.menuPopover dismissPopoverAnimated:YES];
    
    switch (option)
    {
        case optionChangeToPlayerVsPlayerMode:
            self.gameMode = gameModePlayerVsPlayer;
            [self resetGame];
            [self askForPlayerNames];
            break;
        case optionChangeToPlayerVsComputerMode:
            self.gameMode = gameModePlayerVsComputer;
            [self resetGame];
            break;
        case optionChangePlayerNames:
            [self resetGame];
            [self askForPlayerNames];
            break;
        case optionExitGame:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case optionNone:
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self playSound:_clickSound];
    if (alertView == _playerVsComputerPlayerWonAlert) // Reset PvC mode if player wins
    {
        if (buttonIndex == 0)
        {
            [self resetGame];
        }
    }
    else if (alertView == _playerVsComputerOpponentWonAlert) // Reset PvC mode if computer wins
    {
        if (buttonIndex == 0)
        {
            [self resetGame];
        }
    }
    else if (alertView == _resetAlert) // Resets game.
    {
        if (buttonIndex == 0)
        {
            [self resetGame];
        }
    }
    else if (alertView == _player1NameDialog) // Prompts for Player 1 name.
    {
        _leftPlayerName = [_player1NameDialog textFieldAtIndex:0].text;
        if (_leftPlayerName.length == 0)
        {
            _leftPlayerName = @"Player 1";
        }
        _leftPlayerNameLabel.text = _leftPlayerName;
        [_player2NameDialog show];
    }
    else if (alertView == _player2NameDialog) // Prompts for Player 2 name.
    {
        _rightPlayerName = [_player2NameDialog textFieldAtIndex:0].text;
        if (_rightPlayerName.length == 0)
        {
            _rightPlayerName = @"Player 2";
        }
        _rightPlayerNameLabel.text = _rightPlayerName;
        [self resetGame];
    }
    else if (alertView == _playerVsPlayerPlayerWonAlert) // Resets PvP mode when a player wins
    {
        if (buttonIndex == 0)
        {
            [self resetGame];
        }
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.ad.hidden = YES;
    
    [self.view removeConstraints:@[self.lineBottomSpace, self.viewBottomSpace]];
    
    self.lineBottomSpace = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.line attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.lineBottomSpace.constant];
    self.viewBottomSpace = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.spacingView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[self.lineBottomSpace, self.viewBottomSpace]];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.ad.hidden = NO;
    
    [self.view removeConstraints:@[self.lineBottomSpace, self.viewBottomSpace]];
    
    self.lineBottomSpace = [NSLayoutConstraint constraintWithItem:self.ad attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.line attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.lineBottomSpace.constant];
    self.viewBottomSpace = [NSLayoutConstraint constraintWithItem:self.ad attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.spacingView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[self.lineBottomSpace, self.viewBottomSpace]];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissingViewController
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.shadeImageView.alpha = 0.0;
        }];
    }
}

- (void)resetScore
{
    [self resetGame];
}

- (void)exitGame
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)optionsChanged
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _weaponSoundOn = [[userDefaults objectForKey:@"kWeaponsSoundOn"] boolValue];
    _clicksOn = [[userDefaults objectForKey:@"kClickSoundOn"] boolValue];
    
    _playerVsComputerWinningScore = [userDefaults integerForKey:@"kPlayerVsComputerWinningScore"];
    _playerVsPlayerWinningScore = [userDefaults integerForKey:@"kPlayerVsPlayerWinningScore"];
}

- (void)changedToGameMode:(enum mode)mode
{
    _gameMode = mode;
    switch (mode)
    {
        case gameModePlayerVsComputer:
            [self resetGame];
            break;
        case gameModePlayerVsPlayer:
            [self resetGame];
            [self askForPlayerNames];
            break;
        default:
            break;
    }
}

- (void)changePlayerNames
{
    [self resetGame];
    [self askForPlayerNames];
}

- (void)changedDifficulty:(enum difficulty)difficulty
{
    _currentDifficulty = difficulty;
    _difficultyControl.selectedSegmentIndex = difficulty;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    SlideUpAnimatedTransition *slideUpAT = [SlideUpAnimatedTransition new];
    slideUpAT.presenting = YES;
    return slideUpAT;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SlideUpAnimatedTransition *slideUpAT = [SlideUpAnimatedTransition new];
    slideUpAT.presenting = NO;
    return slideUpAT;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [_player1NameDialog textFieldAtIndex:0])
    {
        [_player1NameDialog dismissWithClickedButtonIndex:0 animated:YES];
        [self alertView:_player1NameDialog clickedButtonAtIndex:0];
    }
    else if (textField == [_player2NameDialog textFieldAtIndex:0])
    {
        [_player2NameDialog dismissWithClickedButtonIndex:0 animated:YES];
        [self alertView:_player2NameDialog clickedButtonAtIndex:0];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ad.delegate = self;
    
    self.ad.hidden = YES;
    
    [self.view removeConstraints:@[self.lineBottomSpace, self.viewBottomSpace]];
    
    self.lineBottomSpace = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.line attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.lineBottomSpace.constant];
    self.viewBottomSpace = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.spacingView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[self.lineBottomSpace, self.viewBottomSpace]];
    
    [self.view layoutIfNeeded];
    
    // Sets up sounds.
    _rockSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Rock" withExtension:@"m4a"] error:nil];
    _paperSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Paper" withExtension:@"m4a"] error:nil];
    _scissorsSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Scissors" withExtension:@"mp3"] error:nil];
    _tieSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Tie" withExtension:@"mp3"] error:nil];
    _clickSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Click" withExtension:@"mp3"] error:nil];
    [_rockSound prepareToPlay];
    [_paperSound prepareToPlay];
    [_scissorsSound prepareToPlay];
    [_tieSound prepareToPlay];
    [_clickSound prepareToPlay];
    
    NSNumber *boolOption = [[NSUserDefaults standardUserDefaults] objectForKey:@"kClickSoundOn"];
    if (boolOption)
    {
        _clicksOn = boolOption.boolValue;
    }
    else
    {
        _clicksOn = YES;
    }
    
    boolOption = [[NSUserDefaults standardUserDefaults] objectForKey:@"kWeaponsSoundOn"];
    if (boolOption)
    {
        _weaponSoundOn = boolOption.boolValue;
    }
    else
    {
        _weaponSoundOn = YES;
    }
    
    // Sets up winning scores.
    self.playerVsComputerWinningScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"kPlayerVsComputerWinningScore"];
    self.playerVsPlayerWinningScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"kPlayerVsPlayerWinningScore"];
    if (self.playerVsComputerWinningScore == 0)
    {
        self.playerVsComputerWinningScore = 25;
    }
    if (self.playerVsPlayerWinningScore == 0)
    {
        self.playerVsPlayerWinningScore = 10;
    }
    
    // Sets up UIAlertViews.
    _playerVsComputerPlayerWonAlert = [[UIAlertView alloc] initWithTitle:@"You win!" message:[NSString stringWithFormat:@"You got to %d points first.", (int)(self.playerVsComputerWinningScore)] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    _playerVsComputerOpponentWonAlert = [[UIAlertView alloc] initWithTitle:@"You lose!" message:[NSString stringWithFormat:@"Your opponent got to %d points first.", (int)(self.playerVsComputerWinningScore)] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    _resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset Score" message:@"Are you sure you would like to reset the score?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"Cancel", nil];
    
    _player1NameDialog = [[UIAlertView alloc] init];
    _player1NameDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    _player1NameDialog.title = @"Enter Player 1 Name:";
    [_player1NameDialog addButtonWithTitle:@"Done"];
    _player1NameDialog.delegate = self;
    [_player1NameDialog textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_player1NameDialog textFieldAtIndex:0].delegate = self;
    [_player1NameDialog textFieldAtIndex:0].placeholder = @"Player 1";
    
    _player2NameDialog = [[UIAlertView alloc] init];
    _player2NameDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    _player2NameDialog.title = @"Enter Player 2 Name:";
    [_player2NameDialog addButtonWithTitle:@"Done"];
    _player2NameDialog.delegate = self;
    [_player2NameDialog textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_player2NameDialog textFieldAtIndex:0].delegate = self;
    [_player2NameDialog textFieldAtIndex:0].placeholder = @"Player 2";
    
    [_player1NameDialog textFieldAtIndex:0].keyboardAppearance = UIKeyboardAppearanceLight;
    [_player2NameDialog textFieldAtIndex:0].keyboardAppearance = UIKeyboardAppearanceLight;
    
    // Sets up score and labels.
    _leftPlayerScore = 0;
    _rightPlayerScore = 0;
    _scoreLabel.text = [NSString stringWithFormat:@"%d — %d", (int)_leftPlayerScore, (int)_rightPlayerScore];
    
    // Sets up game depending on game mode.
    if (_gameMode == gameModePlayerVsComputer)
    {
        _difficultyControl.enabled = YES;
        _difficultyControl.selectedSegmentIndex = 0;
        _leftPlayerNameLabel.text = @"Player";
        _leftPlayerWeapon.image = [UIImage imageNamed:@"Pick Weapon.png"];
        _rightPlayerNameLabel.text = @"Opponent";
        _rightPlayerWeapon.image = [UIImage imageNamed:@"Waiting.png"];
        _result.text = @"Pick your weapon!";
    }
    else if (_gameMode == gameModePlayerVsPlayer)
    {
        _difficultyControl.enabled = NO;
        _result.hidden = YES;
        [_player1NameDialog show];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                _segmentedControlButtonItem.width = 941;
                break;
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                _segmentedControlButtonItem.width = 685;
                break;
            default:
                break;
        }
    }
}

- (IBAction)processRound:(UIButton *)sender
{
    if (_gameMode == gameModePlayerVsComputer)
    {
        [self processPlayerChoice:sender];
        [self processComputerChoice];
        [self processPlayerVsComputerWinner];
    }
    else if (_gameMode == gameModePlayerVsPlayer)
    {
        if (_leftPlayerHasChosen == NO) // Player 1's decision
        {
            if (sender == _rockButton)
            {
                _leftPlayerWeaponChoice = weaponChoiceRock;
            }
            else if (sender == _paperButton)
            {
                _leftPlayerWeaponChoice = weaponChoicePaper;
            }
            else if (sender == _scissorsButton)
            {
                _leftPlayerWeaponChoice = weaponChoiceScissors;
            }
            _leftPlayerHasChosen = YES;
            _leftPlayerWeapon.image = [UIImage imageNamed:@"Waiting.png"];
            _rightPlayerWeapon.image = [UIImage imageNamed:@"Pick Weapon.png"];
            _result.text = [NSString stringWithFormat:@"Your turn, %@!", _rightPlayerName];
        }
        else if (_rightPlayerHasChosen == NO) // Player 2's decision
        {
            if (sender == _rockButton)
            {
                _rightPlayerWeaponChoice = weaponChoiceRock;
            }
            else if (sender == _paperButton)
            {
                _rightPlayerWeaponChoice = weaponChoicePaper;
            }
            else if (sender == _scissorsButton)
            {
                _rightPlayerWeaponChoice = weaponChoiceScissors;
            }
            _rightPlayerHasChosen = YES;
            [self processPlayerVsPlayerWinner];
        }
    }
}

- (void)processPlayerChoice:(UIButton *)sender
{
    // Decides what button the player has pressed.
    if (sender == _rockButton)
    {
        _leftPlayerWeaponChoice = weaponChoiceRock;
        _leftPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
    }
    else if (sender == _paperButton)
    {
        _leftPlayerWeaponChoice = weaponChoicePaper;
        _leftPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
    }
    else if (sender == _scissorsButton)
    {
        _leftPlayerWeaponChoice = weaponChoiceScissors;
        _leftPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
    }
}

- (void)processComputerChoice
{
    NSInteger i;
    // Processes computer choice based on current difficulty.
    switch (_currentDifficulty)
    {
        case difficultyEasy: // Easy mode
            i = (arc4random() % 100) + 1;
            if (i > 0 && i <= 20) // 20% chance of purposefully losing
            {
                switch (_leftPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeaponChoice = weaponChoiceScissors;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeaponChoice = weaponChoiceRock;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeaponChoice = weaponChoicePaper;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    default:
                        break;
                }
            }
            else // Other 80% is random chance
            {
                _rightPlayerWeaponChoice = (arc4random() % 3);
                switch (_rightPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                    default:
                        break;
                }
            }
            break;
        case difficultyMedium: // Medium mode
            i = (arc4random() % 100) + 1;
            if (i > 0 && i <= 20) // 20% chance of purposefully losing
            {
                switch (_leftPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeaponChoice = weaponChoiceScissors;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeaponChoice = weaponChoiceRock;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeaponChoice = weaponChoicePaper;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    default:
                        break;
                }
            }
            else if (i > 20 && i < 35) // 15% chance of purposefully winning
            {
                switch (_leftPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeaponChoice = weaponChoicePaper;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeaponChoice = weaponChoiceScissors;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeaponChoice = weaponChoiceRock;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    default:
                        break;
                }
            }
            else // Other 65% is random chance
            {
                _rightPlayerWeaponChoice = (arc4random() % 3);
                switch (_rightPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                    default:
                        break;
                }
            }
            break;
        case difficultyHard: // Hard mode
            // Random chance
            i = (arc4random() % 100) + 1;
            if (i > 0 && i <= 15) // 15% chance of purposefully winning
            {
                switch (_leftPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeaponChoice = weaponChoicePaper;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeaponChoice = weaponChoiceScissors;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeaponChoice = weaponChoiceRock;
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    default:
                        break;
                }
            }
            else // Other 85% is random chance
            {
                _rightPlayerWeaponChoice = (arc4random() % 3);
                switch (_rightPlayerWeaponChoice)
                {
                    case weaponChoiceRock:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                        break;
                    case weaponChoicePaper:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                        break;
                    case weaponChoiceScissors:
                        _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                    default:
                        break;
                }
                break;
            }
        default:
            break;
    }
}

- (void)processPlayerVsComputerWinner
{
    switch (_leftPlayerWeaponChoice)
    {
        case weaponChoiceRock:
            switch (_rightPlayerWeaponChoice)
            {
                case weaponChoiceRock:
                    _outcome = outcomeTie;
                    _result.text = @"Nothing happens!";
                    [self playSound:_tieSound];
                    break;
                case weaponChoicePaper:
                    _outcome = outcomeRightPlayerWon;
                    _result.text = @"Paper covers rock!";
                    [self playSound:_paperSound];
                    break;
                case weaponChoiceScissors:
                    _outcome = outcomeLeftPlayerWon;
                    _result.text = @"Rock smashes scissors!";
                    [self playSound:_rockSound];
                    break;
                default:
                    break;
            }
            break;
        case weaponChoicePaper:
            switch (_rightPlayerWeaponChoice)
            {
                case weaponChoiceRock:
                    _outcome = outcomeLeftPlayerWon;
                    _result.text = @"Paper covers rock!";
                    [self playSound:_paperSound];
                    break;
                case weaponChoicePaper:
                    _outcome = outcomeTie;
                    _result.text = @"Nothing happens!";
                    [self playSound:_tieSound];
                    break;
                case weaponChoiceScissors:
                    _outcome = outcomeRightPlayerWon;
                    _result.text = @"Scissors cut paper!";
                    [self playSound:_scissorsSound];
                    break;
                default:
                    break;
            }
            break;
        case weaponChoiceScissors:
            switch (_rightPlayerWeaponChoice)
            {
                case weaponChoiceRock:
                    _outcome = outcomeRightPlayerWon;
                    _result.text = @"Rock smashes scissors!";
                    [self playSound:_rockSound];
                    break;
                case weaponChoicePaper:
                    _outcome = outcomeLeftPlayerWon;
                    _result.text = @"Scissors cut paper!";
                    [self playSound:_scissorsSound];
                    break;
                case weaponChoiceScissors:
                    _outcome = outcomeTie;
                    _result.text = @"Nothing happens!";
                    [self playSound:_tieSound];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    // Updates score and says who won.
    switch (_outcome)
    {
        case outcomeLeftPlayerWon:
            _leftPlayerScore++;
            _scoreLabel.text = [NSString stringWithFormat:@"%d — %d", (int)_leftPlayerScore, (int)_rightPlayerScore];
            break;
        case outcomeRightPlayerWon:
            _rightPlayerScore++;
            _scoreLabel.text = [NSString stringWithFormat:@"%d — %d", (int)_leftPlayerScore, (int)_rightPlayerScore];
            break;
        case outcomeTie:
            break;
        default:
            break;
    }
    
    if (_leftPlayerScore == self.playerVsComputerWinningScore)
    {
        [_playerVsComputerPlayerWonAlert show];
    }
    else if (_rightPlayerScore == self.playerVsComputerWinningScore)
    {
        [_playerVsComputerOpponentWonAlert show];
    }
    _result.hidden = NO;
}

- (void)processPlayerVsPlayerWinner
{
    switch (_leftPlayerWeaponChoice)
    {
        case weaponChoiceRock:
            _leftPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
            switch (_rightPlayerWeaponChoice)
        {
            case weaponChoiceRock:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                _outcome = outcomeTie;
                _result.text = @"Nothing happens!";
                [self playSound:_tieSound];
                break;
            case weaponChoicePaper:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                _outcome = outcomeRightPlayerWon;
                _result.text = @"Paper covers rock!";
                [self playSound:_paperSound];
                break;
            case weaponChoiceScissors:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                _outcome = outcomeLeftPlayerWon;
                _result.text = @"Rock smashes scissors!";
                [self playSound:_rockSound];
                break;
            default:
                break;
        }
            break;
        case weaponChoicePaper:
            _leftPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
            switch (_rightPlayerWeaponChoice)
        {
            case weaponChoiceRock:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                _outcome = outcomeLeftPlayerWon;
                _result.text = @"Paper covers rock!";
                [self playSound:_paperSound];
                break;
            case weaponChoicePaper:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                _outcome = outcomeTie;
                _result.text = @"Nothing happens!";
                [self playSound:_tieSound];
                break;
            case weaponChoiceScissors:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                _outcome = outcomeRightPlayerWon;
                _result.text = @"Scissors cut paper!";
                [self playSound:_scissorsSound];
                break;
            default:
                break;
        }
            break;
        case weaponChoiceScissors:
            _leftPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
            switch (_rightPlayerWeaponChoice)
        {
            case weaponChoiceRock:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Rock.png"];
                _outcome = outcomeRightPlayerWon;
                _result.text = @"Rock smashes scissors!";
                [self playSound:_rockSound];
                break;
            case weaponChoicePaper:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Paper.png"];
                _outcome = outcomeLeftPlayerWon;
                _result.text = @"Scissors cut paper!";
                [self playSound:_scissorsSound];
                break;
            case weaponChoiceScissors:
                _rightPlayerWeapon.image = [UIImage imageNamed:@"Scissors.png"];
                _outcome = outcomeTie;
                _result.text = @"Nothing happens!";
                [self playSound:_tieSound];
                break;
            default:
                break;
        }
            break;
        default:
            break;
    }
    
    // Updates score and says who won.
    switch (_outcome)
    {
        case outcomeLeftPlayerWon:
            _leftPlayerScore++;
            _scoreLabel.text = [NSString stringWithFormat:@"%d — %d", (int)_leftPlayerScore, (int)_rightPlayerScore];
            break;
        case outcomeRightPlayerWon:
            _rightPlayerScore++;
            _scoreLabel.text = [NSString stringWithFormat:@"%d — %d", (int)_leftPlayerScore, (int)_rightPlayerScore];
            break;
        case outcomeTie:
            break;
        default:
            break;
    }
    
    if (_leftPlayerScore == _playerVsPlayerWinningScore)
    {
        _playerVsPlayerPlayerWonAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ wins!", _leftPlayerName] message:[NSString stringWithFormat:@"%@ got to %d points first.", _leftPlayerName, (int)(self.playerVsPlayerWinningScore)] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
        [_playerVsPlayerPlayerWonAlert show];
    }
    else if (_rightPlayerScore == _playerVsPlayerWinningScore)
    {
        _playerVsPlayerPlayerWonAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ wins!", _rightPlayerName] message:[NSString stringWithFormat:@"%@ got to %d points first.", _rightPlayerName, (int)(self.playerVsPlayerWinningScore)] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
        [_playerVsPlayerPlayerWonAlert show];
    }
    _leftPlayerHasChosen = NO;
    _rightPlayerHasChosen = NO;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(promptPlayer1ToPlay) userInfo:nil repeats:NO];
}

- (void)promptPlayer1ToPlay
{
    if ([_result.text isEqualToString:[NSString stringWithFormat:@"Your turn, %@!", _rightPlayerName]] == NO && _gameMode == gameModePlayerVsPlayer)
    {
        _result.text = [NSString stringWithFormat:@"Your turn, %@!", _leftPlayerName];
    }
}

- (IBAction)changeDifficulty:(id)sender
{
    _currentDifficulty = _difficultyControl.selectedSegmentIndex;
    [self playSound:_clickSound];
    [self resetGame];
}

- (void)playSound:(AVAudioPlayer *)sound
{
    if (sound == _clickSound && _clicksOn)
    {
        [sound play];
    }
    else if ((sound == _rockSound || sound == _paperSound || sound == _scissorsSound || sound == _tieSound) && _weaponSoundOn)
    {
        [sound play];
    }
}

- (void)askForPlayerNames
{
    [self resetGame];
    [_player1NameDialog show];
}

- (void)resetGame
{
    if (_gameMode == gameModePlayerVsComputer)
    {
        _difficultyControl.enabled = YES;
        _leftPlayerScore = 0;
        _rightPlayerScore = 0;
        _scoreLabel.text = @"0 — 0";
        _leftPlayerWeapon.image = [UIImage imageNamed:@"Pick Weapon.png"];
        _rightPlayerWeapon.image = [UIImage imageNamed:@"Waiting.png"];
        _leftPlayerNameLabel.text = @"Player";
        _rightPlayerNameLabel.text = @"Opponent";
        _result.text = @"Pick your weapon!";
        
        _playerVsComputerPlayerWonAlert = [[UIAlertView alloc] initWithTitle:@"You win!" message:[NSString stringWithFormat:@"You got to %d points first.", (int)(self.playerVsComputerWinningScore)] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
        _playerVsComputerOpponentWonAlert = [[UIAlertView alloc] initWithTitle:@"You lose!" message:[NSString stringWithFormat:@"Your opponent got to %d points first.", (int)(self.playerVsComputerWinningScore)] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
        _resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset Score" message:@"Are you sure you would like to reset the score?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"Cancel", nil];
    }
    else if (_gameMode == gameModePlayerVsPlayer)
    {
        _difficultyControl.enabled = NO;
        _leftPlayerScore = 0;
        _rightPlayerScore = 0;
        _scoreLabel.text = @"0 — 0";
        _leftPlayerHasChosen = NO;
        _rightPlayerHasChosen = NO;
        _leftPlayerWeapon.image = [UIImage imageNamed:@"Pick Weapon.png"];
        _rightPlayerWeapon.image = [UIImage imageNamed:@"Waiting.png"];
        _result.text = [NSString stringWithFormat:@"Your turn, %@!", _leftPlayerName];
        _result.hidden = NO;
        
        _player1NameDialog = [[UIAlertView alloc] init];
        _player1NameDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        _player1NameDialog.title = @"Enter Player 1 Name:";
        [_player1NameDialog addButtonWithTitle:@"Done"];
        _player1NameDialog.delegate = self;
        [_player1NameDialog textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
        [_player1NameDialog textFieldAtIndex:0].delegate = self;
        [_player1NameDialog textFieldAtIndex:0].placeholder = @"Player 1";
        
        _player2NameDialog = [[UIAlertView alloc] init];
        _player2NameDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        _player2NameDialog.title = @"Enter Player 2 Name:";
        [_player2NameDialog addButtonWithTitle:@"Done"];
        _player2NameDialog.delegate = self;
        [_player2NameDialog textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
        [_player2NameDialog textFieldAtIndex:0].delegate = self;
        [_player2NameDialog textFieldAtIndex:0].placeholder = @"Player 2";
        
        [_player1NameDialog textFieldAtIndex:0].keyboardAppearance = UIKeyboardAppearanceLight;
        [_player2NameDialog textFieldAtIndex:0].keyboardAppearance = UIKeyboardAppearanceLight;
    }
}

- (IBAction)openMenu:(id)sender
{
    [self performSegueWithIdentifier:@"Open Menu" sender:sender];
    [self playSound:_clickSound];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
