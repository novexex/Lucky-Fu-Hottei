//
//  LevelScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class LevelSelectScene: Scene {

    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    var score = 0 {
        didSet {
            scoreLabel.attributedString = getAttrubutedString(with: String(score))
        }
    }
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "levelBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameController = getGameController()
            for touch in touches {
                let location = touch.location(in: self)
                if let node = atPoint(location) as? SKSpriteNode {
                    switch node.name {
                        case "level1Button": gameController.startGame(level: 1)
                        case "level2Button": gameController.startGame(level: 2)
                        case "level3Button": gameController.startGame(level: 3)
                        case "level4Button": gameController.startGame(level: 4)
                        case "homeButton": gameController.home()
                        case "infoButton": gameController.showInfo()
                        default: break
                    }
                }
            }
        }
    
    private func setupUI() {
        setBackground(with: "levelSelectBackground")
        
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cupLabel")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.maxY - 110)
        addChild(cupLabel)
        
        //score label
        scoreLabel = ASAttributedLabelNode(size: cupLabel.size)
        scoreLabel.attributedString = getAttrubutedString(with: String(score))
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
        
        //all levels should be included in uiview
        
        //level1
        let levelNode1 = SKSpriteNode(imageNamed: "level1Button")
        levelNode1.name = "level1Button"
        levelNode1.position = CGPoint(x: frame.midX, y: scoreLabel.frame.midY - 120)
        addChild(levelNode1)
        
        //level2
        let levelNode2 = SKSpriteNode(imageNamed: "level2Button")
        levelNode2.name = "level2Button"
        levelNode2.position = CGPoint(x: frame.midX, y: levelNode1.frame.midY - 135)
        addChild(levelNode2)
        
        //level3
        let levelNode3 = SKSpriteNode(imageNamed: "level3Button")
        levelNode3.name = "level3Button"
        levelNode3.position = CGPoint(x: frame.midX, y: levelNode2.frame.midY - 135)
        addChild(levelNode3)
        
        //level4
        let levelNode4 = SKSpriteNode(imageNamed: "level4Button")
        levelNode4.name = "level4Button"
        levelNode4.position = CGPoint(x: frame.midX, y: levelNode3.frame.midY - 135)
        addChild(levelNode4)
        
//                let levelNode5 = SKSpriteNode(imageNamed: "level5")
//                levelNode5.name = "level5"
//                levelNode5.position = CGPoint(x: frame.midX, y: levelNode4.frame.midY - 140)
//                contentNode.addChild(levelNode5)
//
//                let levelNodeSoon = SKSpriteNode(imageNamed: "levelSoon")
//                levelNodeSoon.name = "levelSoon"
//                levelNodeSoon.position = CGPoint(x: frame.midX, y: levelNode5.frame.midY - 140)
//                contentNode.addChild(levelNodeSoon)
        
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
