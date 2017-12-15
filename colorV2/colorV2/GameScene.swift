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
    
    //toungue stuff
    var touchedDrag = false
    var dragSpace: SKSpriteNode!
    var initialLoc = CGPoint(x: 0.0 , y:0.0)
    var endLoc = CGPoint(x: 0.0 , y:0.0)
    var retracting = false
    var tongue: SKSpriteNode!
    var desiredLength = CGFloat(0.0)
    var desiredAngle = CGFloat(0.0)
    var actualLength = CGFloat(0.0)
    var goodBlueAngle = CGFloat(0.0)
    var goodBlueLength = CGFloat(0.0)
    var goodRedLength = CGFloat(0.0)
    var goodGreenLength = CGFloat(0.0)
    var goodRedAngle = CGFloat(0.0)
    var goodGreenAngle = CGFloat(0.0)
    var vectorAngle = CGFloat(0.0)
    
    
    var fernBase: SKSpriteNode!
    var fernBase2: SKSpriteNode!
    
    let tongueSpeed = CGFloat(30.0)
    
    var interval = 32.0
    var interval2 = 32
    var steve: SKSpriteNode!
    var message: SKLabelNode!
    var resetButton: SKLabelNode!
    var scoreLabel: SKLabelNode!
    
    var colorLevel:SKSpriteNode!
    var redLevel: SKLabelNode!
    var greenLevel: SKLabelNode!
    var blueLevel: SKLabelNode!

    var steve_head: SKSpriteNode!
    var steve_body: SKSpriteNode!
    var open_mouth = false;

    var show_level = true;
    
    var score = 0
    
    override func didMove(to view: SKView) {
        fernBase = childNode(withName: "ferns") as! SKSpriteNode
        fernBase2 = childNode(withName: "ferns_2") as! SKSpriteNode

        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode
        tongue = childNode(withName: "tongue") as! SKSpriteNode
        let steve_head: SKSpriteNode = childNode(withName: "head") as! SKSpriteNode
        let steve_body: SKSpriteNode = childNode(withName: "body") as! SKSpriteNode
        
        print("ok made this")
        let BASE_R = CGFloat(getColrValue())
        let BASE_G = CGFloat(getColrValue())
        let BASE_B = CGFloat(getColrValue())
        
        BASE_COLOR = UIColor.init(red: BASE_R/255.0, green: BASE_G/255.0, blue: BASE_B/255.0, alpha: 1.0)
    
        fernBase.color = BASE_COLOR
        fernBase.colorBlendFactor = 1.0
        fernBase2.color = BASE_COLOR
        fernBase2.colorBlendFactor = 1.0
        
//        steve.setScale(0.5)
        
        goodBlueAngle = CGFloat(atan((450.0+418.0)/(268+248)))
        
        let gbl_sub = sqrt((922*922)+(516*516))
        goodBlueLength = CGFloat(gbl_sub)
        
        goodGreenAngle = CGFloat(atan((420.0+418.0)/(-151+248)))
        
        let ggl_sub = sqrt(898*898+399*399)
        goodGreenLength = CGFloat(ggl_sub)
        
        goodRedAngle = CGFloat(atan((300.0+418.0)/(51+248)))
        
        let grl_sub = sqrt(718*718+299*299)
        goodRedLength = CGFloat(grl_sub)

    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
  
        for touch in touches{
            print(touch.location(in: self))
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)

            if(touchedNode.name != nil){
                if touchedNode.name == "dragSpace"{
                    print("here??")
                    initialLoc = touch.location(in: self)
                    touchedDrag = true
                }
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
                if touchedNode.name == "level"{
                    if(show_level){
                        displayLevels()
                        show_level = false
                    }
                    else{
                        hideLevels()
                        show_level = true;
                    }
                }
                checkWinStatus()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches{
            if(touchedDrag){
                print("help")
                endLoc = touch.location(in: self)
                touchedDrag = false
                if(endLoc.y < initialLoc.y){
                    calculateTongue(startPoint: initialLoc, endPoint: endLoc)
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        changeTongueLength()
        changeSteveColor()
        displayScore()
    }
    
    func calculateTongue(startPoint: CGPoint, endPoint: CGPoint){
        let diffX = startPoint.x - endPoint.x
        let diffY = startPoint.y - endPoint.y
        let hypot = sqrt(diffX*diffX+diffY*diffY)
        desiredAngle = atan(diffX/diffY)
        print("THIS IS THE DESIRED ANGLE ",desiredAngle)
        desiredLength = 2.5*hypot
        tongue.zRotation = (-desiredAngle)
    }
    
    func changeTongueLength(){
        
        print("changing tongue length")
        let tongue: SKSpriteNode = childNode(withName: "tongue") as! SKSpriteNode
        let head: SKSpriteNode = childNode(withName: "head") as! SKSpriteNode
        print("TONGUE ANGLE: ",tongue.zRotation)
        print("size.height: ",tongue.size.height)
        print("actual length: ",actualLength)
        print("desiredLength: ",desiredLength)
        if(actualLength<desiredLength && !retracting){
            if(!open_mouth){
                var actions = Array<SKAction>()
                actions.append(SKAction.rotate(byAngle: -1.5, duration: 0.5))
                actions.append(SKAction.moveBy(x: 40.0, y: 0.0, duration: 0.5))
                let group = SKAction.group(actions);
                head.run(group)
                
                open_mouth = true;
            }
            actualLength = actualLength+tongueSpeed
            print("adding 5")
            tongue.size.height = actualLength
        }
        else if(actualLength>desiredLength && !retracting){//reached max length
            retracting = true
            print("reached max length")
            let finalX = cos(0.5*3.14159265-desiredAngle)*desiredLength+tongue.position.x//wouldnt let me use double.pi too lazy to circumvent programmatically
            let finalY = sin(0.5*3.14159265-desiredAngle)*desiredLength+tongue.position.y
            print("Starting coordinates: ",tongue.position.x,",",tongue.position.y)
            print("Final coordinates: ",finalX,",",finalY)
            print("are we retracting: ",retracting)
            if(finalX > -200 && finalX < -120 && finalY < 475 && finalY > 398){
                RED+=interval
                print("hit red")
            }
            else if(finalX < 80 && finalX > 5 && finalY > 242 && finalY < 360){
                    GREEN+=interval
                    print("hit green")
                }
            
            else if( finalX > 223 && finalX < 320 && finalY > 400 && finalY < 490){
            BLUE+=interval
            print("hit blue")
            
            }
        }
        else if(retracting && actualLength>15){
            print("are we retracting: ",retracting)
            actualLength = actualLength-tongueSpeed
            print("subtracting 5")
            tongue.size.height = actualLength
        }
        else if(actualLength<=15){
            print("are we retracting: ",retracting)
            actualLength = 0
            if(open_mouth){
                var actions = Array<SKAction>()
                actions.append(SKAction.rotate(byAngle: 1.5, duration: 0.5))
                actions.append(SKAction.moveBy(x: -40.0, y: 0.0, duration: 0.5))
                let group = SKAction.group(actions);
                head.run(group)
                open_mouth = false;
            }

            print("stop moving")
            tongue.size.height = actualLength
            retracting = false
            desiredLength = 0;
        }
        else{
            print("i didnt know there was a possible other option")
        }
    }
    func changeSteveColor() {
        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode

        let steve_head: SKSpriteNode = childNode(withName: "head") as! SKSpriteNode
        let steve_body: SKSpriteNode = childNode(withName: "body") as! SKSpriteNode

        currentColor = UIColor.init(red:CGFloat(RED)/255.0, green:CGFloat(GREEN)/255.0, blue:CGFloat(BLUE)/255.0, alpha:1.0 )
        
        print(currentColor)
        print(BASE_COLOR)
        
        steve_head.color = currentColor
        steve_head.colorBlendFactor = 1.0

        steve_body.color = currentColor
        steve_body.colorBlendFactor = 1.0
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
    func displayLevels(){
        redLevel = childNode(withName: "redVal") as! SKLabelNode
        greenLevel = childNode(withName: "greenVal") as! SKLabelNode
        blueLevel = childNode(withName: "blueVal") as! SKLabelNode

        redLevel.text = "red: \(Int(RED)) out of 256"
        greenLevel.text = "green: \(Int(GREEN)) out of 256"
        blueLevel.text = "blue: \(Int(BLUE)) out of 256"
        
        let redLocation =  CGPoint(x: 45, y: 200)
        let greenLocation =  CGPoint(x: 45, y: 150)
        let blueLocation =  CGPoint(x: 45, y: 100)

        redLevel.run(SKAction.move(to: redLocation, duration: 1.0))
        greenLevel.run(SKAction.move(to: greenLocation, duration: 1.0))
        blueLevel.run(SKAction.move(to: blueLocation, duration: 1.0))


    }
    func hideLevels(){
        redLevel = childNode(withName: "redVal") as! SKLabelNode
        greenLevel = childNode(withName: "greenVal") as! SKLabelNode
        blueLevel = childNode(withName: "blueVal") as! SKLabelNode
        
        let Location =  CGPoint(x: 400, y: -750)
        
        redLevel.run(SKAction.move(to: Location, duration: 1.0))
        greenLevel.run(SKAction.move(to: Location, duration: 1.0))
        blueLevel.run(SKAction.move(to: Location, duration: 1.0))
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
