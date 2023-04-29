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
}
