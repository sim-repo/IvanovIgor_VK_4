//
//  LikeControl.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 01.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit


@IBDesignable class LikeView: UIView {
    
    private var hasLike = false
    var color = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1.000)
    var votes: UILabel?
    
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        return recognizer
    }()
    
    @objc func onTap() {
        hasLike = !hasLike
        var sign: Int = 1
        let numb = Int( (votes?.text)!)
        
        if hasLike {
           color = UIColor(red: 0.826, green: 0.200, blue: 0.200, alpha: 1.000)
           
        } else {
           color = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1.000)
           sign = numb == 0 ? 0 : -1
        }
        if let numb = numb {
            votes?.text = String(numb + sign)
        }
        votes?.textColor = color
        self.setNeedsDisplay()
    }

    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.addGestureRecognizer(tapGestureRecognizer)
        let context = UIGraphicsGetCurrentContext()!
        
        let shadowColor = UIColor(red: 0.879, green: 0.784, blue: 0.784, alpha: 1.000)
        
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 5, height: 2)
        shadow.shadowBlurRadius = 5
        

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 22.68, y: 10.42))
        bezierPath.addLine(to: CGPoint(x: 12.5, y: 6.5))
        bezierPath.addLine(to: CGPoint(x: 5.5, y: 10.42))
        bezierPath.addLine(to: CGPoint(x: 5.5, y: 19.84))
        bezierPath.addLine(to: CGPoint(x: 22.68, y: 37.5))
        bezierPath.addLine(to: CGPoint(x: 40.5, y: 19.84))
        bezierPath.addLine(to: CGPoint(x: 40.5, y: 10.42))
        bezierPath.addLine(to: CGPoint(x: 32.55, y: 6.5))
        bezierPath.addLine(to: CGPoint(x: 22.68, y: 10.42))
        bezierPath.close()
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        color.setFill()
        bezierPath.fill()
        context.restoreGState()
        
        UIColor.gray.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
    }

}
