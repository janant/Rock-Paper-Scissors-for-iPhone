//
//  SlideUpTransition.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/29/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import UIKit

class SlideUpTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presenting ? 0.4 : 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            presentAnimation(using: transitionContext)
        }
        else {
            dismissAnimation(using: transitionContext)
        }
    }
    
    func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? MenuViewController,
            let fromVC = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Translation adjustment
        var adjustment: CGFloat = toVC.menuToolbar.frame.height // Toolbar height
        if #available(iOS 11, *) { // Safe area
            adjustment += fromVC.view.safeAreaInsets.bottom
        }
        
        // Sets up frame for toVC
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.transform = CGAffineTransform(translationX: 0, y: Constants.UIFrames.MenuVisibleHeight - adjustment)
        
        // Slides upward
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 15, options: .curveEaseInOut, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }) { (completed) in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? MenuViewController,
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Translation adjustment
        var adjustment: CGFloat = fromVC.menuToolbar.frame.height // Toolbar height
        if #available(iOS 11, *) { // Safe area
            adjustment += toVC.view.safeAreaInsets.bottom
        }
        
        // Slides back down
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn, animations: { 
            fromVC.view.transform = CGAffineTransform(translationX: 0, y: Constants.UIFrames.MenuVisibleHeight - adjustment)
        }) { (completed) in
            transitionContext.completeTransition(true)
        }
    }
}
