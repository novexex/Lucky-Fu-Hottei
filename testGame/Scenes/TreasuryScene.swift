//
//  TreasuryScreen.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class TreasuryScene: Scene {
    
    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    let score: Int
    
    init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        scoreLabel = ASAttributedLabelNode(size: cupLabel.size)
        scoreLabel.attributedString = getAttrubutedString(with: String(score), size: 58)
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
        
        let treasuryImage1 = score >= 100 ? "treasuryItem1" : "treasuryItem1BW"
        let treasuryItem1 = SKSpriteNode(imageNamed: treasuryImage1)
        treasuryItem1.position = CGPoint(x: frame.minX + 80, y: cupLabel.position.y - 215)
        addChild(treasuryItem1)
        
        let treasuryImage2 = score >= 200 ? "treasuryItem2" : "treasuryItem2BW"
        let treasuryItem2 = SKSpriteNode(imageNamed: treasuryImage2)
        treasuryItem2.position = CGPoint(x: frame.midX, y: treasuryItem1.position.y)
        addChild(treasuryItem2)
        
        let treasuryImage3 = score >= 350 ? "treasuryItem3" : "treasuryItem3BW"
        let treasuryItem3 = SKSpriteNode(imageNamed: treasuryImage3)
        treasuryItem3.position = CGPoint(x: treasuryItem2.position.x + 120, y: treasuryItem1.position.y + 6)
        addChild(treasuryItem3)
        
        let treasuryImage4 = score >= 600 ? "treasuryItem4" : "treasuryItem4BW"
        let treasuryItem4 = SKSpriteNode(imageNamed: treasuryImage4)
        treasuryItem4.position = CGPoint(x: treasuryItem1.position.x, y: treasuryItem1.position.y - 134)
        addChild(treasuryItem4)
        
        let treasuryImage5 = score >= 1000 ? "treasuryItem5" : "treasuryItem5BW"
        let treasuryItem5 = SKSpriteNode(imageNamed: treasuryImage5)
        treasuryItem5.position = CGPoint(x: treasuryItem4.position.x + 120, y: treasuryItem2.position.y - 150)
        addChild(treasuryItem5)
        
        let treasuryImage6 = score >= 2000 ? "treasuryItem6" : "treasuryItem6BW"
        let treasuryItem6 = SKSpriteNode(imageNamed: treasuryImage6)
        treasuryItem6.position = CGPoint(x: treasuryItem5.position.x + 112, y: treasuryItem3.position.y - 140)
        addChild(treasuryItem6)
        
        let treasuryImage7 = score >= 3000 ? "treasuryItem7" : "treasuryItem7BW"
        let treasuryItem7 = SKSpriteNode(imageNamed: treasuryImage7)
        treasuryItem7.position = CGPoint(x: treasuryItem1.position.x + 10, y: treasuryItem4.position.y - 135)
        addChild(treasuryItem7)
        
        let treasuryImage8 = score >= 3500 ? "treasuryItem8" : "treasuryItem8BW"
        let treasuryItem8 = SKSpriteNode(imageNamed: treasuryImage8)
        treasuryItem8.position = CGPoint(x: treasuryItem7.position.x + 120, y: treasuryItem5.position.y - 112)
        addChild(treasuryItem8)
        
        let treasuryImage9 = score >= 5000 ? "treasuryItem9" : "treasuryItem9BW"
        let treasuryItem9 = SKSpriteNode(imageNamed: treasuryImage9)
        treasuryItem9.position = CGPoint(x: treasuryItem8.position.x + 95, y: treasuryItem6.position.y - 126)
        addChild(treasuryItem9)
        
        
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
