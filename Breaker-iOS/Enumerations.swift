//
//  Enumerations.swift
//  Breaker
//
//  Created by Nikolaos Kechagias on 20/08/15.
//  Copyright © 2015 Nikolaos Kechagias. All rights reserved.
//

import SpriteKit

// The drawing order of objects in z-axis (zPosition property)
enum zOrderValue: CGFloat {
    case Background, Block, Paddle, Ball, Hud, Message
}

// The categories of the game's objects for handling of the collisions
enum ColliderCategory: UInt32 {
    case Ball = 1
    case Block = 2
    case Paddle = 4
    case Spikes = 8
    case Border = 16
}

