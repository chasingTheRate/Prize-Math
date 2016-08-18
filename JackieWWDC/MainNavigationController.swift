//
//  MainNavigationController.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/2/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//


/*
Code written below orginally created by Robert Ryan and modified for use in Prize Math.
https://github.com/robertmryan/Interactive-Custom-Transitions-in-Swift
*/

import UIKit

@objc protocol MainNavigationControllerDelegate {
    func performSegue()
}



class MainNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    let colors = Colors()
    var navProgressBar: UIProgressView!
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self   // for presenting the original navigation controller
        delegate = self                // for navigation controller custom transitions
        
        //let left = UIScreenEdgePanGestureRecognizer(target: self, action: "handleSwipeFromLeft:")
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeFromLeft))
        
        left.edges = .Left
        self.view.addGestureRecognizer(left);
        
        //let right = UIScreenEdgePanGestureRecognizer(target: self, action: "handleSwipeFromRight:")
        let right = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeFromRight))
        
        right.edges = .Right
        self.view.addGestureRecognizer(right);
        
        //Progress Bar
        
        navProgressBar = UIProgressView(frame: CGRect.zero)
        updateProgressBar()
        
        self.navigationBar.addSubview(navProgressBar!)
        navProgressBar!.trackTintColor = UIColor.clearColor()
        navProgressBar!.progressTintColor = colors.primaryColor[0]
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        self.popToRootViewControllerAnimated(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition(nil) { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.updateProgressBar()
        }
    }
    
    func updateProgressBar(){
        navProgressBar.frame = CGRect(x: 0, y: self.navigationBar.bounds.height, width: self.navigationBar.bounds.width, height: 2)
    }

    func handleSwipeFromLeft(gesture: UIScreenEdgePanGestureRecognizer) {
        let percent = gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        if gesture.state == .Began {
            interactionController = UIPercentDrivenInteractiveTransition()
            if viewControllers.count > 1 {
                popViewControllerAnimated(true)
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        } else if gesture.state == .Changed {
            interactionController?.updateInteractiveTransition(percent)
        } else if gesture.state == .Ended {
            if percent > 0.5 {
                interactionController?.finishInteractiveTransition()
            } else {
                interactionController?.cancelInteractiveTransition()
            }
            interactionController = nil
        }
    }
    
    func handleSwipeFromRight(gesture: UIScreenEdgePanGestureRecognizer) {
        let percent = -gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        if gesture.state == .Began {
            if let currentViewController = viewControllers.last as? MainNavigationControllerDelegate {
                interactionController = UIPercentDrivenInteractiveTransition()
                currentViewController.performSegue()
            }
        } else if gesture.state == .Changed {
            interactionController?.updateInteractiveTransition(percent)
        } else if gesture.state == .Ended {
            if percent > 0.5 {
                interactionController?.finishInteractiveTransition()
            } else {
                interactionController?.cancelInteractiveTransition()
            }
            interactionController = nil
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ForwardAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BackAnimator()
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            return ForwardAnimator()
        }else if operation == .Pop {
            return BackAnimator()
        }
        
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}

class ForwardAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        let toView = context.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
        
        context.containerView()?.addSubview(toView!)
        
        let viewWidth = context.containerView()?.bounds.width
        
        toView?.frame.origin.x = viewWidth!
        toView?.alpha = 0.5
        
        UIView.animateWithDuration(transitionDuration(context), animations: {
            toView?.frame.origin.x = 0
            toView?.alpha = 1
            
            return
            }, completion: { finished in
                context.completeTransition(!context.transitionWasCancelled())
        })
    }
    
}

class BackAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        let toView = context.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
        let fromView = context.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        
        let viewWidth = toView!.bounds.width
        
        context.containerView()?.insertSubview(toView!, belowSubview: fromView!)
        
        UIView.animateWithDuration(transitionDuration(context), animations: {
            fromView?.frame.origin.x = viewWidth
            fromView?.alpha = 0.5
            return
            }, completion: { finished in
                context.completeTransition(!context.transitionWasCancelled())
        })
    }
}


