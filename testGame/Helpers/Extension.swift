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

extension UIColor {
    convenience init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
