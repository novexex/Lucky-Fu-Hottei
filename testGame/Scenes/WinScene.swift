//
//  WinScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 28.04.2023.
//

import SpriteKit

class WinScene: Scene {
    let score: Int
    let level: Int
    
    init(size: CGSize, score: Int, level: Int) {
        self.score = score
        self.level = level
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupUI()
        setupMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "nextLevelButton":
                        let action = SKAction.run {
                            self.level <= 4 ? self.gameController.startGame(level: self.level+1) : self.gameController.startGame(level: self.level)
                        }
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, action])
                        self.run(sequence)
                    case "infoButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.showInfo() }])
                        self.run(sequence)
                    case "refreshButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.startGame(level: self.level) }])
                        self.run(sequence)
                    case "homeButton":
                    	let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.home() }])
                    	self.run(sequence)
                    default: break
                }
            }
        }
    }
    
    private func setupUI() {
        setBackground(with: "winBackground")
        
        let plusLabel = ASAttributedLabelNode(size: CGSize(width: 50, height: 50))
        plusLabel.attributedString = getAttrubutedString(with: "+", font: "Montserrat-ExtraBold", size: 50)
        plusLabel.position = CGPoint(x: frame.midX - 40, y: frame.midY - 100)
        addChild(plusLabel)

        // scoreLabel
        let scoreLabel = ASAttributedLabelNode(size: CGSize(width: 200, height: 100))
        scoreLabel.attributedString = getAttrubutedString(with: String(score), font: "gangOfThree", size: 58)
        scoreLabel.position = CGPoint(x: plusLabel.frame.midX + 110, y: plusLabel.frame.midY)
        addChild(scoreLabel)
        
        // nextLevel button
        let nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButton")
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.position = CGPoint(x: frame.midX, y: scoreLabel.frame.minY - 35)
        addChild(nextLevelButton)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 55, y: nextLevelButton.frame.minY - 40)
        addChild(homeButton)
        
        // repeat button
        let reapeatButton = SKSpriteNode(imageNamed: "refreshButton")
        reapeatButton.name = "refreshButton"
        reapeatButton.position = CGPoint(x: frame.midX, y: nextLevelButton.frame.minY - 40)
        addChild(reapeatButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX - 55, y: nextLevelButton.frame.minY - 40)
        addChild(infoButton)
    }
}
