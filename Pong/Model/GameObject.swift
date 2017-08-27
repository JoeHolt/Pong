//
//  GameObject.swift
//  Pong
//
//  Created by Joe Holt on 8/27/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import Cocoa

class GameObject: NSObject {
    
    internal var size: CGSize!
    internal var speed: CGPoint!
    internal var body: [CGPoint] = []
    internal var posistion: CGPoint!
    
    init(_ size: CGSize, initialPosistion posistion: CGPoint, initialSpeed speed: CGPoint) {
        super.init()
        self.size = size
        self.posistion = posistion
        self.speed = speed
        //Set body
        var buildLocation = posistion
        body.append(posistion)
        while body.count != Int(size.height) {
            buildLocation.y -= 1
            body.append(buildLocation)
        }
    }
}
