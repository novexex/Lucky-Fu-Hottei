//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SKViewDelegate {
    
    private var didReceiveDailyBonus = false
    private var availableLevel = 1 {
        didSet {
            saveLevel()
            levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size, availableLevel: availableLevel)
            levelSelectScene.score = score
        }
    }
    var score = 0 {
        didSet {
            saveScore()
            menuScene.score = score
            levelSelectScene.score = score
            welcomeBonusScene.score = score
            treasuryScene = TreasuryScene(size: UIScreen.main.bounds.size, score: score)
        }
    }
    
    private var skView: SKView!
    
    private var welcomeBonusScene = WelcomeBonusScene(size: UIScreen.main.bounds.size)
    private var menuScene = MenuScene(size: UIScreen.main.bounds.size)
    private var levelSelectScene = LevelSelectScene(size: CGSize(), availableLevel: 1)
    private var treasuryScene = Scene()
    private var infoScene = InfoScene(size: UIScreen.main.bounds.size)
    private var gameScene = Scene()
    private var winScene = Scene()
    private var loseScene = Scene()
    
    private var currentScene: SKScene!
    private var prevScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAvailableLevel()
        getScoreFromLastGames()
        checkDailyBonus()
        
        let skView = SKView()
        self.view = skView
        skView.showsFPS = true // показываем FPS
        skView.showsNodeCount = true // показываем количество узлов
        skView.ignoresSiblingOrder = true
        self.skView = skView
        // here we can animate hottei
        skView.presentScene(currentScene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func checkDailyBonus() {
        // Получение даты сегодня
        let today = Date()

        // Получение даты последнего получения бонуса из UserDefaults
        let lastBonusDate = UserDefaults.standard.object(forKey: "lastBonusDate") as? Date

        // Проверяем, получал ли пользователь бонус сегодня
        if let lastBonusDate {
            didReceiveDailyBonus = Calendar.current.isDateInToday(lastBonusDate)
        }

        if !didReceiveDailyBonus {
            // Выполняем получение ежедневного бонуса
            currentScene = welcomeBonusScene
            
            // Сохраняем дату получения бонуса в UserDefaults
            UserDefaults.standard.set(today, forKey: "lastBonusDate")
            didReceiveDailyBonus = true
        } else {
            currentScene = menuScene
        }
    }
    
    private func getAvailableLevel() {
        availableLevel = UserDefaults.standard.integer(forKey: "availableLevel")
    }
    
    private func getScoreFromLastGames() {
        score = UserDefaults.standard.integer(forKey: "score")
    }
    
    private func saveLevel() {
        UserDefaults.standard.set(availableLevel, forKey: "availableLevel")
    }
    
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: "score")
    }
    
    func presentMenu() {
        prevScene = currentScene
        currentScene = menuScene
        skView.presentScene(menuScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
        prevScene = nil
    }
    
    func selectLevel() {
        prevScene = currentScene
        currentScene = levelSelectScene
        skView.presentScene(levelSelectScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func showTreasury() {
        prevScene = currentScene
        currentScene = treasuryScene
        skView.presentScene(treasuryScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func startGame(level: Int) {
        gameScene = GameScene(size: UIScreen.main.bounds.size, level: level)
        prevScene = currentScene
        currentScene = gameScene
        skView.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
        prevScene = nil
    }
    
    func gameOver(with score: Int, level: Int) {
        self.score += score
        if score == 0 {
            loseScene = LoseScene(size: UIScreen.main.bounds.size, level: level)
            prevScene = currentScene
            currentScene = loseScene
            skView.presentScene(loseScene, transition: SKTransition.crossFade(withDuration: 0.3))
            prevScene?.removeAllChildren()
            prevScene = nil
        } else {
            if availableLevel < 5 {
                availableLevel += 1
            }
            winScene = WinScene(size: UIScreen.main.bounds.size, score: score, level: level)
            prevScene = currentScene
            currentScene = winScene
            skView.presentScene(winScene, transition: SKTransition.crossFade(withDuration: 0.3))
            prevScene?.removeAllChildren()
            prevScene = nil
        }
    }
    
    func showInfo() {
        prevScene = currentScene
        currentScene = infoScene
        skView.presentScene(infoScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func home() {
        currentScene.removeAllChildren()
        currentScene = menuScene
        prevScene = nil
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func back() {
        currentScene.removeAllChildren()
        currentScene = prevScene
        prevScene = nil
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
}
