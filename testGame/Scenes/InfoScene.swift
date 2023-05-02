//
//  InfoScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class InfoScene: Scene {
    // MARK: Overrided methods
    override func didMove(to view: SKView) {
        setupUI()
        setupMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "backButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.back() }])
                        self.run(sequence)
                    case "homeButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.home() }])
                        self.run(sequence)
                    default: break
                }
            }
        }
    }
    
    // MARK: Private methods
    private func setupUI() {
        setBackground(with: "infoBackground")
        
        // back button
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "backButton"
        backButton.position = CGPoint(x: frame.midX - 27, y: frame.minY + 170)
        addChild(backButton)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 27, y: frame.minY + 170)
        addChild(homeButton)
    }
}
