import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                              action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]

            viewController?.view.addGestureRecognizer(recognizer)
        }
    }

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {

        switch recognizer.state {

        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)

        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))

            self.shouldFinish = progress > 0.33
            self.update(progress)

        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()

        case .cancelled:
            self.hasStarted = false
            self.cancel()
            
        default: return
        }
    }

}
