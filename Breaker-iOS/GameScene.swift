//
//  GameScene.swift
//  Breaker
//
//  Created by Nikolaos Kechagias on 20/08/15.
//  Copyright (c) 2015 Nikolaos Kechagias. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate {
    // Loads the game's sounds
    let soundMessage = SKAction.playSoundFileNamed("Message.m4a", waitForCompletion: false)
    let soundLost = SKAction.playSoundFileNamed("LostLife.m4a", waitForCompletion: false)
    let soundLevelDone = SKAction.playSoundFileNamed("LevelDone.m4a", waitForCompletion: false)
    let soundBlock = SKAction.playSoundFileNamed("Block.m4a", waitForCompletion: false)
    
    // The paddle's image
    var paddle: PaddleNode!
    
    // This property defines the position of the paddle on y axis.
    let paddleOnY : CGFloat = 150
    
    // This property defines when the paddle is moving by the player
    var isPaddleMoving = false
    
    // This property defines when the ball is moving
    var isBallMoving = false
    
    // This property defines the number of rows in blocks array.
    let numberRows = 8
    // This property defines the number of columns in blocks array.
    let numberColumns = 7
    
    // This property defines the number of levels.
    let totalLevels = 5
    
    var scoreLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    var livesLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    /* 2 */
    var lives: Int = 200 {
        didSet {
            /* 3 */
            livesLabel.text = "Lives: \(lives)"
        }
    }
    
    
    var levelLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    /* 2 */
    var level: Int = 1 {
        didSet {
            /* 3 */
            levelLabel.text = "Level: \(level)"
        }
    }

    
    
    
    
    
    override func didMove(to view: SKView) {
        /* Add Background */
        addBackground()
        
        /* Init Physics World */
        initPhysicsWorld()
        
        /* Add Paddle */
        addPaddle()
        
        /* Add Ball */
        addBall()
        
        /* Add Blocks */
        addBlocks()

        
        /* Add Spikes */
        addSpikes()
        
        /* Init HUD */
        addHUD()
        
    }
    
    func addBlocks() {
        /* 1 */
        let blocksArray = loadLevelFromFile("Level\(level).json")
        
        /* 2 */
        for row in 0 ..< numberRows {
            for column in 0 ..< numberColumns {
                if blocksArray[row][column] > 0 {
                    /* 3 */
                    let filename = "Block-\(blocksArray[row][column])"
                    var toughness = 1
                    if blocksArray[row][column] > 7 {
                        toughness = 2
                    }
                    /* 4 */
                    addOneBlock(row, column: column, filename: filename, toughness: toughness)
                }
            }
        }
    }
    
    
    
    func addOneBlock(_ row: Int, column: Int, filename: String, toughness: Int) {
        let margin: CGFloat = 28 // Defines the space between the edge of the screen and the blocks array
        let offset: CGFloat = 2  // Defines the space between the blocks
        let width: CGFloat = 100 // Defines the width of the block
        let height: CGFloat = 40 // Defines the height of the block
       
        /* 1 */
        let xPos: CGFloat = margin + width / 2 + (width + offset) * CGFloat(column)
        let yPos = size.height - (3 * margin + height * 0.50 + (height + offset) * CGFloat(row))
        
        /* 2 */
        let block = BlockNode(texture: SKTexture(imageNamed: filename), toughness: toughness)
        block.zPosition = zOrderValue.block.rawValue
        block.name = "Block"
        block.position = CGPoint(x: xPos, y: yPos)
        addChild(block)
    }

    
    func loadLevelFromFile(_ filename: String) -> [[Int]] {
        /* 1 */
        let path = Bundle.main.path(forResource: filename, ofType: nil)
        
        /* 2 */
        var data: Data!
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path!), options: Data.ReadingOptions())
        } catch {
            print("Error: Invalid file")
        }
        
        /* 3 */
        
        var dictionary: NSDictionary!
        do {
            dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
        } catch {
            print("Error: Invalid file format")
        }
               /* 4 */
        return dictionary["blocks"] as! [[Int]]
    }


    
    // MARK: - User Interface
    
    func addHUD() {
        /* 1 */
        levelLabel.text = "Level: \(level)"
        levelLabel.fontSize = 32
        levelLabel.fontColor = SKColor(red: 1.0, green: 0.0, blue :0.0, alpha: 1.0)
        levelLabel.zPosition = 10
        levelLabel.position = CGPoint(x: size.width * 0.15, y: size.height - levelLabel.fontSize)
        addChild(levelLabel)
        
        /* 1 */
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = SKColor(red: 1.0, green: 0.0, blue :0.0, alpha: 1.0)
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: size.width * 0.50, y: size.height - scoreLabel.fontSize)
        addChild(scoreLabel)

        /* 1 */
        livesLabel.text = "Lives: \(lives)"
        livesLabel.fontSize = 32
        livesLabel.fontColor = SKColor(red: 1.0, green: 0.0, blue :0.0, alpha: 1.0)
        livesLabel.zPosition = 10
        livesLabel.position = CGPoint(x: size.width * 0.85, y: size.height - livesLabel.fontSize)
        addChild(livesLabel)

    }

    
    // MARK: - Create Level
    
    func addSpikes() {
        /* 1 */
        let spikes = SKSpriteNode(texture: SKTexture(imageNamed: "Spikes"))
        spikes.position = CGPoint(x: size.width / 2, y: spikes.size.height / 10)
        addChild(spikes)
        
        /* 2 */
        spikes.physicsBody = SKPhysicsBody(rectangleOf: spikes.size)
        spikes.physicsBody?.isDynamic = false
        spikes.physicsBody?.categoryBitMask = ColliderCategory.spikes.rawValue
    }

    
    func addBall() {
        /* 1 */
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "Ball"))
        ball.name = "Ball"
        ball.position = CGPoint(x: size.width / 2, y: paddleOnY + ball.size.height / 2)
        ball.zPosition = zOrderValue.ball.rawValue
        addChild(ball)
        
        /* 2 */
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        /* 3 */
        ball.physicsBody?.friction = 0.0
        /* 4 */
        ball.physicsBody?.restitution = 1.0
        /* 5 */
        ball.physicsBody?.allowsRotation = false
        /* 6 */
        ball.physicsBody?.linearDamping = 0.0
        
        /* 7 */
        ball.physicsBody?.categoryBitMask = ColliderCategory.ball.rawValue
        /* 8 */
        ball.physicsBody?.collisionBitMask = ColliderCategory.block.rawValue | ColliderCategory.paddle.rawValue | ColliderCategory.spikes.rawValue | ColliderCategory.border.rawValue
        /* 9 */
        ball.physicsBody?.contactTestBitMask = ColliderCategory.spikes.rawValue | ColliderCategory.block.rawValue
    }

    
    func addPaddle() {
        /* 1 */
        paddle = PaddleNode()
        paddle.name = "Paddle"
        paddle.position = CGPoint(x: size.width / 2, y: paddleOnY)
        addChild(paddle)
    }

    
    // MARK: - Physics
    
    func initPhysicsWorld() {
        /* 1 */
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        /* Enable Contacts notifications */
        physicsWorld.contactDelegate = self
        
        /* 2 */
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        /* 3 */
        physicsBody?.friction = 0.0
        
        /* 4 */
        physicsBody?.categoryBitMask = ColliderCategory.border.rawValue
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* 1 */
        let categoryA = contact.bodyA.categoryBitMask;
        let categoryB = contact.bodyB.categoryBitMask;
        
        /* 2 */
        if categoryA == ColliderCategory.ball.rawValue && categoryB == ColliderCategory.block.rawValue {
            let block = contact.bodyB.node as! BlockNode
            contactBallWithBlock(block)
        } else if categoryB == ColliderCategory.ball.rawValue && categoryA == ColliderCategory.block.rawValue {
            let block = contact.bodyA.node as! BlockNode
            contactBallWithBlock(block)
        } else if categoryA == ColliderCategory.ball.rawValue && categoryB == ColliderCategory.spikes.rawValue {
            /* Contact Ball With Spikes A */
            contactBallWithSpikes(contact.bodyA.node as! SKSpriteNode)
        } else if categoryB == ColliderCategory.ball.rawValue && categoryA == ColliderCategory.spikes.rawValue {
            /* Contact Ball With Spikes B */
            contactBallWithSpikes(contact.bodyB.node as! SKSpriteNode)
        }
        
        /* Level Completed */
        checkIfLevelCompleted()
    }
    
    func contactBallWithBlock(_ block: BlockNode) {
        /* 1 */
        run(soundBlock)
        block.gotHit()
        /* Update Score */
        updateScore()
    }

    
    func updateScore() {
        score += 10
    }
    
    func checkIfLevelCompleted() {
        /* 1 */
        let brick = childNode(withName: "Block")
        if brick == nil {
            /* 2 */
            run(soundLevelDone)
            /* 3 */
            showMessage("LevelCompleted")
            /* 4 */
            physicsWorld.speed = 0
        }
    }

    
    func nextBall() {
        /* 1 */
        let time = abs(paddle.position.x - size.width * 0.50) / 200
        /* 2 */
        let move = SKAction.move(to: CGPoint(x: size.width / 2, y: paddleOnY), duration: TimeInterval(time))
        paddle.run(move, completion: {
            /* 3 */
            self.isBallMoving = false
            /* 4 */
            self.addBall()
        })
    }

    func showMessage(_ imageNamed: String) {
        /* 1 */
        let panel = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed))
        panel.name = imageNamed
        panel.zPosition = zOrderValue.message.rawValue
        panel.position = CGPoint(x: size.width / 2, y: -size.height)
        addChild(panel)
        
        /* 2 */
        let move = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.5)
        panel.run(SKAction.sequence([soundMessage, move]))
    }

    
    func contactBallWithSpikes(_ ball: SKSpriteNode) {
        /* 1 */
        run(soundLost)
        /* 2 */
        ball.removeFromParent()
        /* 3 */
        if lives > 0 {
            lives -= 1
            nextBall()
        } else {
            showMessage("GameOver")
        }
    }

    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "Background")
        background.name = "Background"
        background.zPosition = zOrderValue.background.rawValue
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
    }

    func newGame() {
        /* 1 */
        removeAllActions()
        removeAllChildren()
        isPaddleMoving = false
        isBallMoving = false
        score = 0
        lives = 2
        level = 1
        
        /* 2 */
        addBackground()
        addBall()
        addPaddle()
        addBlocks()
        addSpikes()
        addHUD()
    }

    func loadNextLevel() {
        /* 1 */
        removeAllActions()
        removeAllChildren()
        isPaddleMoving = false
        isBallMoving = false
        physicsWorld.speed = 1
        
        /* 2 */
        if level < totalLevels {
            level += 1
        }
        
        /* 3 */
        addBackground()
        addBall()
        addPaddle()
        addBlocks()
        addSpikes()
        addHUD()
    }

    func shootBall() {
        if !isBallMoving && !isPaddleMoving {
            isBallMoving = true
            let ball = childNode(withName: "Ball") as! SKSpriteNode
            ball.physicsBody?.velocity = CGVector(dx: 450.0, dy: -450.0)
        }
    }
    
    func ballFollowsPaddle(_ position: CGFloat) {
        if !isBallMoving {
            let ball = childNode(withName: "Ball") as! SKSpriteNode
            ball.position = CGPoint(x: position, y: ball.position.y)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = atPoint(location!)
        
        /* Start New Game */
        let gameOver = childNode(withName: "GameOver")
        if gameOver != nil {
            newGame()
            return
        }
        
        /* Load Next Level */
        let nextLevel = childNode(withName: "LevelCompleted")
        if nextLevel != nil {
            loadNextLevel()
            return
        }
        
        /* 2 */
        if node.name == "Paddle" {
            isPaddleMoving = true
        } else {
            shootBall()
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPaddleMoving = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if isPaddleMoving {
            /* 2 */
            var paddleX = location!.x
            paddleX = max(paddleX, paddle.calculateAccumulatedFrame().size.width / 2)
            paddleX = min(paddleX, size.width - paddle.calculateAccumulatedFrame().size.width / 2)
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
            
            /* Ball Follows Paddle */
            ballFollowsPaddle(paddleX)
            
        }
        
    }
    
}
