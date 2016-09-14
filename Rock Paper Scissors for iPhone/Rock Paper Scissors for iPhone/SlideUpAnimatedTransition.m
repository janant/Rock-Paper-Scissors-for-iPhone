//
//  SlideUpAnimatedTransition.m
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 12/28/13.
//  Copyright (c) 2013 Anant Jain. All rights reserved.
//

#import "SlideUpAnimatedTransition.h"

@implementation SlideUpAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGRect screenSize = [UIScreen mainScreen].bounds;
    
    if (self.presenting)
    {
        toViewController.view.frame = CGRectMake(0, CGRectGetHeight(screenSize) * 0.35, CGRectGetWidth(screenSize), CGRectGetHeight(screenSize) * 0.75);
        toViewController.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(screenSize) * 0.65 - 44);
        [container addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:30 initialSpringVelocity:32 options:UIViewAnimationOptionCurveEaseIn animations:^{
            toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(screenSize) * 0.65 - 44);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
