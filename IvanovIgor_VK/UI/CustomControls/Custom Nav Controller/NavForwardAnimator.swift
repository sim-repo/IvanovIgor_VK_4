//
//  Animator.swift
//  Transitions
//
//  Created by Aliona on 15/10/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit

class NavForwardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let source = transitionContext.viewController(forKey: .from)
            else { return }
        guard let destination = transitionContext.viewController(forKey: .to)
            else { return }

        let destinationViewTargetFrame = source.view.frame

        transitionContext.containerView.addSubview(destination.view)

        destination.view.frame = CGRect(x: source.view.frame.width,
                                        y: source.view.frame.height/2,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)
        destination.view.transform = CGAffineTransform(rotationAngle: .pi/2)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 1)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: [.calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1){
                                       destination.view.transform = CGAffineTransform(rotationAngle:  -.pi*2)
                                       
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/2){
                                        destination.view.frame = destinationViewTargetFrame
                                    }
        }){ finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }

}
