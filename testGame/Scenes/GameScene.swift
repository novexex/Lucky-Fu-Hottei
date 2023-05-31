//
//  GameScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import SpriteKit

class GameScene: Scene {
    // MARK: Initializing propertys
    let level: Int
    
    var safeArea: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let safeArea = windowScene.windows.first?.safeAreaInsets else { return UIEdgeInsets() }
        return safeArea
    }
    
    lazy var count = level < 3 ? 2 : 5
    
    var numbers = [[Int]]()
    lazy var blocks = Array(repeating: Array(repeating: Block(), count: count), count: count)
    
    var timerLabel = ASAttributedLabelNode(size: CGSize())
    var gameTimer = GameTimer()
    
    // MARK: Initializators
    init(size: CGSize, level: Int) {
        self.level = level
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrided methods
    override func didMove(to view: SKView) {
        setupLevel()
        setupUI()
        gameTimer.start()
    }
    
    override func update(_ currentTime: TimeInterval) {
        timerLabel.attributedString = getAttrubutedString(with: gameTimer.time, alignment: .center)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "swapButton":
                        if gameOver() {
                            if level == 1 {
                                gameController.gameOver(with: 500, level: level, time: gameTimer.timePlayedInSeconds)
                            } else if level == 2 {
                                gameController.gameOver(with: 1000, level: level, time: gameTimer.timePlayedInSeconds)
                            } else if level == 3 {
                                gameController.gameOver(with: 2000, level: level, time: gameTimer.timePlayedInSeconds)
                            } else if level == 4 {
                                gameController.gameOver(with: 3500, level: level, time: gameTimer.timePlayedInSeconds)
                            } else if level == 5 {
                                gameController.gameOver(with: 5000, level: level, time: gameTimer.timePlayedInSeconds)
                            }
                        } else {
                            gameController.gameOver(with: 0, level: level, time: TimeInterval())
                        }
                    case "homeButton":
                        gameController.home()
                    case "refreshButton":
                        gameController.startGame(level: level)
                    case "infoButton":
                        gameController.showInfo()
                    default:
                        for i in 0..<blocks.count {
                            for j in 0..<blocks.count {
                                for line in blocks[i][j].lines {
                                    if line.contains(location) {
                                        line.alpha = line.alpha == 0 ? 1 : 0
                                    }
                                }
                            }
                        }
                        padding()
                }
            }
        }
    }
    
    private func gameOver() -> Bool {
        for i in 0..<count {
            for j in 0..<count {
                if blocks[i][j].number != blocks[i][j].numberOfFilledLines {
                    return false
                }
            }
        }
        return true
    }
    
    private func setupLevel() {
        switch level {
            case 1:
                setBackground(with: "level1Background")
                numbers = [[0, 1],
                           [1, 4]]
            case 2:
                setBackground(with: "level2Background")
                numbers = [[2, 3],
                           [3, 2]]
            case 3:
                setBackground(with: "level3Background")
                numbers = [[3, 2, 2, 3, 3],
                           [2, 2, 2, 1, 2],
                           [3, 2, 3, 2, 3],
                           [1, 2, 2, 0, 3],
                           [3, 2, 2, 3, 2]]
            case 4:
                setBackground(with: "level4Background")
                numbers = [[3, 2, 2, 2, 2],
                           [1, 2, 2, 1, 1],
                           [2, 3, 2, 2, 3],
                           [2, 2, 2, 2, 2],
                           [1, 2, 2, 2, 3]]
            case 5:
                setBackground(with: "level5Background")
                numbers = [[3, 1, 2, 2, 3],
                           [2, 3, 2, 1, 3],
                           [1, 1, 1, 0, 3],
                           [1, 2, 3, 2, 2],
                           [3, 2, 1, 3, 1]]
            default: break
        }
    }
    
    
    private func cropSprite() {
        
    }
    
    private func padding() {
        for i in 0..<blocks.count {
            for j in 0..<blocks.count {
                
                if j > 0 {
                    if blocks[i][j].leftLine.alpha == 1 {
                        blocks[i][j-1].rightLine.alpha = 1
                    } else {
                        blocks[i][j-1].rightLine.alpha = 0
                    }
                }
                
                if j != blocks.count - 1 {
                    if blocks[i][j].rightLine.alpha == 1 {
                        blocks[i][j+1].leftLine.alpha = 1
                    } else {
                        blocks[i][j+1].leftLine.alpha = 0
                    }
                }
                
                if i > 0 {
                    if blocks[i][j].upLine.alpha == 1 {
                        blocks[i-1][j].downLine.alpha = 1
                    } else {
                        blocks[i-1][j].downLine.alpha = 0
                    }
                }
                
                
                if i != blocks.count - 1 {
                    if blocks[i][j].downLine.alpha == 1 {
                        blocks[i+1][j].upLine.alpha = 1
                    } else {
                        blocks[i+1][j].upLine.alpha = 0
                    }
                }
            }
        }
    }
    
    private func fillBoard(board: SKSpriteNode) {
        let size: CGFloat = level < 3 ? 1 : 2.2
        var blockSize = SKTexture(imageNamed: "block").size()
        blockSize = CGSize(width: blockSize.width / size, height: blockSize.height / size)
        let startPos = CGPoint(x: board.frame.minX + blockSize.width / 2, y: board.frame.maxY - blockSize.height / 2)
        
        for i in 0..<count {
            for j in 0..<count {
                let block = SKSpriteNode(imageNamed: "block")
                block.size = CGSize(width: block.size.width / size, height: block.size.height / size)
                block.zPosition = 1
                block.position = CGPoint(x: startPos.x + (CGFloat(j) * (block.size.width - (65 / size))), y: startPos.y - (CGFloat(i) * (block.size.height - (65 / size))))
                addChild(block)
                if i != 0 {
                    cropSprite()
                }
                
                if j != 0 {
                    cropSprite()
                }
                
                let leftStick = SKSpriteNode(imageNamed: "stick")
                leftStick.name = "stick"
                leftStick.zRotation = CGFloat.pi / 2
                leftStick.alpha = 0
                if level > 2 {
                    leftStick.size = CGSize(width: block.size.width - 32.5, height: leftStick.size.height)
                } else {
                    leftStick.size.height *= 2
                }
                leftStick.position = CGPoint(x: block.frame.minX + (32.5 / size), y: block.frame.midY)
                addChild(leftStick)
                
                let upStick = SKSpriteNode(imageNamed: "stick")
                upStick.name = "stick"
                upStick.alpha = 0
                if level > 2 {
                    upStick.size = CGSize(width: block.size.width - 32.5, height: upStick.size.height)
                } else {
                    upStick.size.height *= 2
                }
                upStick.position = CGPoint(x: block.frame.midX, y: block.frame.maxY - (32.5 / size))
                addChild(upStick)
                
                let rightStick = SKSpriteNode(imageNamed: "stick")
                rightStick.name = "stick"
                rightStick.zRotation = CGFloat.pi / 2
                rightStick.alpha = 0
                if level > 2 {
                    rightStick.size = CGSize(width: block.size.width - 32.5, height: rightStick.size.height)
                } else {
                    rightStick.size.height *= 2
                }
                rightStick.position = CGPoint(x: block.frame.maxX - (32.5 / size), y: block.frame.midY)
                addChild(rightStick)
                
                let downStick = SKSpriteNode(imageNamed: "stick")
                downStick.name = "stick"
                downStick.alpha = 0
                if level > 2 {
                    downStick.size = CGSize(width: block.size.width - 32.5, height: downStick.size.height)
                } else {
                    downStick.size.height *= 2
                }
                downStick.position = CGPoint(x: block.frame.midX, y: block.frame.minY + (32.5 / size))
                addChild(downStick)
                
                blocks[i][j] = Block(block: block, number: numbers[i][j], leftLine: leftStick, rightLine: rightStick, upLine: upStick, downLine: downStick)
            }
        }
        
        for i in 0..<blocks.count {
            for j in 0..<blocks.count {
                let number = ASAttributedLabelNode(size: CGSize(width: 100, height: 100))
                number.attributedString = getAttrubutedString(with: String(numbers[i][j]), size: 90 / size, alignment: .center)
                number.position = CGPoint(x: blocks[i][j].block.frame.midX, y: blocks[i][j].block.frame.midY)
                addChild(number)
            }
        }
    }
    
    private func setupUI() {
        setupLevel()
        
        timerLabel = ASAttributedLabelNode(size: CGSize(width: 150, height: 50))
        timerLabel.attributedString = getAttrubutedString(with: "00:00", alignment: .center)
        timerLabel.position = CGPoint(x: frame.midX, y: size.height - safeArea.top - timerLabel.size.height)
        addChild(timerLabel)
        
        if gameController.bestTime[level] != 0 {
            let formattedBestTime = formatTimeInterval(gameController.bestTime[level]!)
            let bestTime = ASAttributedLabelNode(size: CGSize(width: 175, height: 25))
            bestTime.attributedString = getAttrubutedString(with: "BEST TIME: \(formattedBestTime)", size: 20, alignment: .center)
            bestTime.position = CGPoint(x: frame.midX, y: timerLabel.frame.minY - bestTime.size.height / 2)
            addChild(bestTime)
        }
        
        let arch = SKSpriteNode(imageNamed: "arch")
        arch.position = CGPoint(x: frame.midX, y: timerLabel.frame.minY - arch.size.height / 6)
        addChild(arch)
        
        let board = SKSpriteNode(imageNamed: "board")
        board.zPosition = -1
        board.position = CGPoint(x: frame.midX, y: arch.frame.minY - board.size.height / 2)
        addChild(board)
        
        let clearBoard = SKSpriteNode(color: .clear, size: CGSize(width: board.size.width - 20, height: board.size.height - 20))
        clearBoard.position = CGPoint(x: board.frame.midX, y: board.frame.midY)
        addChild(clearBoard)
        
        fillBoard(board: clearBoard)
        
        // check button
        let swapButton = SKSpriteNode(imageNamed: "swapButton")
        swapButton.name = "swapButton"
        swapButton.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        addChild(swapButton)
        
        // home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.name = "homeButton"
        homeButton.position = CGPoint(x: frame.midX + 55, y: swapButton.frame.minY - 40)
        addChild(homeButton)
        
        // refresh button
        let reapeatButton = SKSpriteNode(imageNamed: "refreshButton")
        reapeatButton.name = "refreshButton"
        reapeatButton.position = CGPoint(x: frame.midX, y: swapButton.frame.minY - 40)
        addChild(reapeatButton)
        
        // info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: frame.midX - 55, y: swapButton.frame.minY - 40)
        addChild(infoButton)
    }
}

