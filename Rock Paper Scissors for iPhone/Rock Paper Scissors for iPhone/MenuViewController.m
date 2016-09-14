//
//  MenuViewController.m
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/28/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
{
    NSInteger winningScorePlayerVsComputerStartingScore;
    NSInteger winningScorePlayerVsPlayerStartingScore;
    BOOL weaponsSoundInitialSetting;
    BOOL clicksSoundInitialSetting;
    enum difficulty initialDifficulty;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.toolbar.frame.size.height, 0, 40, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.toolbar.frame.size.height, 0, 40, 0);
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    _clickSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Click" withExtension:@"mp3"] error:nil];
    [_clickSound prepareToPlay];
    
    // Sets up player vs computer winning score stepper.
    self.winningScorePlayerVsComputer = [[UIStepper alloc] init];
    self.winningScorePlayerVsComputer.maximumValue = 50.0;
    self.winningScorePlayerVsComputer.minimumValue = 3.0;
    self.winningScorePlayerVsComputer.stepValue = 1.0;
    [self.winningScorePlayerVsComputer addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventValueChanged];
    
    NSInteger i = [userDefaults integerForKey:@"kPlayerVsComputerWinningScore"];
    if (i == 0)
    {
        self.winningScorePlayerVsComputer.value = 25.0;
    }
    else
    {
        self.winningScorePlayerVsComputer.value = (double)i;
    }
    
    winningScorePlayerVsComputerStartingScore = (NSInteger)_winningScorePlayerVsComputer.value;
    
    // Sets up player vs player winning score stepper.
    self.winningScorePlayerVsPlayer = [[UIStepper alloc] init];
    self.winningScorePlayerVsPlayer.maximumValue = 25.0;
    self.winningScorePlayerVsPlayer.minimumValue = 3.0;
    self.winningScorePlayerVsPlayer.stepValue = 1.0;
    [self.winningScorePlayerVsPlayer addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventValueChanged];
    
    i = [userDefaults integerForKey:@"kPlayerVsPlayerWinningScore"];
    if (i == 0)
    {
        self.winningScorePlayerVsPlayer.value = 10.0;
    }
    else
    {
        self.winningScorePlayerVsPlayer.value = (double)i;
    }
    
    winningScorePlayerVsPlayerStartingScore = (NSInteger)_winningScorePlayerVsPlayer.value;
    
    // Sets up weapons sound toggle.
    self.weaponsSoundSwitch = [UISwitch new];
    [_weaponsSoundSwitch addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventValueChanged];
    
    NSNumber *switchOn = [userDefaults objectForKey:@"kWeaponsSoundOn"];
    if (switchOn)
    {
        _weaponsSoundSwitch.on = switchOn.boolValue;
    }
    else
    {
        _weaponsSoundSwitch.on = YES;
    }
    
    weaponsSoundInitialSetting = _weaponsSoundSwitch.isOn;
    
    // Sets up click sound toggle.
    self.clicksSoundSwitch = [UISwitch new];
    [_clicksSoundSwitch addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventValueChanged];
    
    switchOn = [userDefaults objectForKey:@"kClickSoundOn"];
    if (switchOn)
    {
        _clicksSoundSwitch.on = switchOn.boolValue;
    }
    else
    {
        _clicksSoundSwitch.on = YES;
    }
    
    clicksSoundInitialSetting = _clicksSoundSwitch.isOn;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        _difficultyControl.selectedSegmentIndex = _currentDifficulty;
        if (_gameMode == gameModePlayerVsPlayer)
        {
            _difficultyControl.enabled = NO;
        }
        
        [_difficultyControl addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventValueChanged];
        
        initialDifficulty = _difficultyControl.selectedSegmentIndex;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0:
            switch (_gameMode)
            {
                case gameModePlayerVsComputer:
                    return 3;
                    break;
                case gameModePlayerVsPlayer:
                    return 4;
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case 1:
            return 2;
            break;
        case 2:
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Game Options";
            break;
        case 1:
            return @"Sounds";
            break;
        case 2:
            return @"Player vs. Computer Mode";
            break;
        case 3:
            return @"Player vs. Player Mode";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 2:
            return [NSString stringWithFormat:@"Player vs. Computer mode will end after one side reaches %d points.", (int)(self.winningScorePlayerVsComputer.value)];
            break;
        case 3:
            return [NSString stringWithFormat:@"Player vs. Player mode will end after one player reaches %d points.", (int)(self.winningScorePlayerVsPlayer.value)];
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    switch (indexPath.section)
    {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Control"];
            switch (_gameMode)
            {
                case gameModePlayerVsComputer:
                    switch (indexPath.row)
                    {
                        case 0:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Reset Score";
                            ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor redColor];
                            break;
                        case 1:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Player vs. Player Mode";
                            break;
                        case 2:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Exit to Menu";
                            break;
                        default:
                            break;
                    }
                    break;
                case gameModePlayerVsPlayer:
                    switch (indexPath.row)
                    {
                        case 0:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Reset Score";
                            ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor redColor];
                            break;
                        case 1:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Change Player Names";
                            break;
                        case 2:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Player vs. Computer Mode";
                            break;
                        case 3:
                            ((UILabel *)[cell viewWithTag:1]).text = @"Exit to Menu";
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Option"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Weapons";
                    cell.accessoryView = _weaponsSoundSwitch;
                    break;
                case 1:
                    cell.textLabel.text = @"Clicks";
                    cell.accessoryView = _clicksSoundSwitch;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Option"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Winning Score";
            cell.accessoryView = _winningScorePlayerVsComputer;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Option"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Winning Score";
            cell.accessoryView = _winningScorePlayerVsPlayer;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_gameMode)
    {
        case gameModePlayerVsComputer:
            if (indexPath.section == 0)
            {
                [self playClickSound];
                switch (indexPath.row)
                {
                    case 0:
                        [self.delegate dismissingViewController];
                        [self.delegate resetScore];
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate dismissPopoverWithOptions:optionNone];
                                break;
                            case UIUserInterfaceIdiomPhone:
                                [self dismissViewControllerAnimated:YES completion:nil];
                                break;
                            default:
                                break;
                        }
                        break;
                    case 1:
                    {
                        [self.delegate dismissingViewController];
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate dismissPopoverWithOptions:optionChangeToPlayerVsPlayerMode];
                                break;
                            case UIUserInterfaceIdiomPhone:
                            {
                                _difficultyControl.enabled = NO;
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [self.delegate changedToGameMode:gameModePlayerVsPlayer];
                                }];
                                break;
                            }
                            default:
                                break;
                        }
                        break;
                    }
                    case 2:
                    {
                        [self.delegate dismissingViewController];
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate exitGame];
                                [self.delegate dismissPopoverWithOptions:optionExitGame];
                                break;
                            case UIUserInterfaceIdiomPhone:
                            {
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [self.delegate exitGame];
                                }];
                                break;
                            }
                            default:
                                break;
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
            break;
        case gameModePlayerVsPlayer:
            if (indexPath.section == 0)
            {
                [self playClickSound];
                switch (indexPath.row)
                {
                    case 0:
                        [self.delegate dismissingViewController];
                        [self.delegate resetScore];
                        
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate dismissPopoverWithOptions:optionNone];
                                break;
                            case UIUserInterfaceIdiomPhone:
                                [self dismissViewControllerAnimated:YES completion:nil];
                                break;
                            default:
                                break;
                        }
                        break;
                    case 1:
                    {
                        [self.delegate dismissingViewController];
                        
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate dismissPopoverWithOptions:optionChangePlayerNames];
                                break;
                            case UIUserInterfaceIdiomPhone:
                            {
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [self.delegate changePlayerNames];
                                }];
                                break;
                            }
                            default:
                                break;
                        }
                        break;
                    }
                    case 2:
                        [self.delegate changedToGameMode:gameModePlayerVsComputer];
                        [self.delegate dismissingViewController];
                        
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate dismissPopoverWithOptions:optionNone];
                                break;
                            case UIUserInterfaceIdiomPhone:
                                _difficultyControl.enabled = YES;
                                [self dismissViewControllerAnimated:YES completion:nil];
                                break;
                            default:
                                break;
                        }
                        break;
                    case 3:
                    {
                        [self.delegate dismissingViewController];
                        
                        switch ([UIDevice currentDevice].userInterfaceIdiom)
                        {
                            case UIUserInterfaceIdiomPad:
                                [self.delegate dismissPopoverWithOptions:optionExitGame];
                                break;
                            case UIUserInterfaceIdiomPhone:
                            {
                                _difficultyControl.enabled = YES;
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [self.delegate exitGame];
                                }];
                                break;
                            }
                            default:
                                break;
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
            break;
        default:
            break;
    }
}

