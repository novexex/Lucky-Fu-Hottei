//
//  MenuScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 26.04.2023.
//

import SpriteKit

class MenuScene: SKScene {

    var score: Int = 0
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }
    
    func setupBackground() {
        // Создайте фоновую картинку и добавьте ее на сцену
        let background = SKSpriteNode(imageNamed: "menu")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: size.width)
        background.zPosition = -2
        addChild(background)
    }
    
    func setupUI() {
        //buda
        let buda = SKSpriteNode(imageNamed: "buda")
        buda.position = CGPoint(x: frame.midX, y: frame.midY + 120)
        buda.zPosition = -1
        addChild(buda)
        
        //start button
        let startButton = SKSpriteNode(imageNamed: "startButton")
        startButton.name = "startButton"
        startButton.position = CGPoint(x: buda.position.x, y: buda.position.y - 185)
        addChild(startButton)
        
        //treasury button
        let treasuryButton = SKSpriteNode(imageNamed: "treasuryButton")
        treasuryButton.name = "treasuryButton"
        treasuryButton.position = CGPoint(x: startButton.position.x, y: startButton.position.y - 115)
        addChild(treasuryButton)
        
        //music button
        let musicButton = SKSpriteNode(imageNamed: "musicButton")
        musicButton.name = "musicButton"
        musicButton.position = CGPoint(x: treasuryButton.position.x - 50, y: treasuryButton.position.y - 100)
        addChild(musicButton)
        
        //sound button
        let soundButton = SKSpriteNode(imageNamed: "soundButton")
        soundButton.name = "soundButton"
        soundButton.position = CGPoint(x: musicButton.position.x + 50, y: musicButton.position.y)
        addChild(soundButton)
        
        //info button
        let infoButton = SKSpriteNode(imageNamed: "infoButton")
        infoButton.name = "soundButton"
        infoButton.position = CGPoint(x: soundButton.position.x + 50, y: soundButton.position.y)
        addChild(infoButton)
        
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cup")
        cupLabel.position = CGPoint(x: buda.position.x - 50, y: buda.position.y + 175)
        cupLabel.zPosition = 1
        addChild(cupLabel)
        
        //score label
        let score = SKLabelNode(text: String(score))
        score.fontName = "gangOfThree"
        score.fontSize = 50
        score.position = CGPoint(x: cupLabel.position.x + 70, y: cupLabel.position.y - 15)
        addChild(score)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            enumerateChildNodes(withName: "//*") { (node, stop) in
                if node.name == "startButton" {
                    if node.contains(touch.location(in: self)) {
                        // создаем экземпляр GameScene
                        guard let view = self.view else { return }
                        let gameScene = LevelScene(size: view.bounds.size)
                        
                        // создаем SKView и добавляем в нее сцену
                        let skView = view
                        skView.showsFPS = true // показываем FPS
                        skView.showsNodeCount = true // показываем количество узлов
                        skView.ignoresSiblingOrder = true
                        gameScene.scaleMode = .resizeFill
                        skView.presentScene(gameScene)
                    }
                } else if node.name == "treasuryButton" {
                    if node.contains(touch.location(in: self)) {
                        print("treasury")
                    }
                } else if node.name == "soundButton" {
                    if node.contains(touch.location(in: self)) {
                        print("sound")
                    }
                } else if node.name == "musicButton" {
                    if node.contains(touch.location(in: self)) {
                        print("music")
                    }
                } else if node.name == "infoButton" {
                    if node.contains(touch.location(in: self)) {
                        print("info")
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.scale(by: 0.95, duration: 0.05))
    }
}
