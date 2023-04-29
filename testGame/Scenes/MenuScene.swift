//
//  MenuScene.swift
//  testGame
//
//  Created by Artour Ilyasov on 26.04.2023.
//

import SpriteKit

class MenuScene: Scene {
    private var musicButton = SKSpriteNode()
    private var soundButton = SKSpriteNode()
    
    private var isSoundMuted = false
    private var isMusicMuted = false
    
    private var scoreLabel = SKLabelNode()
    
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    func setupUI() {
        setBackground(with: "menuBackground")
        
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
        musicButton = SKSpriteNode(imageNamed: "musicButton")
        musicButton.name = "musicButton"
        musicButton.position = CGPoint(x: treasuryButton.position.x - 50, y: treasuryButton.position.y - 100)
        addChild(musicButton)
        
        //sound button
        soundButton = SKSpriteNode(imageNamed: "soundButton")
        soundButton.name = "soundButton"
        soundButton.position = CGPoint(x: musicButton.position.x + 50, y: musicButton.position.y)
        addChild(soundButton)
        
        //info button
        let infoButton = SKSpriteNode(imageNamed: "infoShieldButton")
        infoButton.name = "infoButton"
        infoButton.position = CGPoint(x: soundButton.position.x + 50, y: soundButton.position.y)
        addChild(infoButton)
        
        //cup label
        let cupLabel = SKSpriteNode(imageNamed: "cup")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.midY + 300)
        cupLabel.zPosition = 1
        addChild(cupLabel)
        
        //score label
        scoreLabel = SKLabelNode(text: String(score))
        scoreLabel.fontName = "gangOfThree"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 80, y: cupLabel.position.y - 15)
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let gameController = self.view?.window?.rootViewController as? GameViewController else {
            fatalError("GameController not found")
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                switch node.name {
                    case "startButton": gameController.selectLevel(from: self)
                    case "treasuryButton": gameController.showTreasure(from: self)
                    case "soundButton":
                        if !self.isSoundMuted {
                            self.soundButton.texture = SKTexture(imageNamed: "soundButtonUnmute")
                        } else {
                            self.soundButton.texture = SKTexture(imageNamed: "soundButton")
                        }
                        self.isSoundMuted.toggle()
                    case "musicButton":
                        if !self.isMusicMuted {
                            self.musicButton.texture = SKTexture(imageNamed: "musicButtonUnmute")
                        } else {
                            self.musicButton.texture = SKTexture(imageNamed: "musicButton")
                        }
                        self.isMusicMuted.toggle()
                    case "infoButton": gameController.showInfo(from: self)
                    default: break
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.scale(by: 0.95, duration: 0.05))
    }
}
