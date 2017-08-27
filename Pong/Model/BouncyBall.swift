//
//  BouncyBall.swift
//  Pong
//
//  Created by Joe Holt on 8/27/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import Cocoa

class BouncyBall: NSObject {
    
    internal var posistion: CGPoint!
    internal var speed: CGPoint!
    
    override init() {
        self.posistion = CGPoint(x: 0, y: 0)
        self.speed = CGPoint(x: 1, y: 1)
    }

}
