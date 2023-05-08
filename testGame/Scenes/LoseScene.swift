//
//  LoseScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 28.04.2023.
//

import SpriteKit

class LoseScene: Scene {
    // MARK: Initializing propertys
    let level: Int
    
    // MARK: Initializators
    init(size: CGSize, level: Int) {
        self.level = level
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                    case "homeButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.home() }])
                        self.run(sequence)
                    case "refreshButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.startGame(level: self.level) }])
                        self.run(sequence)
                    case "infoButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.showInfo() }])
                        self.run(sequence)
                    default: break
                }
            }
        }
    }
    
    // MARK: Private methods
    private func setupUI() {
        setBackground(with: "loseBackground")
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 55, y: frame.midY - 65)
        addChild(homeButton)
        
        // repeat button
        let reapeatButton = SKSpriteNode(imageNamed: "refreshButton")
        reapeatButton.name = "refreshButton"
        reapeatButton.position = CGPoint(x: frame.midX, y: frame.midY - 65)
        addChild(reapeatButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX - 55, y: frame.midY - 65)
        addChild(infoButton)
    }
}
