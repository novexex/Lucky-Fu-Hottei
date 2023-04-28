//
//  TreasuryScreen.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class TreasuryScene: SKScene {
    
    var score = 0
    
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
                if node.name == "infoButton" {
                        gameController.showInfo(from: self)
                } else if node.name == "homeButton" {

                        gameController.home(from: self)
                }
            }
        }
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "treasuryBackGround")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func setupUI() {
        
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cup")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.midY + 300)
        cupLabel.zPosition = 1
        addChild(cupLabel)
        
        //score label
        let scoreLabel = SKLabelNode(text: String(score))
        scoreLabel.fontName = "gangOfThree"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 80, y: cupLabel.position.y - 15)
        addChild(scoreLabel)
        
        //home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX - 27, y: frame.minY + 120)
        addChild(homeButton)
        
        //info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX + 27, y: frame.minY + 120)
        addChild(infoButton)

    }
}
