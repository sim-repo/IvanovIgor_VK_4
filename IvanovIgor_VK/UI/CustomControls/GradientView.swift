import UIKit

@IBDesignable class GradientView: UIView {
    @IBInspectable var isHorizontal: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var firstColor2: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor2: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor2, secondColor2].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0.25, y: 0)
            layer.endPoint = CGPoint (x: 0.7, y: 0.75)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }

    }
}
