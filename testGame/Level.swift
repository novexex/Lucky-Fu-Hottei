//
//  Level.swift
//  testGame
//
//  Created by Artour Ilyasov on 26.04.2023.
//

import Foundation

class Level {
    let titles: Int
    let moves: Int
    let points: Int
    
    init(titles: Int, moves: Int, points: Int) {
        self.titles = titles
        self.moves = moves
        self.points = points
    }
}
