//
//  InfoScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class InfoScene: Scene {
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
        setBackground(with: "infoBackground")
        
        // back button
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "backButton"
        backButton.position = CGPoint(x: frame.midX - 27, y: frame.minY + 170)
        backButton.zPosition = 1
        addChild(backButton)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 27, y: frame.minY + 170)
        homeButton.zPosition = 1
        addChild(homeButton)
    }
}
