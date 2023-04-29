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
            saveScore()
            menuScene.score = score
            levelSelectScene.score = score
            treasuryScene.score = score
        }
    }
    
    private var menuScene = MenuScene(size: UIScreen.main.bounds.size)
    private var levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size)
    private var gameScene = GameScene(size: UIScreen.main.bounds.size, level: 1)
    private var infoScene = InfoScene(size: UIScreen.main.bounds.size)
    private var winScene = WinScene(size: UIScreen.main.bounds.size, score: 100, level: 1)
    private var loseScene = LoseScene(size: UIScreen.main.bounds.size, level: 1)
    private var treasuryScene = TreasuryScene(size: UIScreen.main.bounds.size)
    private var skView: SKView!
    
    private var currentScene: SKScene?
    private var prevScene: SKScene?
    
    private var currentGameScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getScoreFromLastGames()
        
        // создаем SKView и добавляем в нее сцену
        let skView = view as! SKView
        skView.showsFPS = true // показываем FPS
        skView.showsNodeCount = true // показываем количество узлов
        skView.ignoresSiblingOrder = true
        self.skView = skView
        currentScene = menuScene
        menuScene.score = score
        // here we can animate hottei
        skView.presentScene(menuScene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func getScoreFromLastGames() {
        score = UserDefaults.standard.integer(forKey: "score")
    }
    
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: "score")
    }
    
    func selectLevel() {
        prevScene = currentScene
        currentScene = levelSelectScene
        levelSelectScene.score = score
        skView.presentScene(levelSelectScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func showTreasure() {
        prevScene = currentScene
        currentScene = treasuryScene
        skView.presentScene(treasuryScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func startGame(level: Int) {
        let gameScen = GameScene(size: UIScreen.main.bounds.size, level: level)

        gameScen.name = "gameScene"
        currentGameScene = gameScen
        skView.presentScene(gameScen, transition: SKTransition.doorway(withDuration: 0.3))
    }
    
    func gameOver(with score: Int) {
        self.score += score
        if score == 0 {
            skView.presentScene(loseScene, transition: SKTransition.doorway(withDuration: 0.3))
        } else {
//            winScene.score = score
            skView.presentScene(winScene, transition: SKTransition.doorway(withDuration: 0.3))
        }
    }
    
    func showInfo() {        
        currentScene = infoScene
        skView.presentScene(currentScene!, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func home() {
        skView.presentScene(nil)
        currentScene = menuScene
        prevScene = nil
        skView.presentScene(currentScene!, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func back() {
        
        skView.presentScene(nil)
        
        currentScene = prevScene
        prevScene = nil
        guard let currentScene else { return }
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
}
