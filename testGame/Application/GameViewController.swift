//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SKViewDelegate {
    
    private var menuScene = MenuScene(size: UIScreen.main.bounds.size)
    private var levelSelectScene = LevelSelectScene(size: UIScreen.main.bounds.size)
    private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    private var infoScene = InfoScene(size: UIScreen.main.bounds.size)
    private var skView: SKView!
    
    private var currentScene: SKScene?
    private var prevScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        infoScene.name = "infoScene"
        menuScene.name = "menuScene"
        levelSelectScene.name = "levelSelectScene"
        
        // создаем SKView и добавляем в нее сцену
        let skView = view as! SKView
        skView.showsFPS = true // показываем FPS
        skView.showsNodeCount = true // показываем количество узлов
        skView.ignoresSiblingOrder = true
        skView.delegate = self
        self.skView = skView
        currentScene = menuScene
        skView.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
        
        
    }
    
    func selectLevel() {
//        prevScene = currentScene
//        currentScene = levelSelectScene
        skView.presentScene(levelSelectScene, transition: SKTransition.fade(withDuration: 0.3))
        
//        print("curr scene")
//        print(currentScene?.name)
//        print("prev scene")
//        print(prevScene?.name)
    }
    
    //желательно сделать чтобы каждая функция тут имела входные параметры, чтобы её не могли вызывать откуда попало
    
    func startGame(level: Int) {

        switch level {
        case 2: gameScene.images += ["redPanda"]
        case 3: gameScene.images += ["redPanda", "panda"]
        case 4: gameScene.images += ["redPanda", "panda"]
                gameScene.moves = 15
        case 5: gameScene.images += ["redPanda", "panda"]
                gameScene.moves = 10
        default:
            break
        }
        
        gameScene.level = level
        skView.presentScene(gameScene, transition: SKTransition.doorway(withDuration: 0.3))
    }
    
    func gameOver(with score: Int) {
        
    }
    
    func showInfo() {
        
//        print("\n")
//        print("curr scene")
//        print(currentScene?.name)
//        print("prev scene")
//        print(prevScene?.name)
        
        
//        guard var currentScene else { return }
//        if currentScene.name != "infoScene" && prevScene == nil {
//            prevScene = currentScene
//            currentScene = infoScene
//            skView.presentScene(infoScene, transition: SKTransition.fade(withDuration: 0.3))
//        }
    }
    
    func home() {
//        currentScene = menuScene
//        prevScene = nil
//        skView.presentScene(menuScene)
    }
    
    func back() {
//        currentScene?.view?.presentScene(nil)
//        currentScene = prevScene
//        prevScene = nil
//        guard let currentScene else { return }
//        skView.presentScene(currentScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
