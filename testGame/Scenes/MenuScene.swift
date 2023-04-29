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
    
    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    
    var score = 0 {
        didSet {
            scoreLabel.attributedString = getAttrubutedString(with: String(score))
        }
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
                    case "startButton": gameController.selectLevel()
                    case "treasuryButton": gameController.showTreasure()
                    case "soundButton":
                        if !self.isSoundMuted {
                            self.soundButton.texture = SKTexture(imageNamed: "soundUnmuteButton")
                            self.isSoundMuted = true
                        } else {
                            self.soundButton.texture = SKTexture(imageNamed: "soundButton")
                            self.isSoundMuted = false
                        }
                    case "musicButton":
                        if !self.isMusicMuted {
                            self.musicButton.texture = SKTexture(imageNamed: "musicUnmuteButton")
                            self.isMusicMuted = true
                        } else {
                            self.musicButton.texture = SKTexture(imageNamed: "musicButton")
                            self.isMusicMuted = false
                        }
                    case "infoButton": gameController.showInfo()
                    default: break
                }
            }
        }
    }
    
    private func setupUI() {
        setBackground(with: "menuBackground")
        
        //hottei
        let buda = SKSpriteNode(imageNamed: "hottei")
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
        let cupLabel = SKSpriteNode(imageNamed: "cupLabel")
        cupLabel.position = CGPoint(x: frame.midX - 50, y: frame.midY + 300)
        addChild(cupLabel)
        
        //score label
        scoreLabel = ASAttributedLabelNode(size: cupLabel.size)
        scoreLabel.attributedString = getAttrubutedString(with: String(score))
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
    }
}
