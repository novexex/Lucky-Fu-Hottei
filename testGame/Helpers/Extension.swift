//
//  Extension.swift
//  testGame
//
//  Created by Artour Ilyasov on 26.04.2023.
//

import SpriteKit

extension SKSpriteNode {
    func scale(to screenWidth: CGFloat) {
        let aspectRatio = self.size.height / self.size.width
        self.size = CGSize(width: screenWidth, height: screenWidth * aspectRatio)
    }
}
