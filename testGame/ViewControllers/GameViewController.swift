//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import SpriteKit

class GameViewController: UIViewController, SKViewDelegate {
    // MARK: Public properties
    var backgroundMusic = SKAudioNode()
    var clickButtonSoundAction = SKAction.playSoundFileNamed("clickSound.mp3", waitForCompletion: false)
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
    private var welcomeBonusScene = WelcomeBonusScene(size: UIScreen.main.bounds.size) {
        didSet {
            welcomeBonusScene.gameController = self
        }
    }
    private var menuScene = MenuScene(size: UIScreen.main.bounds.size)
    private var levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size, availableLevel: 1) {
        didSet {
            levelSelectScene.gameController = self
        }
    }
    private var treasuryScene = TreasuryScene(size: CGSize(), score: 0) {
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
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAvailableLevel()
        getScoreFromLastGames()
        checkDailyBonus()
        setupMusic()
        setupScenes()
        setupSKView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Public methods
    func setupMusic() {
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            isMusicMuted = false
            backgroundMusic = SKAudioNode(url: musicURL)
            // change volume of background music here
            backgroundMusic.run(SKAction.changeVolume(to: 0.1, duration: 0))
            backgroundMusic.autoplayLooped = true
        }
    }
    
    func removeMusic() {
        isMusicMuted = true
        backgroundMusic.removeFromParent()
        backgroundMusic = SKAudioNode()
    }
    
    func presentMenu() {
        backgroundMusic.removeFromParent()
        prevScene = currentScene
        currentScene = menuScene
        skView.presentScene(menuScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
        prevScene = nil
    }
    
    func selectLevel() {
        backgroundMusic.removeFromParent()
        prevScene = currentScene
        currentScene = levelSelectScene
        skView.presentScene(levelSelectScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func showTreasury() {
        backgroundMusic.removeFromParent()
        prevScene = currentScene
        currentScene = treasuryScene
        skView.presentScene(treasuryScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func startGame(level: Int) {
        backgroundMusic.removeFromParent()
        gameScene = GameScene(size: UIScreen.main.bounds.size, level: level)
        prevScene = currentScene
        currentScene = gameScene
        skView.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
        prevScene = nil
    }
    
    func gameOver(with score: Int, level: Int) {
        backgroundMusic.removeFromParent()
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
        backgroundMusic.removeFromParent()
        prevScene = currentScene
        currentScene = infoScene
        skView.presentScene(infoScene, transition: SKTransition.crossFade(withDuration: 0.3))
        prevScene?.removeAllChildren()
    }
    
    func home() {
        backgroundMusic.removeFromParent()
        currentScene.removeAllChildren()
        currentScene = menuScene
        prevScene = nil
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    func back() {
        backgroundMusic.removeFromParent()
        currentScene.removeAllChildren()
        currentScene = prevScene
        prevScene = nil
        skView.presentScene(currentScene, transition: SKTransition.crossFade(withDuration: 0.3))
    }
    
    // MARK: Private methods
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
