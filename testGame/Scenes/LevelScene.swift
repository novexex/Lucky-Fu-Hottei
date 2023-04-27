//
//  LevelScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class LevelScene: SKScene {
    
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
        
        let scrollView = UIScrollView(frame: CGRect(x: frame.midX, y: frame.midY - 400, width: view?.frame.size.width ?? 0, height: (view?.frame.size.height ?? 0)/2))
        view?.addSubview(scrollView)
        
        let contentNode = SKNode()
        addChild(contentNode)
        
        let levelNode1 = SKSpriteNode(imageNamed: "level1")
        levelNode1.position = CGPoint(x: frame.midX, y: score.frame.midY - 120)
        contentNode.addChild(levelNode1)
        
        let levelNode2 = SKSpriteNode(imageNamed: "level2")
        levelNode2.position = CGPoint(x: frame.midX, y: levelNode1.frame.midY - 140)
        contentNode.addChild(levelNode2)
        
        
        
//        //home button
//        let homeButton = SKSpriteNode(imageNamed: "homeButton")
//        homeButton.name = "homeButton"
//        homeButton.position = CGPoint(x: treasuryButton.position.x - 20, y: treasuryButton.position.y - 100)
//        addChild(homeButton)
//        
//        //info button
//        let infoButton = SKSpriteNode(imageNamed: "infoButton")
//        infoButton.name = "soundButton"
//        infoButton.position = CGPoint(x: homeButton.position.x + 50, y: homeButton.position.y)
//        addChild(infoButton)
        

    }
}
