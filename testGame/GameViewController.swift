//
//  GameViewController.swift
//  testGame
//
//  Created by Artour Ilyasov on 25.04.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene: MenuScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // создаем экземпляр GameScene
        gameScene = MenuScene(size: view.bounds.size)
        
        // создаем SKView и добавляем в нее сцену
        let skView = view as! SKView
        skView.showsFPS = true // показываем FPS
        skView.showsNodeCount = true // показываем количество узлов
        skView.ignoresSiblingOrder = true
        gameScene.scaleMode = .resizeFill
        skView.presentScene(gameScene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
