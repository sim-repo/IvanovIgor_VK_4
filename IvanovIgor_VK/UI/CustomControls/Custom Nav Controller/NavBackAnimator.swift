import UIKit

class NavBackAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from)
            else { return }
        guard let destination = transitionContext.viewController(forKey: .to)
            else { return }
        
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.addSubview(source.view)
        
        
        
        destination.view.frame = source.view.frame
        
        source.view.layer.anchorPoint = CGPoint(x: 1, y: 1)
        source.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: source.view.frame.width,
                                   height: source.view.frame.height)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: [.calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/2){
                                        source.view.transform = CGAffineTransform(rotationAngle:  .pi/2)
                                    }
        }){ finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
}
