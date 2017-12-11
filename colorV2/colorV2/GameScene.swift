//
//  GameScene.swift
//  colorV2
//
//  Created by Kairi Malcolm Sameshima on 12/8/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import SpriteKit
import GameplayKit
import SpriteKit
import UIKit

class GameScene: SKScene {
    
    //chameleon node
    //let theBlueOne: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
    
    
    //color variables
    var RED = 0.0
    var BLUE = 0.0
    var GREEN = 0.0
    var BASE_COLOR = UIColor.clear
    var currentColor = UIColor.clear
    
    var fernBase: SKSpriteNode!
    var fernBase2: SKSpriteNode!
    
    var interval = 32.0
    var interval2 = 32
    var steve: SKSpriteNode!
    var message: SKLabelNode!
    var resetButton: SKLabelNode!
    var scoreLabel: SKLabelNode!
    
    var score = 0
    
    override func didMove(to view: SKView) {
        fernBase = childNode(withName: "ferns") as! SKSpriteNode
        fernBase2 = childNode(withName: "ferns_2") as! SKSpriteNode

        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode

        let BASE_R = CGFloat(getColrValue())
        let BASE_G = CGFloat(getColrValue())
        let BASE_B = CGFloat(getColrValue())
        
        BASE_COLOR = UIColor.init(red: BASE_R/255.0, green: BASE_G/255.0, blue: BASE_B/255.0, alpha: 1.0)
    
        fernBase.color = BASE_COLOR
        fernBase.colorBlendFactor = 1.0
        fernBase2.color = BASE_COLOR
        fernBase2.colorBlendFactor = 1.0
        
        steve.setScale(0.5)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
  
        for touch in touches{
            print(touch.location(in: self))
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)

            if(touchedNode.name != nil){
                if touchedNode.name == "red" {
                    RED += interval
                }
                
                if touchedNode.name == "green" {
                    GREEN += interval
                }
                
                if touchedNode.name == "blue" {
                    BLUE += interval
                }
                
                if touchedNode.name == "redMinus" {
                    RED -= interval
                }
                
                if touchedNode.name == "greenMinus" {
                    GREEN -= interval
                }

                if touchedNode.name == "blueMinus" {
                    BLUE -= interval
                }
                if touchedNode.name == "playAgain" {
                    resetGame()
                }
                checkWinStatus()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        changeSteveColor()
        displayScore()
    }
    
    func changeSteveColor() {
        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode

        currentColor = UIColor.init(red:CGFloat(RED)/255.0, green:CGFloat(GREEN)/255.0, blue:CGFloat(BLUE)/255.0, alpha:1.0 )
        
        print(currentColor)
        print(BASE_COLOR)
        
        steve.color = currentColor
        steve.colorBlendFactor = 1.0

    }
    
    // This function will check whether or not the chameleon is the correct color, if it is, it will display some text!
    func checkWinStatus() {
        currentColor = UIColor.init(red:CGFloat(RED)/255.0, green:CGFloat(GREEN)/255.0, blue:CGFloat(BLUE)/255.0, alpha:1.0 )
        if(currentColor.isEqual(BASE_COLOR)){
            score += 1
            winMessage()
        }
    }
    
    func displayScore() {
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score:\(score)"
        
    }
    
    func winMessage() {
        message = childNode(withName: "winMessage") as! SKLabelNode
        resetButton = childNode(withName: "playAgain") as! SKLabelNode
        
        let messageLocation =  CGPoint(x: 45, y: 141)
        message.run(SKAction.move(to: messageLocation, duration: 2.5))
        
        // Drop down the play again button
        let resetButtonLocation =  CGPoint(x: 45, y: 81)
        resetButton.run(SKAction.move(to: resetButtonLocation, duration: 2))
        
    }
    
    func resetGame() {
        // Randomize fern colors
        let BASE_R = CGFloat(getColrValue())
        let BASE_G = CGFloat(getColrValue())
        let BASE_B = CGFloat(getColrValue())
    
        BASE_COLOR = UIColor.init(red: BASE_R/255.0, green: BASE_G/255.0, blue: BASE_B/255.0, alpha: 1.0)
        fernBase.color = BASE_COLOR
        fernBase.colorBlendFactor = 1.0
        fernBase2.color = BASE_COLOR
        fernBase2.colorBlendFactor = 1.0
        
        // Reset Steve colors
        RED = 0.0
        GREEN = 0.0
        BLUE = 0.0
        currentColor = UIColor.init(red:CGFloat(RED)/255.0, green:CGFloat(GREEN)/255.0, blue:CGFloat(BLUE)/255.0, alpha:1.0 )
        
        
        changeSteveColor()
        
        // Lose the buttons
        message = childNode(withName: "winMessage") as! SKLabelNode
        resetButton = childNode(withName: "playAgain") as! SKLabelNode
        let messageLocation =  CGPoint(x: 45, y: 800)
        message.run(SKAction.move(to: messageLocation, duration: 1))
        let resetButtonLocation =  CGPoint(x: 45, y: 800)
        resetButton.run(SKAction.move(to: resetButtonLocation, duration: 1))
    }
    
    func loseButtons() {
        // Lose the buttons
        message = childNode(withName: "winMessage") as! SKLabelNode
        resetButton = childNode(withName: "playAgain") as! SKLabelNode
        let messageLocation =  CGPoint(x: 45, y: 800)
        message.run(SKAction.move(to: messageLocation, duration: 1))
        let resetButtonLocation =  CGPoint(x: 45, y: 800)
        resetButton.run(SKAction.move(to: resetButtonLocation, duration: 1))
    }
    
    func getColrValue() -> Int{
        // different steps within range using interval
        let Range = 256 / interval2
        print(Range)
        var BASE = Int(arc4random_uniform(UInt32(Range)))
        BASE *= interval2
        print(BASE)
        return BASE;
    }
}
