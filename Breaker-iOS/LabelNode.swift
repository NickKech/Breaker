//
//  LabelNode.swift
//
//  Created by Nikolaos Kechagias on 28/4/15.
//  Copyright (c) 2015 Nikolaos Kechagias. All rights reserved.
//

/* 1 */
import SpriteKit

/* 2 */
class LabelNode: SKNode {
    private var label: SKLabelNode!
    private var shadow: SKLabelNode!
    
    var text: String = "" {
        didSet {
            label.text = text
            shadow.text = text
        }
    }
    
    var fontSize: CGFloat! {
        didSet {
            label.fontSize = fontSize
            shadow.fontSize = fontSize
        }
    }
    
    var fontColor: SKColor = SKColor.whiteColor() {
        didSet {
            label.fontColor = fontColor
        }
        
    }
    
    var shadowColor: SKColor = SKColor.blackColor() {
        didSet {
            shadow.fontColor = shadowColor
        }
    }
    
    
    var verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center {
        didSet {
            label.verticalAlignmentMode = verticalAlignmentMode
            shadow.verticalAlignmentMode = verticalAlignmentMode
        }
    }
    
    var horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center {
        didSet {
            label.horizontalAlignmentMode = horizontalAlignmentMode
            shadow.horizontalAlignmentMode = horizontalAlignmentMode
        }
    }
    
    /* 3 */
    init(fontNamed: String) {
        super.init()
        /* Add Label */
        addLabel(fontNamed)
        
        /* Add Shadow */
        addShadow(fontNamed)
    }
    
    /* 4 */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(fontNamed: String) {
        label = SKLabelNode(fontNamed: fontNamed)
        label.fontColor = fontColor
        label.zPosition = 1
        label.position = CGPoint(x: 0, y: 0)
        addChild(label)
    }
    
    func addShadow(fontNamed: String) {
        shadow = SKLabelNode(fontNamed: fontNamed)
        shadow.fontColor = shadowColor
        shadow.zPosition = 0
        shadow.position = CGPoint(x: 1, y: -1)
        addChild(shadow)
    }
    
}
