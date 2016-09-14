//
//  OptionsViewController.m
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/29/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
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
            return @"Sounds";
            break;
        case 1:
            return @"Player vs. Computer Mode";
            break;
        case 2:
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
        case 1:
            return [NSString stringWithFormat:@"Player vs. Computer mode will end after one side reaches %d points.", (int)(self.winningScorePlayerVsComputer.value)];
            break;
        case 2:
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section)
    {
        case 0:
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
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Winning Score";
                    cell.accessoryView = self.winningScorePlayerVsComputer;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Winning Score";
                    cell.accessoryView = self.winningScorePlayerVsPlayer;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}


- (void)playClickSound
{
    if (_clicksSoundSwitch.on)
    {
        [_clickSound play];
    }
    [self.tableView reloadData];
}

- (IBAction)saveOptions:(id)sender
{
    [self playClickSound];
    
    [userDefaults setObject:[NSNumber numberWithBool:_weaponsSoundSwitch.on] forKey:@"kWeaponsSoundOn"];
    [userDefaults setObject:[NSNumber numberWithBool:_clicksSoundSwitch.on] forKey:@"kClickSoundOn"];
    [userDefaults setInteger:_winningScorePlayerVsComputer.value forKey:@"kPlayerVsComputerWinningScore"];
    [userDefaults setInteger:_winningScorePlayerVsPlayer.value forKey:@"kPlayerVsPlayerWinningScore"];
    
    switch ([UIDevice currentDevice].userInterfaceIdiom)
    {
        case UIUserInterfaceIdiomPad:
            [_delegate dismissPopover];
            break;
        case UIUserInterfaceIdiomPhone:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (IBAction)cancelOptions:(id)sender
{
    [self playClickSound];
    switch ([UIDevice currentDevice].userInterfaceIdiom)
    {
        case UIUserInterfaceIdiomPad:
            [_delegate dismissPopover];
            break;
        case UIUserInterfaceIdiomPhone:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}
@end
