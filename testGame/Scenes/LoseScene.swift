//
//  LoseScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 28.04.2023.
//

import SpriteKit

class LoseScene: Scene {
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let gameController = self.view?.window?.rootViewController as? GameViewController else {
            fatalError("GameController not found")
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "backButton": gameController.back(from: self)
                    case "homeButton": gameController.home(from: self)
                    default: break
                }
            }
        }
    }
        
    func setupUI() {
        setBackground(with: "loseBackground")
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 55, y: frame.midY - 65)
        homeButton.zPosition = 1
        addChild(homeButton)
        
        // repeat button
        let reapeatButton = SKSpriteNode(imageNamed: "refreshButton")
        reapeatButton.name = "reapeatButton"
        reapeatButton.position = CGPoint(x: frame.midX, y: frame.midY - 65)
        reapeatButton.zPosition = 1
        addChild(reapeatButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX - 55, y: frame.midY - 65)
        infoButton.zPosition = 1
        addChild(infoButton)
    }
}
