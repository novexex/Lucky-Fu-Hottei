//
//  LoseScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 28.04.2023.
//

import SpriteKit

class LoseScene: SKScene {
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
        let background = SKSpriteNode(imageNamed: "loseScreen")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func setupUI() {
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
