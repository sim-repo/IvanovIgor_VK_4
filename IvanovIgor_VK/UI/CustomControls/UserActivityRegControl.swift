import UIKit

// Задание 6.2 + 6.3 : анимация >>>
// Класс для реализации различных ивентов для картинок



enum UserActivityType {
    case like
    case share
    case comment
    case look
}

class UserActivityRegControl: UIImageView {
    
    private var activated = false
    var boundMetrics: UILabel?
    var color = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1.000)
    var userActivityType: UserActivityType?
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        return recognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func onTap() {
        activated = !activated
        guard let activity = userActivityType else {
            return
        }
        switch activity {
            case .like: // 6.3
                doLike()
            case .look: // 6.2
                doLook()
            default:
                doLook()
        }
    }
    
    func rotateImage() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 1/3*CGFloat.pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 2/3*CGFloat.pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 3/3*CGFloat.pi)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 4/3*CGFloat.pi)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
            })
        }, completion: {_ in
            self.transform = .identity
        })
    }
    
    func doLike(){
        var sign: Int = 1
        let numb = Int( (boundMetrics?.text)!)
        rotateImage()
        if activated {
            color = UIColor(red: 0.826, green: 0.200, blue: 0.200, alpha: 1.000)
            
        } else {
            color = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1.000)
            sign = numb == 0 ? 0 : -1
        }
        if let numb = numb {
            boundMetrics?.text = String(numb + sign)
        }
        boundMetrics?.textColor = color
    }
    
    func doLook(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 3
        animation.fromValue = 0.8
        animation.toValue = 1
        animation.initialVelocity = 10
        animation.damping = 5.0
        animation.fillMode = kCAFillModeBackwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime()
        self.layer.add(animation, forKey: "transform.scale")
    }
    
 
}
