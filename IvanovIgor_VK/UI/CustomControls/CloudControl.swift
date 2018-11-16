import UIKit


class CloudControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getBezierPath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 41.26, y: 62.74))
        bezierPath.addLine(to: CGPoint(x: 116.58, y: 62.74))
        bezierPath.addCurve(to: CGPoint(x: 123.5, y: 62.72), controlPoint1: CGPoint(x: 116.58, y: 62.74), controlPoint2: CGPoint(x: 119.55, y: 62.99))
        bezierPath.addCurve(to: CGPoint(x: 136.01, y: 56.98), controlPoint1: CGPoint(x: 127.57, y: 62.43), controlPoint2: CGPoint(x: 132.67, y: 61.55))
        bezierPath.addCurve(to: CGPoint(x: 136.01, y: 36.44), controlPoint1: CGPoint(x: 142.61, y: 47.97), controlPoint2: CGPoint(x: 136.01, y: 36.44))
        bezierPath.addCurve(to: CGPoint(x: 119.35, y: 26.7), controlPoint1: CGPoint(x: 136.01, y: 36.44), controlPoint2: CGPoint(x: 130.81, y: 26.34))
        bezierPath.addCurve(to: CGPoint(x: 107.55, y: 31.75), controlPoint1: CGPoint(x: 107.9, y: 27.06), controlPoint2: CGPoint(x: 107.55, y: 31.75))
        bezierPath.addCurve(to: CGPoint(x: 82.22, y: 9.05), controlPoint1: CGPoint(x: 107.55, y: 31.75), controlPoint2: CGPoint(x: 103.39, y: 10.13))
        bezierPath.addCurve(to: CGPoint(x: 56.88, y: 26.7), controlPoint1: CGPoint(x: 61.05, y: 7.96), controlPoint2: CGPoint(x: 56.88, y: 26.7))
        bezierPath.addCurve(to: CGPoint(x: 41.26, y: 26.7), controlPoint1: CGPoint(x: 56.88, y: 26.7), controlPoint2: CGPoint(x: 49.59, y: 22.74))
        bezierPath.addCurve(to: CGPoint(x: 32.24, y: 36.44), controlPoint1: CGPoint(x: 32.93, y: 30.67), controlPoint2: CGPoint(x: 32.24, y: 36.44))
        bezierPath.addCurve(to: CGPoint(x: 14.68, y: 36.61), controlPoint1: CGPoint(x: 32.24, y: 36.44), controlPoint2: CGPoint(x: 22.32, y: 30.13))
        bezierPath.addCurve(to: CGPoint(x: 11.05, y: 54.77), controlPoint1: CGPoint(x: 7.05, y: 43.1), controlPoint2: CGPoint(x: 11.05, y: 54.77))
        bezierPath.addCurve(to: CGPoint(x: 20.14, y: 62.72), controlPoint1: CGPoint(x: 11.05, y: 54.77), controlPoint2: CGPoint(x: 14.24, y: 62.72))
        bezierPath.addCurve(to: CGPoint(x: 41.26, y: 62.74), controlPoint1: CGPoint(x: 26.04, y: 62.72), controlPoint2: CGPoint(x: 41.26, y: 62.74))
        bezierPath.close()
        return bezierPath
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let shadowColor = UIColor(red: 0.562, green: 0.000, blue: 1.000, alpha: 1.000)
        let color = UIColor(red: 0.244, green: 0.836, blue: 0.880, alpha: 1.000)
        
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 8, height: 4)
        shadow.shadowBlurRadius = 5
        
        let bezierPath = getBezierPath()
        
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        bezierPath.fill()
        context.restoreGState()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 4
        self.layer.addSublayer(shapeLayer)
        
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd) )
        anim1.fromValue = 0
        anim1.toValue = 1
        anim1.duration = 5.0
        anim1.fillMode = kCAFillModeForwards
        anim1.isRemovedOnCompletion = false
        shapeLayer.add(anim1, forKey: #keyPath(CAShapeLayer.strokeEnd) )
        
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.fillColor) )
        anim2.fromValue = color.cgColor
        anim2.toValue = UIColor.orange.cgColor
        anim2.duration = 5.0
        anim2.fillMode = kCAFillModeForwards
        anim2.isRemovedOnCompletion = false
        shapeLayer.add(anim2, forKey: #keyPath(CAShapeLayer.fillColor) )
    }
}
