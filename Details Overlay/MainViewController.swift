//
//  MainViewController.swift
//  Details Overlay
//
//  Created by David Ruisinger on 20.04.15.
//  Copyright (c) 2015 flavordaaave. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var count: Int = 0
    
    @IBAction func show(sender: UIButton) {
        showDetails()
    }

    @IBAction func hide(sender: UIButton) {
        dismissDetails()
    }
    
    var detailsController: DetailsViewController!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the animator
        animator = UIDynamicAnimator(referenceView: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createDetails() {
        // Here the detailsController and it's view are created and initiated
        let detailsWidth: CGFloat = view.bounds.width
        let detailsHeight: CGFloat = 150
        let detailsViewFrame: CGRect = CGRectMake(0, view.bounds.height, detailsWidth, detailsHeight)
        
        detailsController = storyboard?.instantiateViewControllerWithIdentifier("details") as! DetailsViewController
        detailsController.descriptionText = "I'm the text #\(count), that was passed from the MainViewController"
        count++
        
        self.addChildViewController(detailsController)
        detailsController.view.frame = detailsViewFrame
        view.addSubview(detailsController.view)
        detailsController.didMoveToParentViewController(self)
    }
    
    func showDetails() {
        // Create the details if they are not already there
        if (detailsController == nil) {
            createDetails()
        
            // Create a gesture recognizer for the details so that the user can drag the details to dismiss them
            createGestureRecognizer()
            
            animator.removeAllBehaviors()
            
            // Animate the details view using UIKit Dynamics
            var snapBehaviour: UISnapBehavior = UISnapBehavior(item: detailsController.view, snapToPoint: CGPoint(x: view.bounds.width/2, y: view.bounds.height-detailsController.view.bounds.height/2))
            animator.addBehavior(snapBehaviour)
        } else {
            dismissDetails()
            
            
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(0.4 * Double(NSEC_PER_SEC))
                ),
                
                dispatch_get_main_queue(), {
                    self.createDetails()
                    
                    // Create a gesture recognizer for the details so that the user can drag the details to dismiss them
                    self.createGestureRecognizer()
                    
                    self.animator.removeAllBehaviors()
                    
                    // Animate the details view using UIKit Dynamics
                    var snapBehaviour: UISnapBehavior = UISnapBehavior(item: self.detailsController.view, snapToPoint: CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - self.detailsController.view.bounds.height/2))
                    self.animator.addBehavior(snapBehaviour)
            })
        }
    }
    
    func dismissDetails() {
        if (detailsController != nil) {
            animator.removeAllBehaviors()
            
            // Again use UIKit Dynamics to animate the details out of the visible area
            var gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [detailsController.view])
            gravityBehaviour.gravityDirection = CGVectorMake(0.0, 10.0)
            animator.addBehavior(gravityBehaviour)
            
            var itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [detailsController.view])
            itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), forItem: detailsController.view)
            animator.addBehavior(itemBehaviour)
            
            // I waint 400ms until the view is animated out of the visible area and then completely kill/remove controller and the view
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(0.4 * Double(NSEC_PER_SEC))
                ),
                
                dispatch_get_main_queue(), {
                    //self.detailsController.view.removeFromSuperview()
                    self.detailsController.removeFromParentViewController()
                    self.detailsController = nil
            })
        }
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        detailsController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // This function handles the dragging on the detailsView
    // I took the code from this tutorial here: http://www.sitepoint.com/using-uikit-dynamics-swift-animate-apps/
    func handlePan(sender: UIPanGestureRecognizer) {
        if (detailsController != nil && sender.translationInView(view).y > 0) {
            let panLocationInView = sender.locationInView(view)
            let panLocationInAlertView = sender.locationInView(detailsController.view)
            
            if sender.state == UIGestureRecognizerState.Began {
                animator.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInAlertView.x - CGRectGetMidX(detailsController.view.bounds), panLocationInAlertView.y - CGRectGetMidY(detailsController.view.bounds));
                attachmentBehavior = UIAttachmentBehavior(item: detailsController.view, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.Changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.Ended {
                animator.removeAllBehaviors()
                
                snapBehavior = UISnapBehavior(item: detailsController.view, snapToPoint: CGPoint(x: view.bounds.width/2, y: view.bounds.height-detailsController.view.bounds.height/2))
                animator.addBehavior(snapBehavior)
                
                if sender.translationInView(view).y > 70 {
                    dismissDetails()
                }
            }
        }
        
    }






}

