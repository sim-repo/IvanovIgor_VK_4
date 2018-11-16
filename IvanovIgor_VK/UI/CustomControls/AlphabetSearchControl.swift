//
//  AlphabetSearchControl.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 01.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

enum Alphabet: Int {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
    static let allSymbols: [Alphabet] = [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]
    
    var title: String {
        switch self {
        case .a: return "a"
        case .b: return "b"
        case .c: return "c"
        case .d: return "d"
        case .e: return "e"
        case .f: return "f"
        case .g: return "g"
        case .h: return "h"
        case .i: return "i"
        case .j: return "j"
        case .k: return "k"
        case .l: return "l"
        case .m: return "m"
        case .n: return "n"
        case .o: return "o"
        case .p: return "p"
        case .q: return "q"
        case .r: return "r"
        case .s: return "s"
        case .t: return "t"
        case .u: return "u"
        case .v: return "v"
        case .w: return "w"
        case .x: return "x"
        case .y: return "y"
        case .z: return "z"
        }
    }
}


@IBDesignable class LettersSearchControl : UIControl{
    private var buttons: [UIView] = []
    private var stackView: UIStackView!
    var delegate: FriendFilterDelegate!
    private var actualLetters: [Alphabet]?
    
    var selectedSymbol: Alphabet? = nil {
        didSet {
            self.updateSelectedDay()
            self.sendActions(for: .valueChanged)
           
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    public func updateControl(with actualLetters: [Alphabet]){
        
       
        
        for letter in actualLetters {
            if let stack = stackView.arrangedSubviews[letter.rawValue] as? UIStackView {
                stack.isHidden = true
            }
        }
        
    }
    
    private func setupView(){
        
        var subStackViews:[UIStackView] = []
        
        for symbol in Alphabet.allSymbols {
            
            var subView :[UIView] = []
            
            let button = UIButton(type: .system)
            button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 8)
            button.setTitle(symbol.title, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectSymbol(_:)), for: .touchUpInside)
            self.buttons.append(button)
            
            subView.append(button)
            let delimiterLabel = UILabel()
            delimiterLabel.text = "・"
            self.buttons.append(delimiterLabel)
            subView.append(delimiterLabel)
            
            let subStackView = UIStackView(arrangedSubviews: subView)
            subStackView.spacing = 5
            subStackView.axis = .vertical
            subStackView.alignment = .center
            subStackView.distribution = .fillEqually
            subStackViews.append(subStackView)
            
            subStackView.isHidden = true
            
        }
        
        
        stackView = UIStackView(arrangedSubviews: subStackViews)
        self.addSubview(stackView)
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually

    }
    
    
    
    
    @objc private func selectSymbol(_ sender: UIButton) {
        guard let index = self.buttons.index(of: sender) else { return }
        guard let symbol = Alphabet(rawValue: index) else { return }
        self.selectedSymbol = symbol
        delegate.filterFriend(by: self.selectedSymbol!)
    }
    
    private func updateSelectedDay() {
        for (index, button) in self.buttons.enumerated() {
            guard let symbol = Alphabet(rawValue: index) else { continue }
            if let b = button as? UIButton {
                b.isSelected = symbol == self.selectedSymbol
            }
        }
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}
