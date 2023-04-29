//
//  TreasuryScreen.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class TreasuryScene: Scene {
    
    var score = 0
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameController = getGameController()
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "infoButton": gameController.showInfo()
                    case "homeButton": gameController.home()
                    default: break
                }
            }
        }
    }
    
    private func setupUI() {
        setBackground(with: "treasuryBackground")
        
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cupLabel")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.midY + 300)
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