- (void)playClickSound
{
    if (_clicksSoundSwitch.on)
    {
        [_clickSound play];
    }
    [self.tableView reloadData];
}

- (IBAction)closeMenu:(UIBarButtonItem *)sender
{
    [self.delegate dismissingViewController];
    
    [self playClickSound];
    
    [userDefaults setObject:[NSNumber numberWithBool:_weaponsSoundSwitch.on] forKey:@"kWeaponsSoundOn"];
    [userDefaults setObject:[NSNumber numberWithBool:_clicksSoundSwitch.on] forKey:@"kClickSoundOn"];
    [userDefaults setInteger:_winningScorePlayerVsComputer.value forKey:@"kPlayerVsComputerWinningScore"];
    [userDefaults setInteger:_winningScorePlayerVsPlayer.value forKey:@"kPlayerVsPlayerWinningScore"];
    
    switch ([UIDevice currentDevice].userInterfaceIdiom)
    {
        case UIUserInterfaceIdiomPad:
            if ((NSInteger)_winningScorePlayerVsComputer.value != winningScorePlayerVsComputerStartingScore || (NSInteger)_winningScorePlayerVsPlayer.value != winningScorePlayerVsPlayerStartingScore || clicksSoundInitialSetting)
            {
                [self.delegate resetScore];
                [self.delegate optionsChanged];
            }
            if (clicksSoundInitialSetting != _clicksSoundSwitch.on || weaponsSoundInitialSetting != _weaponsSoundSwitch.on)
            {
                [self.delegate optionsChanged];
            }
            [self.delegate dismissPopoverWithOptions:optionNone];
            break;
        case UIUserInterfaceIdiomPhone:
            if ((NSInteger)_winningScorePlayerVsComputer.value != winningScorePlayerVsComputerStartingScore || (NSInteger)_winningScorePlayerVsPlayer.value != winningScorePlayerVsPlayerStartingScore || initialDifficulty != _difficultyControl.selectedSegmentIndex)
            {
                [self.delegate changedDifficulty:_difficultyControl.selectedSegmentIndex];
                [self.delegate resetScore];
                [self.delegate optionsChanged];
            }
            if (clicksSoundInitialSetting != _clicksSoundSwitch.on || weaponsSoundInitialSetting != _weaponsSoundSwitch.on)
            {
                [self.delegate optionsChanged];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (IBAction)cancel:(id)sender {
    [self playClickSound];
    [self.delegate dismissPopoverWithOptions:optionNone];
}

@end
