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
    private var scoreLabel = ASAttributedLabelNode(size: CGSize())
    
    var score = 0 {
        didSet {
            scoreLabel.attributedString = getAttrubutedString(with: String(score), font: "gangOfThree", size: 58)
        }
    }
    
    override func didMove(to view: SKView) {
        setupUI()
        setupMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                
                switch node.name {
                    case "startButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.selectLevel() }])
                        self.run(sequence)
                    case "treasuryButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.showTreasury() }])
                        self.run(sequence)
                    case "soundButton":
                        let action = SKAction.run {
                            if !self.gameController.isSoundMuted {
                                self.soundButton.texture = SKTexture(imageNamed: "soundUnmuteButton")
                                self.gameController.isSoundMuted = true
                                self.gameController.clickButtonSoundAction = SKAction()
                            } else {
                                self.soundButton.texture = SKTexture(imageNamed: "soundButton")
                                self.gameController.isSoundMuted = false
                                self.gameController.clickButtonSoundAction = SKAction.playSoundFileNamed("clickSound.mp3", waitForCompletion: false)
                            }
                        }
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, action])
                        self.run(sequence)
                    case "musicButton":
                        let action = SKAction.run {
                            if !self.gameController.isMusicMuted {
                                self.gameController.removeMusic()
                                self.musicButton.texture = SKTexture(imageNamed: "musicUnmuteButton")
                                self.gameController.isMusicMuted = true
                            } else {
                                self.gameController.setupMusic()
                                self.setupMusic()
                                self.musicButton.texture = SKTexture(imageNamed: "musicButton")
                                self.gameController.isMusicMuted = false
                            }
                        }
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, action])
                        self.run(sequence)
                    case "infoButton":
                        let sequence = SKAction.sequence([gameController.clickButtonSoundAction, SKAction.run { self.gameController.showInfo() }])
                        self.run(sequence)
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
        let musicImage = gameController.isMusicMuted ? "musicUnmuteButton" : "musicButton"
        musicButton = SKSpriteNode(imageNamed: musicImage)
        musicButton.name = "musicButton"
        musicButton.position = CGPoint(x: treasuryButton.position.x - 50, y: treasuryButton.position.y - 100)
        addChild(musicButton)
        
        //sound button
        let soundImage = gameController.isSoundMuted ? "soundUnmuteButton" : "soundButton"
        soundButton = SKSpriteNode(imageNamed: soundImage)
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
        scoreLabel.attributedString = getAttrubutedString(with: String(score), font: "gangOfThree", size: 58)
        scoreLabel.position = CGPoint(x: cupLabel.position.x + 120, y: cupLabel.position.y + 2)
        addChild(scoreLabel)
    }
}
