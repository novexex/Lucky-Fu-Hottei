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
    
    var safeArea: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let safeArea = windowScene.windows.first?.safeAreaInsets else { return UIEdgeInsets() }
        return safeArea
    }
    
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "level1Button":
                        gameController.startGame(level: 1)
                    case "level2Button":
                        if availableLevel >= 2 {
                            gameController.startGame(level: 2)
                        }
                    case "level3Button":
                        if availableLevel >= 3 {
                            gameController.startGame(level: 3)
                        }
                    case "level4Button":
                        if availableLevel >= 4 {
                            gameController.startGame(level: 4)
                        }
                    case "homeButton":
                        gameController.home()
                    case "infoButton":
                        gameController.showInfo()
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
        cupLabel.position = CGPoint(x: frame.midX - 50, y: size.height - safeArea.top - cupLabel.size.height / 2)
        addChild(cupLabel)
        
        //score label
        scoreLabel = ASAttributedLabelNode(size: cupLabel.size)
        scoreLabel.attributedString = getAttrubutedString(with: String(score))
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
        
        for i in 1...5 {
            let texture = getTexture(named: "level" + String(i) + "Backgroundd")
            let levelButtonBackground = SKSpriteNode(texture: texture)
            levelButtonBackground.name = "level" + String(i) + "Button"
            levelButtonBackground.position = CGPoint(x: frame.midX, y: scoreLabel.frame.midY - CGFloat( 100 + ((i-1) * 110)))
            addChild(levelButtonBackground)
            
            let level = SKSpriteNode(imageNamed: "level" + String(i))
            level.name = "level" + String(i) + "Button"
            level.position = CGPoint(x: frame.midX, y: levelButtonBackground.frame.maxY - level.size.height / 4)
            level.zPosition = levelButtonBackground.zPosition + 1
            addChild(level)
        }
        
//        // level 1 button
//        let level1Button = SKSpriteNode(imageNamed: "level1Button")
//        level1Button.name = "level1Button"
//        level1Button.position = CGPoint(x: frame.midX, y: scoreLabel.frame.midY - 100)
//        container.addChild(level1Button)
//
//        // level 2 button
//        let level2Image = availableLevel >= 2 ? "level2Button" : "level2BWButton"
//        let level2Button = SKSpriteNode(imageNamed: level2Image)
//        level2Button.name = "level2Button"
//        level2Button.position = CGPoint(x: frame.midX, y: level1Button.frame.midY - 135)
//        container.addChild(level2Button)
//
//        // level 3 button
//        let level3Image = availableLevel >= 3 ? "level3Button" : "level3BWButton"
//        let level3Button = SKSpriteNode(imageNamed: level3Image)
//        level3Button.name = "level3Button"
//        level3Button.position = CGPoint(x: frame.midX, y: level2Button.frame.midY - 135)
//        container.addChild(level3Button)
//
//        // level 4 button
//        let level4Image = availableLevel >= 4 ? "level4Button" : "level4BWButton"
//        let level4Button = SKSpriteNode(imageNamed: level4Image)
//        level4Button.name = "level4Button"
//        level4Button.position = CGPoint(x: frame.midX, y: level3Button.frame.midY - 135)
//        container.addChild(level4Button)
        
//        // level 5 button
//        let level5Image = availableLevel >= 5 ? "level5Button" : "level5BWButton"
//        let level5Button = SKSpriteNode(imageNamed: level5Image)
//        level5Button.name = "level5Button"
//        level5Button.position = CGPoint(x: frame.midX, y: level4Button.frame.midY - 135)
//        container.addChild(level5Button)
        
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
    
    private func getTexture(named: String) -> SKTexture {
        let name = named.replacingOccurrences(of: "Backgroundd", with: "", range: named.startIndex..<named.endIndex)
        if let lastChar = name.last,
           let lastDigit = Int(String(lastChar)) {
            
            if lastDigit <= availableLevel {
                return SKTexture(imageNamed: named)
            } else {
                
                let image = UIImage(named: named)
                guard let image else { return SKTexture() }
                var texture = SKTexture(image: image)
                
                // Применяем фильтр, чтобы сделать изображение черно-белым
                if let filter = CIFilter(name: "CIColorControls") {
                    // Устанавливаем параметры фильтра
                    filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
                    filter.setValue(0.0, forKey: kCIInputSaturationKey)
                    
                    // Создаем Core Image контекст
                    let ciContext = CIContext(options: nil)
                    
                    // Применяем фильтр к изображению
                    if let outputImage = filter.outputImage,
                       let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                        // Создаем новую текстуру из черно-белого изображения
                        let blackAndWhiteTexture = SKTexture(cgImage: cgImage)
                        
                        texture = blackAndWhiteTexture
                    }
                }
                return texture
            }
        }
        return SKTexture()
    }
}
