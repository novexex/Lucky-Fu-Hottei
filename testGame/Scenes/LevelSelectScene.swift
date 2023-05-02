//
//  LevelScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class LevelSelectScene: Scene, UIScrollViewDelegate {
    // MARK: Initializing propertys
    let availableLevel: Int
    
    // MARK: Public propertys
    var score = 0 {
        didSet {
            scoreLabel.attributedString = getAttrubutedString(with: String(score))
        }
    }
    
    // MARK: Private propertys
    private var scrollView: UIScrollView!
    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    
    // MARK: Initializators
    init(size: CGSize, availableLevel: Int) {
        self.availableLevel = availableLevel
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
                case "level1Button":
                    let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.startGame(level: 1) }])
                    self.run(sequence)
                case "level2Button":
                    let action = SKAction.run {
                        if self.availableLevel >= 2 {
                            self.gameController.startGame(level: 2)
                        }
                    }
                    let sequence = SKAction.sequence([gameController.clickButtonSoundAction, action])
                    self.run(sequence)
                case "level3Button":
                    let action = SKAction.run {
                        if self.availableLevel >= 3 {
                            self.gameController.startGame(level: 3)
                        }
                    }
                    let sequence = SKAction.sequence([gameController.clickButtonSoundAction, action])
                    self.run(sequence)
                case "level4Button":
                    let action = SKAction.run {
                        if self.availableLevel >= 4 {
                            self.gameController.startGame(level: 4)
                        }
                    }
                    let sequence = SKAction.sequence([gameController.clickButtonSoundAction, action])
                    self.run(sequence)
                case "homeButton":
                    let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.home() }])
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
        
        let container = SKNode()
        
        addChild(container)
        
        //level1
        let levelNode1 = SKSpriteNode(imageNamed: "level1Button")
        levelNode1.name = "level1Button"
        levelNode1.position = CGPoint(x: frame.midX, y: scoreLabel.frame.midY - 120)
        container.addChild(levelNode1)
        
        //level2
        let level2Image = availableLevel >= 2 ? "level2Button" : "level2BWButton"
        let levelNode2 = SKSpriteNode(imageNamed: level2Image)
        levelNode2.name = "level2Button"
        levelNode2.position = CGPoint(x: frame.midX, y: levelNode1.frame.midY - 135)
        container.addChild(levelNode2)
        
        //level3
        let level3Image = availableLevel >= 3 ? "level3Button" : "level3BWButton"
        let levelNode3 = SKSpriteNode(imageNamed: level3Image)
        levelNode3.name = "level3Button"
        levelNode3.position = CGPoint(x: frame.midX, y: levelNode2.frame.midY - 135)
        container.addChild(levelNode3)
        
        //level4
        let level4Image = availableLevel >= 4 ? "level4Button" : "level4BWButton"
        let levelNode4 = SKSpriteNode(imageNamed: level4Image)
        levelNode4.name = "level4Button"
        levelNode4.position = CGPoint(x: frame.midX, y: levelNode3.frame.midY - 135)
        container.addChild(levelNode4)
        
//        //level5
//        let levelNode5 = SKSpriteNode(imageNamed: "level5Button")
//        levelNode5.name = "level5Button"
//        levelNode5.position = CGPoint(x: frame.midX, y: levelNode4.frame.midY - 135)
//        container.addChild(levelNode5)
//
//        //levelSoon
//        let levelNodeSoon = SKSpriteNode(imageNamed: "levelSoonButton")
//        levelNodeSoon.name = "levelSoonButton"
//        levelNodeSoon.position = CGPoint(x: frame.midX, y: levelNode5.frame.midY - 135)
//        container.addChild(levelNodeSoon)
                    
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
