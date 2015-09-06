//
//  BlockNode.swift
//  Breaker
//

/* 1 */
import SpriteKit

/* 2 */
class BlockNode: SKNode {
    /* 3 */
    var image: SKSpriteNode!
    
    /* 4 */
    var toughness = 1 // Default value
  
  /* 5 */
  init(texture: SKTexture, toughness: Int) {
    self.toughness = toughness
    super.init()
    
    /* Add Image */
    addImage(texture)
    /* Add Shadow */
    addShadow()
    
  }
    
    /* 6 */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func addImage(texture: SKTexture) {
        /* 1 */
        image = SKSpriteNode(texture: texture)
        image.position = CGPoint(x: 0, y: 0)
        image.zPosition = 1
        addChild(image)
        
        /* 2 */
        physicsBody = SKPhysicsBody(rectangleOfSize: image.size)
        /* 3 */
        physicsBody!.dynamic = false
        /* 4 */
        physicsBody!.friction = 0.0
        /* 5 */
        physicsBody!.restitution = 1.0
        
        /* 6 */
        physicsBody!.categoryBitMask = ColliderCategory.Block.rawValue
        /* 7 */
        physicsBody!.collisionBitMask = ColliderCategory.Ball.rawValue
    }
    
    func addShadow() {
        /* 1 */
        let shadow = SKSpriteNode(imageNamed: "ShadowBlock")
        shadow.position = CGPoint(x: -1, y: -1)
        shadow.zPosition = 0
        addChild(shadow)
    }
    
    
    func gotHit() {
        /* 1 */
        toughness -= 1
       
        if toughness > 0 {
            /* 2 */
            let crack = SKSpriteNode(texture: SKTexture(imageNamed: "Crack"))
            crack.name = "Crack"
            image.addChild(crack)
        } else {
           /* 3 */
            removeFromParent()
        }
    }
}