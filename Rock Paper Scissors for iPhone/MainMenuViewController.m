//
//  MainMenuViewController.m
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/29/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import "MainMenuViewController.h"
#import "GameViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GameViewController *gameVC = (GameViewController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Popover"])
    {
        _optionsPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _optionsPopover.delegate = self;
        ((OptionsViewController *)((UINavigationController *)_optionsPopover.contentViewController).topViewController).delegate = self;
    }
    if ([segue.identifier isEqualToString:@"PvC"])
    {
        gameVC.gameMode = gameModePlayerVsComputer;
    }
    else if ([segue.identifier isEqualToString:@"PvP"])
    {
        gameVC.gameMode = gameModePlayerVsPlayer;
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

- (void)dismissPopover
{
    [_optionsPopover dismissPopoverAnimated:YES];
    NSNumber *clicksOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"kClickSoundOn"];
    if (clicksOn)
    {
        _clickSoundOn = clicksOn.boolValue;
    }
    else
    {
        _clickSoundOn = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    NSNumber *clicksOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"kClickSoundOn"];
    if (clicksOn)
    {
        _clickSoundOn = clicksOn.boolValue;
    }
    else
    {
        _clickSoundOn = YES;
    }
}

- (void)playClickSound
{
    if (_clickSoundOn)
    {
        [self.clickSound play];
    }
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.ad.hidden = YES;
    
    [self.view removeConstraint:self.viewBottomSpacing];
    
    self.viewBottomSpacing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.spacerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraint:self.viewBottomSpacing];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.ad.hidden = NO;
    
    [self.view removeConstraint:self.viewBottomSpacing];
    
    self.viewBottomSpacing = [NSLayoutConstraint constraintWithItem:self.ad attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.spacerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraint:self.viewBottomSpacing];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.ad.delegate = self;
    
    self.clickSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Click" withExtension:@"mp3"] error:nil];
    [self.clickSound prepareToPlay];
    
    [self.playerVsComputerButton addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventTouchDown];
    [self.playerVsPlayerButton addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventTouchDown];
    [self.optionsButton addTarget:self action:@selector(playClickSound) forControlEvents:UIControlEventTouchDown];
    
    UIImage *buttonFrame = [[[UIImage imageNamed:@"Button Image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.playerVsComputerButton setBackgroundImage:buttonFrame forState:UIControlStateNormal];
    self.playerVsComputerButton.tintColor = [UIColor redColor];
    
    [self.playerVsPlayerButton setBackgroundImage:buttonFrame forState:UIControlStateNormal];
    
    [self.optionsButton setBackgroundImage:buttonFrame forState:UIControlStateNormal];
    self.optionsButton.tintColor = [UIColor greenColor];
    
    switch ([UIDevice currentDevice].userInterfaceIdiom)
    {
        case UIUserInterfaceIdiomPad:
            self.playerVsComputerButton.contentEdgeInsets = UIEdgeInsetsMake(20, 90, 25, 90);
            self.playerVsPlayerButton.contentEdgeInsets = UIEdgeInsetsMake(20, 136, 25, 136);
            self.optionsButton.contentEdgeInsets = UIEdgeInsetsMake(20, 237, 25, 237);
            break;
        case UIUserInterfaceIdiomPhone:
            self.playerVsComputerButton.contentEdgeInsets = UIEdgeInsetsMake(12, 15, 15, 15);
            self.playerVsPlayerButton.contentEdgeInsets = UIEdgeInsetsMake(12, 39, 15, 39);
            self.optionsButton.contentEdgeInsets = UIEdgeInsetsMake(12, 94, 15, 94);
            break;
        default:
            break;
    }
    
    self.ad.hidden = YES;
    [self.view removeConstraint:self.viewBottomSpacing];
    self.viewBottomSpacing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.spacerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:self.viewBottomSpacing];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
