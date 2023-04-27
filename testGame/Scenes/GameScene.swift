//
//  GameScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import SpriteKit

class GameScene: SKScene {
    private var backgroundTiles = [[SKSpriteNode]]()
    private var tiles = [[SKSpriteNode]]()
    
    private var images = ["coin", "crane", "lamp"]
    private var moves = 10
    
    private var isHorizonalSelected = false
    private var isVerticalSelected = false
    
    private var rowSelected: Int?
    private var colSelected: Int?
    
    private var horizonalRectangle = SKShapeNode()
    private var verticalRectangle = SKShapeNode()
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Ищем узел, по которому было произведено нажатие
        for row in tiles.enumerated() {
            for node in row.element.enumerated() {
                if node.element.contains(location) {
                    if !isHorizonalSelected {
                        // Выполняем действие для найденного узла
                        guard let first = row.element.first else { return }
                        rowSelected = row.offset
                        horizonalRectangle = SKShapeNode(rect: CGRect(x: first.frame.minX - 4.5, y: first.frame.minY, width: first.frame.width * 6.37, height: first.frame.height))
                        horizonalRectangle.fillColor = UIColor(red: 255, green: 199, blue: 0, alpha: 0.5)
                        horizonalRectangle.zPosition = 1
                        addChild(horizonalRectangle)
                        isHorizonalSelected = true
                    } else if !isVerticalSelected {
                        let column = backgroundTiles[0][node.offset]
                        colSelected = node.offset
                        verticalRectangle = SKShapeNode(rect: CGRect(x: column.frame.minX, y: column.frame.minY, width: column.frame.width, height: column.frame.height * 5))
                        verticalRectangle.fillColor = UIColor(red: 255, green: 199, blue: 0, alpha: 0.5)
                        verticalRectangle.zPosition = 1
                        addChild(verticalRectangle)
                        isVerticalSelected = true
                    }
                }
            }
        }
        
        if isHorizonalSelected && isVerticalSelected {
            for touch in touches {
                enumerateChildNodes(withName: "//*") { (node, stop) in
                    if node.name == "swapButton" {
                        if node.contains(touch.location(in: self)) {
                            guard let colSelected = self.colSelected, let rowSelected = self.rowSelected else { return }
                            
                            self.horizonalRectangle.removeFromParent()
                            self.verticalRectangle.removeFromParent()
                            
                            self.horizonalRectangle = SKShapeNode()
                            self.verticalRectangle = SKShapeNode()
                            
                            self.isHorizonalSelected = false
                            self.isVerticalSelected = false
                            
                            self.swap(row: rowSelected, col: colSelected)
                        }
                    }
                }
            }
        }
    }
    
    
    private func swap(row: Int, col: Int) {
        
        print("tiles")
        for i in (0...tiles.count-1).reversed() {
            for j in (0..<tiles.count) {
                print(tiles[i][j].name ?? "", terminator: " ")
            }
            print("\n")
        }
        
        var tempCol = [SKSpriteNode]()
        for i in (0...tiles.count-1).reversed() {
            let tmpNode = SKSpriteNode()
            tmpNode.texture = tiles[i][col].texture
            tmpNode.name = tiles[i][col].name
            tempCol.append(tmpNode)
        }
        
        for i in (0...tiles.count-1).reversed() {
            tiles[i][col].texture = tiles[row][i].texture
            tiles[i][col].name = tiles[row][i].name
        }
        
        
        for i in (0...tiles.count-1).reversed() {
            tiles[row][i].texture = tempCol[i].texture
            tiles[row][i].name = tempCol[i].name
        }

        print("resultTiles")
        for i in (0...tiles.count-1).reversed() {
            for j in (0..<tiles.count) {
                print(tiles[i][j].name ?? "", terminator: " ")
            }
            print("\n")
        }
    }
    
    private func setupTiles() {
        // setup backgrounds for tiles
        let tileSize = CGSize(width: 66, height: 52)
        let totalTilesWidth = tileSize.width * 5
        let middle = CGPoint(x: frame.midX + 32, y: frame.midY + 100)
        let offset = CGPoint(x: middle.x - (totalTilesWidth / 2), y: middle.y - (totalTilesWidth / 2))
        
        for row in 0..<5 {
            var tileBackgroundRow = [SKSpriteNode]()
            for col in 0..<5 {
                let tileBackground = SKSpriteNode(imageNamed: "backgroundTile")
                tileBackground.size = tileSize
                tileBackground.position = CGPoint(x: tileSize.width * CGFloat(col) + offset.x, y: tileSize.height * CGFloat(row) + offset.y)
                tileBackground.zPosition = -1
                addChild(tileBackground)
                tileBackgroundRow.append(tileBackground)
            }
            backgroundTiles.append(tileBackgroundRow)
        }
        
        // setup for tiles
        
        tiles = Array(repeating: Array(repeating: SKSpriteNode(), count: 5), count: 5)
        
        for row in 0..<tiles.count {
            for col in 0..<tiles.count {
                guard var randomImage = images.randomElement() else { return }
                var sprite = SKSpriteNode(imageNamed: randomImage)
                sprite.name = randomImage
                tiles[row][col] = sprite
                
                while isSameImageRepeatedVertically(row: row, col: col) || isSameImageRepeatedHorizontally(row: row, col: col) {
                    randomImage = images.randomElement() ?? ""
                    sprite = SKSpriteNode(imageNamed: randomImage)
                    sprite.name = randomImage
                    tiles[row][col] = sprite
                }
                
                sprite.position = CGPoint(x: backgroundTiles[row][col].frame.midX, y: backgroundTiles[row][col].frame.midY)
                
                addChild(sprite)
                
            }
        }
    }
    
    func isSameImageRepeatedHorizontally(row: Int, col: Int) -> Bool {
        if row >= 2 {
            if tiles[row][col].name == tiles[row-1][col].name &&
                tiles[row][col].name == tiles[row-2][col].name {
                return true
            }
        }
        return false
    }
    
    func isSameImageRepeatedVertically(row: Int, col: Int) -> Bool {
        if col >= 2 {
            if tiles[row][col].name == tiles[row][col-1].name &&
                tiles[row][col].name == tiles[row][col-2].name {
                return true
            }
        }
        return false
    }
    
    func setupBackground() {
        // Создайте фоновую картинку и добавьте ее на сцену
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func setupUI() {
        //score section
        let scoreSection = SKSpriteNode(imageNamed: "scoreSection")
        scoreSection.position = CGPoint(x: size.width/2, y: size.height/2 + 270)
        scoreSection.zPosition = -1
        addChild(scoreSection)
        
        //score
        let score = SKLabelNode(text: String(120))
        score.fontName = "gangOfThree"
        score.fontSize = 50
        score.position = CGPoint(x: scoreSection.frame.midX, y: scoreSection.frame.midY - 15)
        addChild(score)
        
        //arch
        let arch = SKSpriteNode(imageNamed: "arch")
        arch.position = CGPoint(x: scoreSection.position.x, y: scoreSection.position.y - 50)
        arch.zPosition = -1
        addChild(arch)
        
        setupTiles()
        
        let swapButton = SKSpriteNode(imageNamed: "swapButton")
        swapButton.name = "swapButton"
        guard let lastXpos = backgroundTiles.last?.last?.position.x else { return }
        swapButton.position = CGPoint(x: lastXpos - 130, y: frame.midY - 200)
        addChild(swapButton)
    }
}

