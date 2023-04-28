//
//  InfoScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class InfoScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let gameController = self.view?.window?.rootViewController as? GameViewController else {
            fatalError("GameController not found")
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                if node.name == "backButton" {
                    if node.contains(touch.location(in: self)) {
                        gameController.back(from: self)
                    }
                } else if node.name == "homeButton" {
                    if node.contains(touch.location(in: self)) {
                        gameController.home(from: self)
                    }
                }
            }
        }
    }
    
    func setupBackground() {
        // Создайте фоновую картинку и добавьте ее на сцену
        let background = SKSpriteNode(imageNamed: "howToPlay")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func setupUI() {
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
