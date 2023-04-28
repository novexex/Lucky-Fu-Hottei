//
//  WinScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 28.04.2023.
//

import SpriteKit

class WinScene: SKScene {
    
    var score = 1
    
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
        let background = SKSpriteNode(imageNamed: "winScreen")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func setupUI() {
        // dynamic offset
        var offset = 10
        offset *= String(score).count
        
        // plus label
        let plusLabel = SKLabelNode(text: "+")
        plusLabel.fontSize = 50
        plusLabel.position = CGPoint(x: frame.midX - CGFloat(offset), y: frame.minY + 313)
        addChild(plusLabel)
        
        // scoreLabel
        let scoreLabel = SKLabelNode(text: String(score))
        scoreLabel.fontName = "gangOfThree"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: frame.midX + CGFloat(offset), y: frame.minY + 310)
        addChild(scoreLabel)
        
        // nextLevel button
        let nextLevelButton = SKSpriteNode(imageNamed: "nextLevel")
        nextLevelButton.name = "nextLevel"
        nextLevelButton.position = CGPoint(x: frame.midX, y: scoreLabel.frame.minY - 60)
        nextLevelButton.zPosition = 1
        addChild(nextLevelButton)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 55, y: nextLevelButton.frame.minY - 40)
        homeButton.zPosition = 1
        addChild(homeButton)
        
        // repeat button
        let reapeatButton = SKSpriteNode(imageNamed: "refreshButton")
        reapeatButton.name = "reapeatButton"
        reapeatButton.position = CGPoint(x: frame.midX, y: nextLevelButton.frame.minY - 40)
        reapeatButton.zPosition = 1
        addChild(reapeatButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX - 55, y: nextLevelButton.frame.minY - 40)
        infoButton.zPosition = 1
        addChild(infoButton)
    }
}
