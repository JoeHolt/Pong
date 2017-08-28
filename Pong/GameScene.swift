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
    private let updateGameBall: Int = 05    //Update game every x frames
    private let updateBump: Int     = 04    //Update speed for right bumper
    private var scoreLabel: SKLabelNode!    //Score label
    private var ball: GameObject!           //Ball
    private var lBumper: GameObject!        //Left bumper
    private var rBumper: GameObject!        //Right bumper
    private var mainView: SKView!           //Mainview
    private var frameCounter: Int   = 0     //Current frame
    private var gridBounds: CGFloat {       //Bounds of grid
        return CGFloat(gridSize/2)
    }
    private var score: Int = 0 {            //Score of game
        didSet {
            scoreLabel.text = String(score)
        }
    }

    
    override func didMove(to view: SKView) {
        self.mainView = view
        self.ball = GameObject(CGSize(width: 1.0, height: 1.0), initialPosistion: CGPoint(x: -15, y: 0), initialSpeed: CGPoint(x: 1, y: 1))
        self.lBumper = GameObject(CGSize(width: 1.0, height: 4.0), initialPosistion: CGPoint(x: -gridBounds + 2, y: 0), initialSpeed: CGPoint(x: 0, y: -1))
        self.rBumper = GameObject(CGSize(width: 1.0, height: 4.0), initialPosistion: CGPoint(x: gridBounds - 2, y: 0), initialSpeed: CGPoint(x: 0, y: -1))
        self.scoreLabel = SKLabelNode(text: "0")
        self.scoreLabel.fontSize = 500
        self.scoreLabel.alpha = 0.5
        self.scoreLabel.fontName = "Munro"
        self.scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-150)
        addChild(scoreLabel)
        drawBumper(lBumper)
        drawBumper(rBumper)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if frameCounter % updateGameBall == 0 {
            updateBall()
        }
        if frameCounter % updateBump == 0 {
            updateAIBumperSpeed()
            updateBumper(lBumper)
            updateBumper(rBumper)
        }
        frameCounter += 1
    }
    
    override func keyDown(with event: NSEvent) {
        handleKeyEvent(event: event)
    }
    
    private func handleKeyEvent(event: NSEvent) {
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
    
    private func updateAIBumperSpeed() {
        //Set speed based on ball
        let midPos = rBumper.body.last!
        if midPos.y > ball.posistion.y {
            if rBumper.speed.y != -1 {
                rBumper.body.reverse()
                rBumper.posistion = rBumper.body.first
            }
            rBumper.speed = CGPoint(x: 0, y: -1)
        } else {
            if rBumper.speed.y != 1 {
                rBumper.body.reverse()
                rBumper.posistion = rBumper.body.first
            }
            rBumper.speed = CGPoint(x: 0, y: 1)
        }
    }
    
    private func updateBumper(_ bumper: GameObject) {
        let gridBound = self.gridBounds - (self.gridBounds * 0.1)   //Makes the grid line up with the window better
        //Left user bumper
        if bumper.speed.y != 0 && bumper.posistion.y < gridBound && bumper.posistion.y > -gridBound {
            let newPos = CGPoint(x: bumper.posistion.x, y: bumper.posistion.y + bumper.speed.y)
            bumper.posistion = newPos
            bumper.body.insert(newPos, at: 0)
            removeSquare(x: Int((bumper.body.last?.x)!), y: Int((bumper.body.last?.y)!))
            bumper.body.remove(at: bumper.body.count-1)
            drawBumper(bumper)
        }
    }
    
    private func drawBumper(_ bumper: GameObject) {
        for pos in bumper.body {
            drawSquare(x: Int(pos.x), y: Int(pos.y), color: SKColor.purple)
        }
    }
    
    private func updateBall() {
        //Find next posistion for ball
        var newBallPosistion = CGPoint(x: ball.posistion.x + ball.speed.x, y: ball.posistion.y + ball.speed.y)
        //Check if it is within view bounds and update speed if it is
        let gridBound = self.gridBounds - (self.gridBounds * 0.1)   //Makes the grid line up with the window better
        if newBallPosistion.x > gridBound || newBallPosistion.x < -gridBound {
            newBallPosistion = CGPoint(x: 0, y: 0)
            score = 0
            ball.speed = CGPoint(x: 1, y: 1)
        }
        if newBallPosistion.y > gridBound {
            ball.speed.y = -1
        }
        if newBallPosistion.y < -gridBound {
            ball.speed.y = 1
        }
        //Check if ball is about to hit bumper and act accorgingly
        if lBumper.body.contains(newBallPosistion) || rBumper.body.contains(newBallPosistion) {
            ball.speed.x *= -1
            score += 1
            newBallPosistion = CGPoint(x: ball.posistion.x + ball.speed.x, y: ball.posistion.y + ball.speed.y)
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
            if node is SKLabelNode {} else {
                node.removeFromParent()
            }
        }
    }
    
}
