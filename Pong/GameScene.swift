//
//  GameScene.swift
//  Pong
//
//  Created by Joe Holt on 8/27/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let gridSize: Int       = 40    //Size of game grid
    private let updateGame: Int     = 15    //Update game every x frames
    private var ball: BouncyBall!           //Ball
    private var mainView: SKView!           //Mainview
    private var frameCounter: Int   = 0     //Current frame

    
    override func didMove(to view: SKView) {
        self.mainView = view
        self.ball = BouncyBall()
        ball.posistion = CGPoint(x: -15,y: 0)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if frameCounter == updateGame {
            updateBall()
            frameCounter = 0
        } else {
            frameCounter += 1
        }
    }
    
    private func updateBall() {
        //Find next posistion for ball
        let newBallPosistion = CGPoint(x: ball.posistion.x + ball.speed.x, y: ball.posistion.y + ball.speed.y)
        //Check if it is within bounds and update speed if it is
        var gridBound: CGFloat = (CGFloat(gridSize)/2.0)
        gridBound = gridBound - (gridBound * 0.1)           //Makes the grid line up with the window better
        if newBallPosistion.x > gridBound {
            ball.speed.x = -1
        }
        if newBallPosistion.x < -gridBound {
            ball.speed.x = 1
        }
        if newBallPosistion.y > gridBound {
            ball.speed.y = -1
        }
        if newBallPosistion.y < -gridBound {
            ball.speed.y = 1
        }
        drawSquare(x: Int(newBallPosistion.x), y: Int(newBallPosistion.y))
        removeSquare(x: Int(ball.posistion.x), y: Int(ball.posistion.y))
        ball.posistion = newBallPosistion
    }
    
    private func drawSquare(x: Int, y: Int, color: SKColor = SKColor.white) {
        let height = mainView.frame.size.height/CGFloat(gridSize)
        let xDim = (mainView.frame.size.width/CGFloat(gridSize)) * CGFloat(x)
        let yDim = (mainView.frame.size.height/CGFloat(gridSize)) * CGFloat(y)
        let square = SKSpriteNode()
        square.position = CGPoint(x: xDim, y: yDim)
        square.size = CGSize(width: height - 2, height: height - 2)
        square.color = color
        addChild(square)
    }
    
    private func removeSquare(x: Int, y: Int) {
        let xDim = (mainView.frame.size.width/CGFloat(gridSize)) * CGFloat(x)
        let yDim = (mainView.frame.size.height/CGFloat(gridSize)) * CGFloat(y)
        let nodesAtPoint = nodes(at: CGPoint(x: xDim, y: yDim))
        for node in nodesAtPoint {
            node.removeFromParent()
        }
    }
    
}
