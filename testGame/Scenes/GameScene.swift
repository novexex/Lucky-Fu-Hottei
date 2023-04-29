//
//  GameScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import SpriteKit

class GameScene: Scene {
    
    let level: Int
    private var tiles = Array(repeating: Array(repeating: SKSpriteNode(), count: 5), count: 5)
    private var images = [String]()
    
    private var movesSection = SKSpriteNode()
    private var movesLabel = ASAttributedLabelNode(size: CGSize())
    private var moves = 9 {
        didSet {
            if moves == 0 {
                let gameController = getGameController()
                gameController.gameOver(with: scorePoints)
            } else {
                movesLabel.attributedString = getAttrubutedString(with: String(moves))
                if String(moves).count == 1 {
                    movesLabel.position = CGPoint(x: movesSection.frame.midX + 84, y: movesSection.frame.midY + 3)
                }
            }
        }
    }
    
    
    private var scorePoints = 0
    
    private var isHorizonalSelected = false
    private var isVerticalSelected = false
    
    private var rowSelected: Int?
    private var colSelected: Int?
    
    private var horizonalRectangle = SKShapeNode()
    private var verticalRectangle = SKShapeNode()
    
    init(size: CGSize, level: Int) {
        self.level = level
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupLevel()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let gameController = getGameController()
        
        // here is handling of matrix tiles
        // Looking for the node that was clicked on
        for row in tiles.enumerated() {
            for node in row.element.enumerated() {
                if node.element.contains(location) {
                    if !isHorizonalSelected {
                        guard let first = row.element.first else { return }
                        rowSelected = row.offset
                        
                        horizonalRectangle = SKShapeNode(rect: CGRect(x: first.frame.minX, y: first.frame.minY, width: first.size.width * 5, height: first.size.height))
                        horizonalRectangle.fillColor = UIColor(red: 255, green: 199, blue: 0, alpha: 0.9)
                        horizonalRectangle.strokeColor = .clear
                        horizonalRectangle.blendMode = .screen
                        horizonalRectangle.zPosition = 1
                        addChild(horizonalRectangle)
                        isHorizonalSelected = true
                        horizonalRectangle.isHidden = false
                    } else if !isVerticalSelected {
                        let column = tiles[0][node.offset]
                        colSelected = node.offset
                        
                        verticalRectangle = SKShapeNode(rect: CGRect(x: column.frame.minX, y: column.frame.minY, width: column.size.width, height: column.size.height * 5))
                        verticalRectangle.fillColor = UIColor(red: 255, green: 199, blue: 0, alpha: 0.9)
                        verticalRectangle.strokeColor = .clear
                        verticalRectangle.blendMode = .screen
                        verticalRectangle.zPosition = 1
                        addChild(verticalRectangle)
                        isVerticalSelected = true
                        horizonalRectangle.isHidden = false
                    }
                }
            }
        }
        
        // here is handling other ui elemnents except of matrix tiles
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                if node.name == "swapButton" {
                    if self.isHorizonalSelected && self.isVerticalSelected {
                        guard let colSelected = self.colSelected, let rowSelected = self.rowSelected else { return }
                        
                        self.horizonalRectangle.isHidden = true
                        self.verticalRectangle.isHidden = true
                        
                        self.isHorizonalSelected = false
                        self.isVerticalSelected = false
                        
                        self.moves -= 1
                        
                        self.swap(row: rowSelected, col: colSelected)
                        
                        self.checkMatches()
                    }
                } else if node.name == "homeButton" {
                    gameController.home()
                } else if node.name == "reapeatButton" {
                    gameController.startGame(level: level+1)
                } else if node.name == "infoButton" {
                    gameController.showInfo()
                }
            }
        }
    }
    
    private func setupLevel() {
            images = ["coinTile", "craneTile", "lampTile"]
        switch level {
            case 2:
                images += ["redPandaTile"]
            case 3:
                images += ["redPandaTile", "pandaTile"]
            case 4:
                images += ["redPandaTile", "pandaTile"]
                moves = 15
            case 5:
                images += ["redPandaTile", "pandaTile"]
                moves = 10
            default: break
        }
    }
    
    private func checkMatches() {
        // Check for 3 consecutive items of the same type in rows
        for i in 0..<tiles.count {
            for j in 0..<tiles.count-2 {
                if tiles[i][j].name == tiles[i][j+1].name && tiles[i][j+1].name == tiles[i][j+2].name {
                    appendPoints()
                    getNewTile(row: i, col: j)
                    getNewTile(row: i, col: j+1)
                    getNewTile(row: i, col: j+2)
                }
            }
        }
        
        // Check for 3 consecutive items of the same type in columns
        for i in 0..<tiles.count {
            for j in 0..<tiles.count-2 {
                if tiles[j][i].name == tiles[j+1][i].name && tiles[j+1][i].name == tiles[j+2][i].name {
                    appendPoints()
                    getNewTile(row: j, col: i)
                    getNewTile(row: j+1, col: i)
                    getNewTile(row: j+2, col: i)
                }
            }
        }
    }
    
    private func appendPoints() {
        switch level {
            case 1: scorePoints += 10
            case 2: scorePoints += 50
            case 3: scorePoints += 100
            case 4: scorePoints += 250
            case 5: scorePoints += 500
            default: break
        }
    }
    
    private func getNewTile(row: Int, col: Int) {
        guard var randomImage = images.randomElement() else { return }
        var sprite = SKSpriteNode(imageNamed: randomImage)
        sprite.name = randomImage
        tiles[row][col].texture = sprite.texture
        tiles[row][col].name = sprite.name
        
        while isSameImageRepeatedVertically(row: row, col: col) || isSameImageRepeatedHorizontally(row: row, col: col) {
            randomImage = images.randomElement() ?? ""
            sprite = SKSpriteNode(imageNamed: randomImage)
            sprite.name = randomImage
            tiles[row][col].texture = sprite.texture
            tiles[row][col].name = sprite.name
        }
    }
    
    private func swap(row: Int, col: Int) {
        var tempCol = [SKSpriteNode]()
        
        for i in (0..<tiles.count).reversed() {
            let tmpNode = SKSpriteNode()
            tmpNode.texture = tiles[i][col].texture
            tmpNode.name = tiles[i][col].name
            tempCol.append(tmpNode)
        }
        
        for i in (0..<tiles.count).reversed() {
            tiles[i][col].texture = tiles[row][i].texture
            tiles[i][col].name = tiles[row][i].name
        }
        
        for i in (0..<tiles.count).reversed() {
            tiles[row][i].texture = tempCol[i].texture
            tiles[row][i].name = tempCol[i].name
        }
    }
    
    private func setupTiles() {
        let tileSize = CGSize(width: 66, height: 52)
        let totalTilesWidth = tileSize.width * 5
        let middle = CGPoint(x: frame.midX + 32, y: frame.midY + 100)
        let offset = CGPoint(x: middle.x - (totalTilesWidth / 2), y: middle.y - (totalTilesWidth / 2))
                
        for row in 0..<tiles.count {
            var rowTiles = [SKSpriteNode]()
            for col in 0..<tiles[row].count {
                guard var randomImage = images.randomElement() else { return }
                var tile = SKSpriteNode(imageNamed: randomImage)
                tile.name = randomImage
                tiles[row][col] = tile
                
                while isSameImageRepeatedVertically(row: row, col: col) || isSameImageRepeatedHorizontally(row: row, col: col) {
                    randomImage = images.randomElement() ?? ""
                    tile = SKSpriteNode(imageNamed: randomImage)
                    tile.name = randomImage
                    tiles[row][col] = tile
                }
                
                tile.position = CGPoint(x: tileSize.width * CGFloat(col) + offset.x, y: tileSize.height * CGFloat(row) + offset.y)
                tile.size = tileSize
                addChild(tile)
                rowTiles.append(tile)
            }
            tiles[row] = rowTiles
        }
    }
    
    private func isSameImageRepeatedHorizontally(row: Int, col: Int) -> Bool {
        if row >= 2 {
            if tiles[row][col].name == tiles[row-1][col].name &&
                tiles[row][col].name == tiles[row-2][col].name {
                return true
            }
        }
        return false
    }
    
    private func isSameImageRepeatedVertically(row: Int, col: Int) -> Bool {
        if col >= 2 {
            if tiles[row][col].name == tiles[row][col-1].name &&
                tiles[row][col].name == tiles[row][col-2].name {
                return true
            }
        }
        return false
    }
    
    private func setupUI() {
        // dynamic background depending on the level
        switch level {
            case 1: setBackground(with: "level1Background")
            case 2: setBackground(with: "level2Background")
            case 3: setBackground(with: "level3Background")
            case 4: setBackground(with: "level4Background")
            case 5: setBackground(with: "level5Background")
            default: break
        }
        
        //moves section
        movesSection = SKSpriteNode(imageNamed: "scoreSection")
        movesSection.position = CGPoint(x: size.width/2, y: size.height/2 + 270)
        movesSection.zPosition = -1
        addChild(movesSection)
        
        //moves
        movesLabel = ASAttributedLabelNode(size: movesSection.size)
        movesLabel.attributedString = getAttrubutedString(with: String(moves))
        movesLabel.position = CGPoint(x: movesSection.frame.midX + 68, y: movesSection.frame.midY + 3)
        addChild(movesLabel)
        
        //arch
        let arch = SKSpriteNode(imageNamed: "arch")
        arch.position = CGPoint(x: movesSection.position.x, y: movesSection.position.y - 50)
        arch.zPosition = -1
        addChild(arch)
        
        //matrix of tiles
        setupTiles()
        
        //swap button
        let swapButton = SKSpriteNode(imageNamed: "swapButton")
        swapButton.name = "swapButton"
        guard let lastXpos = tiles.last?.last?.position.x else { return }
        swapButton.position = CGPoint(x: lastXpos - 130, y: frame.midY - 200)
        addChild(swapButton)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 55, y: swapButton.frame.minY - 40)
        addChild(homeButton)
        
        // repeat button
        let reapeatButton = SKSpriteNode(imageNamed: "refreshButton")
        reapeatButton.name = "reapeatButton"
        reapeatButton.position = CGPoint(x: frame.midX, y: swapButton.frame.minY - 40)
        addChild(reapeatButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX - 55, y: swapButton.frame.minY - 40)
        addChild(infoButton)
    }
}

