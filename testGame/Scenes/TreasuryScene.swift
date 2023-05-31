//
//  TreasuryScreen.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class TreasuryScene: Scene {
    // MARK: Public propertys
    var score: Int {
        didSet {
            scoreLabel.attributedString = getAttrubutedString(with: String(score))
        }
    }
    var safeArea: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let safeArea = windowScene.windows.first?.safeAreaInsets else { return UIEdgeInsets() }
        return safeArea
    }
    // MARK: Private propertys
    private var isTreasureUnlock = Array(repeating: false, count: 9)
    private var treasuryItems = [SKSpriteNode]()
    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    
    // MARK: Initializators
    init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Overrided methods
    override func didMove(to view: SKView) {
        checkUnlockTreasurys()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "treasuryItem1": unlockTreasure(numberOfTreaure: 1)
                    case "treasuryItem2": unlockTreasure(numberOfTreaure: 2)
                    case "treasuryItem3": unlockTreasure(numberOfTreaure: 3)
                    case "treasuryItem4": unlockTreasure(numberOfTreaure: 4)
                    case "treasuryItem5": unlockTreasure(numberOfTreaure: 5)
                    case "treasuryItem6": unlockTreasure(numberOfTreaure: 6)
                    case "treasuryItem7": unlockTreasure(numberOfTreaure: 7)
                    case "treasuryItem8": unlockTreasure(numberOfTreaure: 8)
                    case "treasuryItem9": unlockTreasure(numberOfTreaure: 9)
                    case "infoButton":
                    gameController.showInfo()
                    case "homeButton":
                    gameController.home()
                    default: break
                }
            }
        }
    }
    
    // MARK: Private methods
    private func unlockTreasure(numberOfTreaure: Int) {
        var requiredScore = 0
        switch numberOfTreaure {
            case 1: requiredScore = 100
            case 2: requiredScore = 200
            case 3: requiredScore = 350
            case 4: requiredScore = 600
            case 5: requiredScore = 1000
            case 6: requiredScore = 2000
            case 7: requiredScore = 3000
            case 8: requiredScore = 3500
            case 9: requiredScore = 5000
            default: break
        }
        if score >= requiredScore {
            score -= requiredScore
            treasuryItems[numberOfTreaure-1].texture = SKTexture(imageNamed: "treasuryItem\(numberOfTreaure)")
            isTreasureUnlock[numberOfTreaure-1] = true
            saveIsTreasureUnlock()
            gameController.score = score
        }
    }
    
    private func saveIsTreasureUnlock() {
        UserDefaults.standard.set(isTreasureUnlock, forKey: "isTreasureUnlock")
    }
    
    private func checkUnlockTreasurys() {
        if let boolArray = UserDefaults.standard.array(forKey: "isTreasureUnlock") as? [Bool] {
            isTreasureUnlock = boolArray
        }
    }
    
    private func setupUI() {
        setBackground(with: "treasuryBackground")
        
        // cup label
        let cupLabel = SKSpriteNode(imageNamed: "cupLabel")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.midY + 300)
        addChild(cupLabel)
        
        // score label
        scoreLabel = ASAttributedLabelNode(size: cupLabel.size)
        scoreLabel.attributedString = getAttrubutedString(with: String(score))
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
        
        // treasury item 1 button
        let treasuryImage1 = isTreasureUnlock[0] ? "treasuryItem1" : "treasuryItem1BW"
        let treasuryItem1 = SKSpriteNode(imageNamed: treasuryImage1)
        treasuryItem1.name = "treasuryItem1"
        treasuryItem1.position = CGPoint(x: frame.minX + 80, y: cupLabel.position.y - 215)
        addChild(treasuryItem1)
        treasuryItems.append(treasuryItem1)
        
        // treasury item 2 button
        let treasuryImage2 = isTreasureUnlock[1] ? "treasuryItem2" : "treasuryItem2BW"
        let treasuryItem2 = SKSpriteNode(imageNamed: treasuryImage2)
        treasuryItem2.name = "treasuryItem2"
        treasuryItem2.position = CGPoint(x: frame.midX, y: treasuryItem1.position.y)
        addChild(treasuryItem2)
        treasuryItems.append(treasuryItem2)
        
        // treasury item 3 button
        let treasuryImage3 = isTreasureUnlock[2] ? "treasuryItem3" : "treasuryItem3BW"
        let treasuryItem3 = SKSpriteNode(imageNamed: treasuryImage3)
        treasuryItem3.name = "treasuryItem3"
        treasuryItem3.position = CGPoint(x: treasuryItem2.position.x + 120, y: treasuryItem1.position.y + 6)
        addChild(treasuryItem3)
        treasuryItems.append(treasuryItem3)
        
        // treasury item 4 button
        let treasuryImage4 = isTreasureUnlock[3] ? "treasuryItem4" : "treasuryItem4BW"
        let treasuryItem4 = SKSpriteNode(imageNamed: treasuryImage4)
        treasuryItem4.name = "treasuryItem4"
        treasuryItem4.position = CGPoint(x: treasuryItem1.position.x, y: treasuryItem1.position.y - 134)
        addChild(treasuryItem4)
        treasuryItems.append(treasuryItem4)
        
        // treasury item 5 button
        let treasuryImage5 = isTreasureUnlock[4] ? "treasuryItem5" : "treasuryItem5BW"
        let treasuryItem5 = SKSpriteNode(imageNamed: treasuryImage5)
        treasuryItem5.name = "treasuryItem5"
        treasuryItem5.position = CGPoint(x: treasuryItem4.position.x + 120, y: treasuryItem2.position.y - 150)
        addChild(treasuryItem5)
        treasuryItems.append(treasuryItem5)
        
        // treasury item 6 button
        let treasuryImage6 = isTreasureUnlock[5] ? "treasuryItem6" : "treasuryItem6BW"
        let treasuryItem6 = SKSpriteNode(imageNamed: treasuryImage6)
        treasuryItem6.name = "treasuryItem6"
        treasuryItem6.position = CGPoint(x: treasuryItem5.position.x + 112, y: treasuryItem3.position.y - 140)
        addChild(treasuryItem6)
        treasuryItems.append(treasuryItem6)
        
        // treasury item 7 button
        let treasuryImage7 = isTreasureUnlock[6] ? "treasuryItem7" : "treasuryItem7BW"
        let treasuryItem7 = SKSpriteNode(imageNamed: treasuryImage7)
        treasuryItem7.name = "treasuryItem7"
        treasuryItem7.position = CGPoint(x: treasuryItem1.position.x + 10, y: treasuryItem4.position.y - 135)
        addChild(treasuryItem7)
        treasuryItems.append(treasuryItem7)
        
        // treasury item 8 button
        let treasuryImage8 = isTreasureUnlock[7] ? "treasuryItem8" : "treasuryItem8BW"
        let treasuryItem8 = SKSpriteNode(imageNamed: treasuryImage8)
        treasuryItem8.name = "treasuryItem8"
        treasuryItem8.position = CGPoint(x: treasuryItem7.position.x + 120, y: treasuryItem5.position.y - 112)
        addChild(treasuryItem8)
        treasuryItems.append(treasuryItem8)
        
        // treasury item 9 button
        let treasuryImage9 = isTreasureUnlock[8] ? "treasuryItem9" : "treasuryItem9BW"
        let treasuryItem9 = SKSpriteNode(imageNamed: treasuryImage9)
        treasuryItem9.name = "treasuryItem9"
        treasuryItem9.position = CGPoint(x: treasuryItem8.position.x + 95, y: treasuryItem6.position.y - 126)
        addChild(treasuryItem9)
        treasuryItems.append(treasuryItem9)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX - 27, y: safeArea.bottom + homeButton.size.height / 2)
        addChild(homeButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX + 27, y: homeButton.position.y)
        addChild(infoButton)
    }
}
