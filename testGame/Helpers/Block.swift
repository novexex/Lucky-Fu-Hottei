
import SpriteKit

class Block {
    let block: SKSpriteNode
    
    let number: Int
    
    let leftLine: SKSpriteNode
    let rightLine: SKSpriteNode
    let upLine: SKSpriteNode
    let downLine: SKSpriteNode
    
    var lines = [SKSpriteNode]()
    
    var numberOfFilledLines: Int {
        var number = 0
        for i in lines {
            if i.alpha == 1 {
                number += 1
            }
        }
        return number
    }
    
    init(block: SKSpriteNode, number: Int, leftLine: SKSpriteNode, rightLine: SKSpriteNode, upLine: SKSpriteNode, downLine: SKSpriteNode) {
        self.block = block
        self.number = number
        self.leftLine = leftLine
        self.rightLine = rightLine
        self.upLine = upLine
        self.downLine = downLine
        lines = [leftLine, rightLine, upLine, downLine]
    }
    
    init() {
        self.block = SKSpriteNode()
        self.number = Int()
        self.leftLine = SKSpriteNode()
        self.rightLine = SKSpriteNode()
        self.upLine = SKSpriteNode()
        self.downLine = SKSpriteNode()
    }
}
