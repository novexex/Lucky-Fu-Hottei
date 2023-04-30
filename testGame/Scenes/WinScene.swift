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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameController = getGameController()
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "nextLevelButton": level <= 4 ? gameController.startGame(level: level+1) : gameController.startGame(level: level)
                    case "infoButton": gameController.showInfo()
                    case "refreshButton": gameController.startGame(level: level)
                    case "homeButton": gameController.home()
                    default: break
                }
            }
        }
    }
    
    func getAttrubutedPlus() -> NSMutableAttributedString {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 3.9520199298858643)
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.65)
        shadow.shadowBlurRadius = 12.927276611328125
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 50) ?? UIFont(),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.29,
            .strokeColor: UIColor(hex: "ECB43C"),
            .shadow: shadow
        ]
        return NSMutableAttributedString(string: "+", attributes: attributes)
    }
    
    private func setupUI() {
        setBackground(with: "winBackground")
        
        
        let plusLabel = ASAttributedLabelNode(size: CGSize(width: 50, height: 50))
        plusLabel.attributedString = getAttrubutedPlus()
        plusLabel.position = CGPoint(x: frame.midX - 40, y: frame.midY - 100)
        addChild(plusLabel)

        // scoreLabel
        let scoreLabel = ASAttributedLabelNode(size: CGSize(width: 200, height: 100))
        scoreLabel.attributedString = getAttrubutedString(with: String(score), size: 58)
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
