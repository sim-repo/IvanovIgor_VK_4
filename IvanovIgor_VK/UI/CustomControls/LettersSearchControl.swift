//
//  AlphabetSearchControl.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 01.10.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit

enum Alphabet: Int, CaseIterable {
    case А,Б,В,Г,Д,Е,Ж,З,И,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ы,Э,Ю,Я,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,Å
    static let titles: [Character] = ["А","Б","В","Г","Д","Е","Ж","З","И","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Ы","Э","Ю","Я","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","Å"]

    static func convert(by char: Character) -> Alphabet {
        let index = Alphabet.titles.firstIndex(of: char) ?? Å.rawValue
        return Alphabet(rawValue: index)!
    }
    
    static func getLetter(with stroke: String)->Alphabet {
        let ch = stroke.uppercased().first ?? "Å"
        return Alphabet.convert(by: ch)
    }
    
    static func getOffsets(with strokes: [String]) -> ([Alphabet], [Int]) {
         var letters:[Alphabet] = []
        var offsets:[Int] = []
        
        for (idx, stroke) in strokes.enumerated() {
            let letter = getLetter(with: stroke)
            if !letters.contains(letter) {
                offsets.append(idx)
                letters.append(letter)
            }
        }
        return (letters, offsets)
    }
}



// Протокол таргетного UIView в кач-ве делегата
public protocol AlphabetSearchViewControlProtocol : class {
    func didChange(indexPath: IndexPath)
    func getView()->UIView
    func didEndTouch()
}



// Reusable-Класс для автоматического скроллинга страницы.
// Размещается вертикально на таргетный UIView.
// Отображает буквы-алфавита (кнопки), которые обрабатываются
// эти классом при нажатии или перемещеннии (touchesMoved) по ним

@IBDesignable class LettersSearchControl : UIControl{
    private var buttons: [UIButton] = []
    
    // содержит subStackViews
    // каждый из которых хранит одну букву и разделитель
    private var stackView: UIStackView!
    
    // таргетированный UIView
    var delegate: AlphabetSearchViewControlProtocol?
    
    // содержит соответствие буквы и топового индекса группы строк,
    // начинающиеся на данную букву.
    private var indexes: [Alphabet:IndexPath] = [:]
    
    private var selectedButton: UIButton?
    private var previousTouchPoint: CGPoint?
    
    @IBInspectable var fontSize: CGFloat = 10 {
        didSet {
            if fontSize >= 8 {
                changeButtonFont()
            }
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
    
    private func changeButtonFont(){
        for button in buttons {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            setNeedsDisplay()
        }
    }
    
    // MARK: - Outside Invoked Function
    // Фун-я, вызываемые из таргетном UIView.
    
    // Вызов, когда в таргетном UIView обновилась модель.
    // Обновление списка Алфавита.
    public func updateControl(with properties: [String]?) {

        guard  let _properties = properties else {return}
        
        let (actualLetters, _) = Alphabet.getOffsets(with: _properties)
        self.updateControl(with: Array(actualLetters))
        self.setIndexes(with: actualLetters)
    }
   
    
    // Фун-я для актуализации видимости subStackViews
    private func updateControl(with actualLetters: [Alphabet]){
        
        for subStackView in stackView.arrangedSubviews {
            if let stack = subStackView as? UIStackView {
                stack.isHidden = true
            }
        }
        
        for letter in actualLetters {
            if let stack = stackView.arrangedSubviews[letter.rawValue] as? UIStackView {
                stack.isHidden = false
            }
        }
    }
    
    
    
    // Фун-я для получения топовых индексов из
    // исходного списка строк
    private func setIndexes(with actualLetters: [Alphabet] ){
        for (idx, letter) in actualLetters.enumerated() {
            indexes[letter] = IndexPath(item: 0, section: idx)
        }
    }

    
    // Фун-я инициализации контрола
    private func setupView(){
        
        var subStackViews:[UIStackView] = []
        
        for ch in Alphabet.titles {
            
            var subView :[UIView] = []
            
            let button = UIButton(type: .system)
            button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: fontSize)
            button.setTitle(String(ch), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.isEnabled = false
            self.buttons.append(button)
            subView.append(button)
            
            let subStackView = UIStackView(arrangedSubviews: subView)
            subStackView.axis = .vertical
            subStackView.alignment = .center
            subStackView.distribution = .fillEqually
            subStackViews.append(subStackView)
            
        }
        
        stackView = UIStackView(arrangedSubviews: subStackViews)
        self.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
    }
    
    
    func didSelectButton(_ sender: UIButton) {
        guard let index = self.buttons.index(of: sender) else { return }
        guard let letter = Alphabet(rawValue: index) else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if let indexPath = indexes[letter] {
            delegate?.didChange(indexPath: indexPath)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}


// Обработка событий непрерывного перемещения пальца по контролу
extension LettersSearchControl: UIGestureRecognizerDelegate {
    
    private func checkTouch(_ location: CGPoint){
        previousTouchPoint = location
        
        for button in buttons {
            // координаты кнопки как CGRect в системе координат таргетного UIView
            let rect = button.convert(button.frame, from: delegate?.getView())
            
            // проверка пальца (x,y) внутрь фрейма кнопки
            if abs(rect.origin.x) <= location.x &&
                abs(rect.origin.y) <= location.y &&
                abs(rect.origin.x) + rect.width >= location.x &&
                abs(rect.origin.y) + rect.height >= location.y {
                if selectedButton != button {
                    selectedButton = button
                    didSelectButton(button)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            // текущие (x,y) пальца в системе координат таргентного UIView
            let location = touch.location(in: delegate?.getView())
            guard location != previousTouchPoint ?? CGPoint.zero else {return}
            checkTouch(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            // текущие (x,y) пальца в системе координат таргентного UIView
            let location = touch.location(in: delegate?.getView())
          
            guard location != previousTouchPoint ?? CGPoint.zero else {return}

            checkTouch(location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedButton = nil
        previousTouchPoint = nil
        delegate?.didEndTouch()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedButton = nil
        previousTouchPoint = nil
    }
}
