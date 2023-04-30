//
//  WelcomeBonusScreen.swift
//  testGame
//
//  Created by Artour Ilyasov on 27.04.2023.
//

import SpriteKit

class WelcomeBonusScene: Scene {
    
    private var tiles = Array(repeating: Array(repeating: SKSpriteNode(), count: 3), count: 3)
    private var pointAmounts = ["100", "0", "0", "0", "500", "1000", "5000", "2000", "0"]
    private var isBonusGet = false
    private var addingPoints = 0
    
    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    var score = 0 {
        didSet {
            scoreLabel.attributedString = getAttrubutedString(with: String(score), size: 58)
        }
    }
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    func getAttrubutedString(with text: String, size: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 3.9520199298858643)
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.65)
        shadow.shadowBlurRadius = 12.927276611328125
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "gangOfThree", size: size) ?? UIFont(),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.29,
            .strokeColor: UIColor(hex: "ECB43C"),
            .shadow: shadow,
            .paragraphStyle: paragraphStyle
            
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !isBonusGet {
            for row in tiles.enumerated() {
                for node in row.element.enumerated() {
                    if node.element.contains(location) {
                        isBonusGet = true
                        node.element.removeFromParent()
                        let newTile = ASAttributedLabelNode(size: node.element.size)
                        guard let name = node.element.name else { return }
                        newTile.attributedString = getAttrubutedString(with: name, size: 30, alignment: .center)
                        newTile.position = CGPoint(x: node.element.frame.midX, y: node.element.frame.midY)
                        guard let number = Int(name) else { return }
                        addingPoints = number
                        
                        addChild(newTile)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.showAllTilesExcept(i: row.offset, j: node.offset)
                        }
                        break
                    }
                }
            }
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                if node.name == "takeOutButton" {
                    score += addingPoints
                    let gameController = getGameController()
                    gameController.presentMenu()
                }
            }
        }
        
    }
    
    private func showAllTilesExcept(i: Int, j: Int) {
        for row in tiles {
            for node in row {
                if node == tiles[i][j] {
                    continue
                }
                node.removeFromParent()
                let newTile = ASAttributedLabelNode(size: node.size)
                guard let name = node.name else { return }
                newTile.attributedString = getAttrubutedString(with: name, size: 30, alignment: .center)
                newTile.position = CGPoint(x: node.frame.midX, y: node.frame.midY)
                
                addChild(newTile)
            }
        }
    }
    
    private func setupTiles() {
        let tileSize = CGSize(width: 88, height: 84)
        let totalTilesWidth = tileSize.width * 3
        let middle = CGPoint(x: frame.midX + 40, y: frame.midY + 50)
        let offset = CGPoint(x: middle.x - (totalTilesWidth / 2), y: middle.y - (totalTilesWidth / 2))
        
        for row in 0..<tiles.count {
            var rowTiles = [SKSpriteNode]()
            for col in 0..<tiles[row].count {
                
                let tile = SKSpriteNode(imageNamed: "bonusLabel")
                tile.name = pointAmounts.remove(at: Int.random(in: 0..<pointAmounts.count))
                tiles[row][col] = tile
                
                tile.position = CGPoint(x: tileSize.width * CGFloat(col) + offset.x, y: tileSize.height * CGFloat(row) + offset.y)
                tile.size = tileSize
                addChild(tile)
                rowTiles.append(tile)
            }
            tiles[row] = rowTiles
        }
    }
    
    private func setupUI() {
        setBackground(with: "welcomeBonusBackground")
        
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cupLabel")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.midY + 310)
        addChild(cupLabel)
        
        //score label
        scoreLabel = ASAttributedLabelNode(size: cupLabel.size)
        scoreLabel.attributedString = getAttrubutedString(with: String(score), size: 58, alignment: .left)
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
        
        setupTiles()
        
        // takeout button
        let takeOutButton = SKSpriteNode(imageNamed: "takeOutButton")
        takeOutButton.name = "takeOutButton"
        guard let last = tiles.last?.last else { return }
        takeOutButton.position = CGPoint(x: frame.midX, y: last.position.y - 295)
        addChild(takeOutButton)
    }
}
