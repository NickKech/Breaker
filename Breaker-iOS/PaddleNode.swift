//
//  PaddleNode.swift
//  Breaker
//
//  Created by Nikolaos Kechagias on 20/08/15.
//  Copyright © 2015 Nikolaos Kechagias. All rights reserved.
//

/* 1 */
import SpriteKit

/* 2 */
class PaddleNode: SKNode {
    
    /* 3 */
    override init() {
        super.init()
        
        /* Add Image */
        addImage()
        
        /* Add Shadow */
        addShadow()
        
    }
    
    /* 4 */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShadow() {
        /* 1 */
        let shadow = SKSpriteNode(imageNamed: "ShadowPaddle")
        shadow.position = CGPoint(x: -1, y: -1)
        shadow.zPosition = 0
        addChild(shadow)
    }
    
    func addImage() {
        /* 1 */
        let image = SKSpriteNode(imageNamed: "Paddle")
        image.position = CGPoint(x: 0, y: 0)
        image.zPosition = 1
        image.name = "Paddle"
        addChild(image)
        
        /* 2 */
        physicsBody = SKPhysicsBody(rectangleOf: image.size)
        /* 3 */
        physicsBody?.isDynamic = false
        /* 4 */
        physicsBody?.friction = 0.0
        /* 5 */
        physicsBody?.restitution = 1.0
        
        /* 6 */
        physicsBody?.categoryBitMask = ColliderCategory.paddle.rawValue
        /* 7 */
        physicsBody?.collisionBitMask = ColliderCategory.ball.rawValue

    }
    
   
}
