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
    private var ball: GameObject!           //Ball
    private var lBumper: GameObject!        //Left bumper
    private var mainView: SKView!           //Mainview
    private var frameCounter: Int   = 0     //Current frame
    private var gridBounds: CGFloat {
        return CGFloat(gridSize/2)
    }

    
    override func didMove(to view: SKView) {
        self.mainView = view
        self.ball = GameObject(CGSize(width: 1.0, height: 1.0), initialPosistion: CGPoint(x: -15, y: 0), initialSpeed: CGPoint(x: 1, y: 1))
        self.lBumper = GameObject(CGSize(width: 1.0, height: 4.0), initialPosistion: CGPoint(x: -gridBounds + 2, y: 0), initialSpeed: CGPoint(x: 0, y: 0))
        drawBumper()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if frameCounter == updateGame {
            updateBall()
            updateBumpers()
            frameCounter = 0
        } else {
            frameCounter += 1
        }
    }
    
    override func keyDown(with event: NSEvent) {
        handleKeyEvent(event: event)
    }
    
    private func handleKeyEvent(event: NSEvent) {
        //print("Key pressed")
        let charachters = event.characters
        for char in charachters! {
            switch char {
            case "w":
                if lBumper.speed.y != 1 {
                    lBumper.body.reverse()
                    lBumper.posistion = lBumper.body.first
                }
                lBumper.speed = CGPoint(x: 0, y: 1)
            case "s":
                if lBumper.speed.y != -1 {
                    lBumper.body.reverse()
                    lBumper.posistion = lBumper.body.first
                }
                lBumper.speed = CGPoint(x: 0, y: -1)
                
            case " ":
                if self.scene?.view?.isPaused == true {
                    self.scene?.view?.isPaused = false
                } else {
                    self.scene?.view?.isPaused = true
                }
            default:
                lBumper.speed = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    private func updateBumpers() {
        let gridBound = self.gridBounds - (self.gridBounds * 0.1)   //Makes the grid line up with the window better
        if lBumper.speed.y != 0 && lBumper.posistion.y < gridBound && lBumper.posistion.y > -gridBound {
            let newPos = CGPoint(x: lBumper.posistion.x, y: lBumper.posistion.y + lBumper.speed.y)
            lBumper.posistion = newPos
            lBumper.body.insert(newPos, at: 0)
            removeSquare(x: Int((lBumper.body.last?.x)!), y: Int((lBumper.body.last?.y)!))
            lBumper.body.remove(at: lBumper.body.count-1)
            drawBumper()
        }
    }
    
    private func drawBumper() {
        for pos in lBumper.body {
            drawSquare(x: Int(pos.x), y: Int(pos.y), color: SKColor.purple)
        }
    }
    
    private func updateBall() {
        //Find next posistion for ball
        let newBallPosistion = CGPoint(x: ball.posistion.x + ball.speed.x, y: ball.posistion.y + ball.speed.y)
        //Check if it is within bounds and update speed if it is
        let gridBound = self.gridBounds - (self.gridBounds * 0.1)   //Makes the grid line up with the window better
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
