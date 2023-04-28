//
//  LevelScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class LevelSelectScene: SKScene, SKViewDelegate {
    
    var score: Int!
    
    override func didMove(to view: SKView) {
        setupBackground()
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
        
        guard let gameController = self.view?.window?.rootViewController as? GameViewController else {
            fatalError("GameController not found")
        }
        
        for touch in touches {
            enumerateChildNodes(withName: "//*") { (node, stop) in
                if node.name == "level1" {
                    if node.contains(touch.location(in: self)) {
                        gameController.startGame(level: 1)
                    }
                } else if node.name == "level2" {
                    if node.contains(touch.location(in: self)) {
                        gameController.startGame(level: 2)
                    }
                } else if node.name == "level3" {
                    if node.contains(touch.location(in: self)) {
                        gameController.startGame(level: 3)
                    }
                } else if node.name == "level4" {
                    if node.contains(touch.location(in: self)) {
                        gameController.startGame(level: 4)
                    }
                } else if node.name == "level5" {
                    
                } else if node.name == "levelSoon" {
                    
                } else if node.name == "homeButton" {
                    gameController.home()
                } else if node.name == "infoButton" {
                    gameController.showInfo()
                }
            }
        }
    }
    
    func setupUI() {
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cup")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.maxY - 110)
        cupLabel.zPosition = 1
        addChild(cupLabel)
        
        //score
        let score = SKLabelNode(text: String(120))
        score.fontName = "gangOfThree"
        score.fontSize = 50
        score.position = CGPoint(x: cupLabel.frame.midX + 80, y: cupLabel.frame.midY - 15)
        addChild(score)
        
        let levelNode1 = SKSpriteNode(imageNamed: "level1")
        levelNode1.name = "level1"
        levelNode1.position = CGPoint(x: frame.midX, y: score.frame.midY - 120)
        addChild(levelNode1)
        
        let levelNode2 = SKSpriteNode(imageNamed: "level2")
        levelNode2.name = "level2"
        levelNode2.position = CGPoint(x: frame.midX, y: levelNode1.frame.midY - 135)
        addChild(levelNode2)
        
        let levelNode3 = SKSpriteNode(imageNamed: "level3")
        levelNode3.name = "level3"
        levelNode3.position = CGPoint(x: frame.midX, y: levelNode2.frame.midY - 135)
        addChild(levelNode3)
        
        let levelNode4 = SKSpriteNode(imageNamed: "level4")
        levelNode4.name = "level4"
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
