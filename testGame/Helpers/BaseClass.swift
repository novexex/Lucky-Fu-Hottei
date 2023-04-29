//
//  BaseClass.swift
//  testGame
//
//  Created by Artour Ilyasov on 29.04.2023.
//

import SpriteKit

class Scene: SKScene {
    
    func setBackground(with imageNamed: String) {
        let background = SKSpriteNode(imageNamed: imageNamed)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func getGameController() -> GameViewController {
        guard let gameController = self.view?.window?.rootViewController as? GameViewController else {
            fatalError("GameController not found")
        }
        return gameController
    }
    
    func getAttrubutedString(with text: String) -> NSMutableAttributedString {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 3.9520199298858643)
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.65)
        shadow.shadowBlurRadius = 12.927276611328125
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "gangOfThree", size: 58) ?? UIFont(),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.29,
            .strokeColor: UIColor(hex: "ECB43C"),
            .shadow: shadow
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}
