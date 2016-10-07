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
    case background, block, paddle, ball, hud, message
}

// The categories of the game's objects for handling of the collisions
enum ColliderCategory: UInt32 {
    case ball = 1
    case block = 2
    case paddle = 4
    case spikes = 8
    case border = 16
}

