//
//  ProfileImageControl.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 01.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImage: UIView {
   
    var image: UIImage? = UIImage() {
        willSet{
            imageView.image? = newValue!
        }
    }
    
    var imageView = UIImageView()
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        willSet{
            if newValue != 0  {
                self.layer.cornerRadius = self.layer.bounds.height/2
            } else {
                self.layer.cornerRadius = self.layer.bounds.height/2
                
            }
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet{
            changeShadowColor()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            cahngeShadowOpacity()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 20 {
        didSet{
            changeShadowRadius()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet{
            changeShadowOffset()
        }
    }
    
    private func changeShadowColor(){
        self.layer.shadowColor = self.shadowColor.cgColor
    }
    
    private func cahngeShadowOpacity(){
        self.layer.shadowOpacity = self.shadowOpacity
    }
    
    private func changeShadowRadius(){
        self.layer.shadowRadius = self.shadowRadius
    }
    
    private func changeShadowOffset(){
        self.layer.shadowOffset = self.shadowOffset
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.layer.masksToBounds = false
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.layer.bounds.height/2
        self.shadow()
        self.setImage()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        self.contentMode = .scaleAspectFill
        self.setImage()
        self.shadow()
    }
    
    func shadow() {
        self.changeShadowColor()
        self.changeShadowOffset()
        self.changeShadowRadius()
        self.cahngeShadowOpacity()
    }
    
    private func setImage() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        imageView.image = self.image
        let roundMask = CAShapeLayer()
        let round = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        roundMask.path = round.cgPath
        imageView.layer.mask = roundMask
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
    }
}
