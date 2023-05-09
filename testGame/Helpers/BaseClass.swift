//
//  BaseClass.swift
//  testGame
//
//  Created by Artour Ilyasov on 29.04.2023.
//

import SpriteKit

class Scene: SKScene {
    weak var gameController: GameViewController!
    
    func setBackground(with imageNamed: String) {
        let background = SKSpriteNode(imageNamed: imageNamed)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func getAttrubutedString(with text: String, font: String = "gangOfThree", size: CGFloat = 58, alignment: NSTextAlignment? = nil) -> NSMutableAttributedString {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 3.9520199298858643)
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.65)
        shadow.shadowBlurRadius = 12.927276611328125
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: font, size: size) ?? UIFont(),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.29,
            .strokeColor: UIColor(hex: "ECB43C"),
            .shadow: shadow
        ]
        
        if let alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}
