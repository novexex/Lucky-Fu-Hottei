//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SKViewDelegate {
    
    private var score = 0 {
        didSet {
            UserDefaults.standard.set(score, forKey: "score")
            menuScene.score = score
            levelSelectScene.score = score
        }
    }
    
    private var menuScene = MenuScene(size: UIScreen.main.bounds.size)
    private var levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size)
    private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    private var infoScene = InfoScene(size: UIScreen.main.bounds.size)
    private var winScene = WinScene(size: UIScreen.main.bounds.size)
    private var loseScene = LoseScene(size: UIScreen.main.bounds.size)
    private var treasuryScene = TreasuryScene(size: UIScreen.main.bounds.size)
    private var skView: SKView!
    
    private var currentScene: SKScene?
    private var prevScene: SKScene?
    
    private var currentGameScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedScore = UserDefaults.standard.integer(forKey: "score")
        score = savedScore
        
        infoScene.name = "infoScene"
        menuScene.name = "menuScene"
        levelSelectScene.name = "levelSelectScene"
        gameScene.name = "gameScene"
        winScene.name = "winScene"
        loseScene.name = "loseScene"
        treasuryScene.name = "treasuryScene"
        
        // создаем SKView и добавляем в нее сцену
        let skView = view as! SKView
        skView.showsFPS = true // показываем FPS
        skView.showsNodeCount = true // показываем количество узлов
        skView.ignoresSiblingOrder = true
        skView.delegate = self
        self.skView = skView
        currentScene = menuScene
        menuScene.score = score
        skView.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    func selectLevel(from: SKScene) {
        prevScene = currentScene
        currentScene = levelSelectScene
        levelSelectScene.score = score
        skView.presentScene(levelSelectScene, transition: SKTransition.fade(withDuration: 0.3))
    }
    
    func showTreasure(from: SKScene) {
        prevScene = currentScene
        currentScene = treasuryScene
        skView.presentScene(treasuryScene, transition: SKTransition.fade(withDuration: 0.3))
    }
    
    func startGame(level: Int) {
        let gameScen = GameScene(size: UIScreen.main.bounds.size)
        switch level {
        case 2: gameScen.images += ["redPanda"]
        case 3: gameScen.images += ["redPanda", "panda"]
        case 4: gameScen.images += ["redPanda", "panda"]
            gameScen.moves = 15
        case 5: gameScen.images += ["redPanda", "panda"]
            gameScen.moves = 10
        default:
            break
        }
        
        gameScen.level = level
        gameScen.name = "gameScene"
        currentGameScene = gameScen
        skView.presentScene(gameScen, transition: SKTransition.doorway(withDuration: 0.3))
    }
    
    func gameOver(with score: Int) {
        self.score += score
        if score == 0 {
            skView.presentScene(loseScene, transition: SKTransition.doorway(withDuration: 0.3))
        } else {
            winScene.score = score
            skView.presentScene(winScene, transition: SKTransition.doorway(withDuration: 0.3))
        }
    }
    
    func showInfo(from: SKScene) {
        
        switch from.name {
        case "menuScene":
            prevScene = menuScene
        case "levelSelectScene":
            prevScene = levelSelectScene
        case "gameScene":
            prevScene = gameScene
        case "winScene":
            prevScene = winScene
        case "loseScene":
            prevScene = loseScene
        case "treasuryScene":
            prevScene = treasuryScene
        default: break
        }
        
        currentScene = infoScene
        skView.presentScene(currentScene)
    }
    
    func home(from: SKScene) {
        skView.presentScene(nil)
        currentScene = menuScene
        prevScene = nil
        skView.presentScene(currentScene)
    }
    
    func back(from: SKScene) {
        
        skView.presentScene(nil)
        
        currentScene = prevScene
        prevScene = nil
        guard let currentScene else { return }
        skView.presentScene(currentScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
