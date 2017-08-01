//
//  SlideUpPresentation.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/29/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import UIKit

class SlideUpPresentation: UIPresentationController {
    
    let shadowView = UIView()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let presentingFrame = presentingViewController.view.frame
        let visibleHeight: CGFloat = 165
        
        return CGRect(x: 0, y: presentingFrame.height - visibleHeight, width: presentingFrame.width, height: visibleHeight + 40)
    }
    
    override func presentationTransitionWillBegin() {
        // Sets up shadow view and adds to container view
        shadowView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        shadowView.frame = presentingViewController.view.frame
        shadowView.alpha = 0.0
        
        if let container = self.containerView {
            container.addSubview(shadowView)
            container.addSubview(presentedViewController.view)
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                self.shadowView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            shadowView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                self.shadowView.alpha = 0.0
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            shadowView.removeFromSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            self.shadowView.frame = self.presentingViewController.view.frame
        }, completion: nil)
    }
}
