//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import SpriteKit
import AVFoundation

class GameViewController: UIViewController, SKViewDelegate {
    // MARK: Public properties
    var isMusicMuted = false
    var isSoundMuted = false
    var score = 0 {
        didSet {
            saveScore()
            menuScene.score = score
            levelSelectScene.score = score
            welcomeBonusScene.score = score
            treasuryScene = TreasuryScene(size: UIScreen.main.bounds.size, score: score)
        }
    }
    
    // MARK: Private properties
    private var didReceiveDailyBonus = false
    private var availableLevel = 1 {
        didSet {
            levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size, availableLevel: availableLevel)
            levelSelectScene.score = score
        }
    }
    private var skView: SKView!
    private var welcomeBonusScene = WelcomeBonusScene(size: UIScreen.main.bounds.size)
    private var menuScene = MenuScene(size: UIScreen.main.bounds.size)
    private var levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size, availableLevel: 1) {
        didSet {
            levelSelectScene.gameController = self
        }
    }
    private var treasuryScene = TreasuryScene(size: UIScreen.main.bounds.size, score: 0) {
        didSet {
            treasuryScene.gameController = self
        }
    }
    private var infoScene = InfoScene(size: UIScreen.main.bounds.size)
    private var gameScene = GameScene(size: UIScreen.main.bounds.size, level: 1) {
        didSet {
            gameScene.gameController = self
        }
    }
    private var winScene = WinScene(size: UIScreen.main.bounds.size, score: 0, level: 1) {
        didSet {
            winScene.gameController = self
        }
    }
    private var loseScene = LoseScene(size: UIScreen.main.bounds.size, level: 1) {
        didSet {
            loseScene.gameController = self
        }
    }
    private var currentScene: SKScene!
    private var prevScene: SKScene?
    private var backgroundMusic: AVAudioPlayer?
    private var clickSound: AVAudioPlayer?
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAvailableLevel()
        getScoreFromLastGames()
        checkDailyBonus()
        setupAudio()
        setupScenes()
        setupSKView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Public methods
    func presentMenu() {
        clickSound?.play()
        prevScene = currentScene
        currentScene = menuScene
        skView.presentScene(menuScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
        prevScene = nil
    }
    
    func selectLevel() {
        clickSound?.play()
        prevScene = currentScene
        currentScene = levelSelectScene
        skView.presentScene(levelSelectScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func showTreasury() {
        clickSound?.play()
        prevScene = currentScene
        currentScene = treasuryScene
        skView.presentScene(treasuryScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func startGame(level: Int) {
        clickSound?.play()
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
                saveLevel()
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
        clickSound?.play()
        prevScene = currentScene
        currentScene = infoScene
        skView.presentScene(infoScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func home() {
        clickSound?.play()
        currentScene.removeAllChildren()
        currentScene = menuScene
        prevScene = nil
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func back() {
        clickSound?.play()
        currentScene.removeAllChildren()
        currentScene = prevScene
        prevScene = nil
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func makeClickSound() {
        clickSound?.play()
    }
    
    // MARK: Private methods
    private func setupAudio() {
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusic?.numberOfLoops = -1
                backgroundMusic?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let soundURL = Bundle.main.url(forResource: "clickSound", withExtension: "mp3") {
            do {
                clickSound = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupSKView() {
        let skView = SKView()
        self.view = skView
        skView.showsFPS = true // показываем FPS
        skView.showsNodeCount = true // показываем количество узлов
        skView.ignoresSiblingOrder = true
        self.skView = skView
        // here we can animate hottei
        skView.presentScene(currentScene)
    }
    
    private func setupScenes() {
        menuScene.gameController = self
        infoScene.gameController = self
        welcomeBonusScene.gameController = self
    }
    
    private func checkDailyBonus() {
        let today = Date()
        let lastBonusDate = UserDefaults.standard.object(forKey: "lastBonusDate") as? Date
        if let lastBonusDate {
            didReceiveDailyBonus = Calendar.current.isDateInToday(lastBonusDate)
        }
        if !didReceiveDailyBonus {
            currentScene = welcomeBonusScene
            UserDefaults.standard.set(today, forKey: "lastBonusDate")
            didReceiveDailyBonus = true
        } else {
            currentScene = menuScene
        }
    }
    
    private func getAvailableLevel() {
        availableLevel = UserDefaults.standard.integer(forKey: "availableLevel")
        if availableLevel == 0 {
            availableLevel = 1
        }
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
}
