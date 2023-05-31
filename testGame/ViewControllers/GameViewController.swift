//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import SpriteKit
import AVFoundation
import SafariServices

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
    var bestTime: [Int:TimeInterval] = [1:0,
                                        2:0,
                                        3:0,
                                        4:0,
                                        5:0]
    
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
    private var matchSound: AVAudioPlayer?
    
    private let backgroundImageView = UIImageView()
    private let titleImageView = UIImageView()
    private let hotteiImageView = UIImageView()
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.backgroundImageView.removeFromSuperview()
            self.titleImageView.removeFromSuperview()
            self.hotteiImageView.removeFromSuperview()
            self.getAvailableLevel()
            self.getScoreFromLastGames()
            self.getBestTime()
            self.checkDailyBonus()
            self.setupAudio()
            self.setupScenes()
            self.setupSKView()
        }
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
    
    func gameOver(with score: Int, level: Int, time: TimeInterval) {
        if score == 0 {
            loseScene = LoseScene(size: UIScreen.main.bounds.size, level: level)
            prevScene = currentScene
            currentScene = loseScene
            skView.presentScene(loseScene, transition: SKTransition.crossFade(withDuration: 0.3))
            prevScene?.removeAllChildren()
            prevScene = nil
        } else {
            self.score += score
            if availableLevel < 5 {
                if availableLevel < level+1 {
                    availableLevel = level+1
                }
                saveLevel()
            }
            if bestTime[level]! == 0 {
                bestTime[level] = time
            } else if time < bestTime[level]! {
                bestTime[level] = time
                saveBestTime()
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
    
    func getBestTime() {
        if let data = UserDefaults.standard.data(forKey: "dictionaryKey") {
            // Unarchiving the Data into a [Int: TimeInterval] dictionary
            do {
                if let dictionary = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: data) as? [Int: TimeInterval] {
                    // Use the dictionary
                    self.bestTime = dictionary
                }
            } catch {
                print("Error while unarchiving the dictionary: \(error)")
            }
        }
    }
    
    func saveBestTime() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: bestTime, requiringSecureCoding: false)
            
            // Сохраняем объект Data в UserDefaults
            UserDefaults.standard.set(data, forKey: "dictionaryKey")
        } catch {
            print("Ошибка при архивации словаря: \(error)")
        }
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
    
    func makeMatchSound() {
        matchSound?.play()
    }
    
    func openURL() {
        let url = URL(string: "https://playtown.pro/pp.html")!
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    // MARK: Private methods
    private func animation() {
        backgroundImageView.image = UIImage(named: "splashBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.frame
        view.addSubview(backgroundImageView)
        
        hotteiImageView.image = UIImage(named: "splashHottei")
        hotteiImageView.contentMode = .scaleAspectFit
        hotteiImageView.frame = CGRect(x: 0, y: 0, width: 350, height: 600)
        hotteiImageView.center = CGPoint(x: view.frame.midX, y: view.frame.midY - 100)
        view.addSubview(hotteiImageView)
        
        titleImageView.image = UIImage(named: "splashName")
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.frame = CGRect(x: 0, y: 0, width: 280, height: 120)
        titleImageView.center = CGPoint(x: hotteiImageView.frame.midX, y: hotteiImageView.frame.midY + 230)
        view.addSubview(titleImageView)
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = hotteiImageView.layer.position.y
        animation.toValue = hotteiImageView.layer.position.y - 10
        animation.duration = 1.0
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        hotteiImageView.layer.add(animation, forKey: "position.y")
        
        hotteiImageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
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
        
        if let soundURL = Bundle.main.url(forResource: "matchSound", withExtension: "mp3") {
            do {
                matchSound = try AVAudioPlayer(contentsOf: soundURL)
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
