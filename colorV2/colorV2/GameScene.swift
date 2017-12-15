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
import AVFoundation
class GameScene: SKScene {
    var soundEffect: AVAudioPlayer!
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
    var growing = false
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
    var changedColor = false
    var hitRed = false
    var hitBlue = false
    var hitGreen = false
    
    var fernBase: SKSpriteNode!
    var fernBase2: SKSpriteNode!
    var apple: SKSpriteNode!
    var banana: SKSpriteNode!
    var blueberry: SKSpriteNode!
    var interval = 32.0
    var interval2 = 32
    var steve: SKSpriteNode!
    var message: SKLabelNode!
    var resetButton: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var finalX = 0.0
    var finalY = 0.0
    var score = 0
    
    override func didMove(to view: SKView) {
        fernBase = childNode(withName: "ferns") as! SKSpriteNode
        fernBase2 = childNode(withName: "ferns_2") as! SKSpriteNode
        let apple: SKSpriteNode = childNode(withName: "red") as! SKSpriteNode
        let banana: SKSpriteNode = childNode(withName: "green") as! SKSpriteNode
        let blueberry: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
        
        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode
        tongue = childNode(withName: "tongue") as! SKSpriteNode
        print("ok made this")
        let BASE_R = CGFloat(getColrValue())
        let BASE_G = CGFloat(getColrValue())
        let BASE_B = CGFloat(getColrValue())
        
        BASE_COLOR = UIColor.init(red: BASE_R/255.0, green: BASE_G/255.0, blue: BASE_B/255.0, alpha: 1.0)
    
        fernBase.color = BASE_COLOR
        fernBase.colorBlendFactor = 1.0
        fernBase2.color = BASE_COLOR
        fernBase2.colorBlendFactor = 1.0
        
        steve.setScale(0.5)
        
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
                     playSoundWith(fileName: "shed", fileExtension: "mp3")
                    RED -= interval
                }
                
                if touchedNode.name == "greenMinus" {
                    playSoundWith(fileName: "shed", fileExtension: "mp3")
                    GREEN -= interval
                }

                if touchedNode.name == "blueMinus" {
                     playSoundWith(fileName: "shed", fileExtension: "mp3")
                    BLUE -= interval
                }
                if touchedNode.name == "playAgain" {
                    resetGame()
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
                if(endLoc.y < initialLoc.y && !retracting && !growing){
                    calculateTongue(startPoint: initialLoc, endPoint: endLoc)
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        changeTongueLength()
        changeSteveColor()
        displayScore()
        respawnFruit()
    }
    func calculateTongue(startPoint: CGPoint, endPoint: CGPoint){
        playSoundWith(fileName: "swish", fileExtension: "mp3")
        let diffX = startPoint.x - endPoint.x
        let diffY = startPoint.y - endPoint.y
        let hypot = sqrt(diffX*diffX+diffY*diffY)
        desiredAngle = atan(diffX/diffY)
        print("THIS IS THE DESIRED ANGLE ",desiredAngle)
        desiredLength = 3*hypot
        tongue.zRotation = (-desiredAngle)
    }
    func changeTongueLength(){
        print("changing tongue length")
        let tongue: SKSpriteNode = childNode(withName: "tongue") as! SKSpriteNode
        print("TONGUE ANGLE: ",tongue.zRotation)
        print("size.height: ",tongue.size.height)
        print("actual length: ",actualLength)
        print("desiredLength: ",desiredLength)
        if(actualLength<desiredLength && !retracting){
            growing = true
            actualLength = actualLength+15
            print("adding 5")
            tongue.size.height = actualLength
        }
        else if(actualLength>desiredLength && !retracting){//reached max length
            retracting = true
            growing = false
            print("reached max length")
            finalX = Double(cos(0.5*3.14159265-desiredAngle)*desiredLength+tongue.position.x)//wouldnt let me use double.pi too lazy to circumvent programmatically
           finalY = Double(sin(0.5*3.14159265-desiredAngle)*desiredLength+tongue.position.y)
            print("Starting coordinates: ",tongue.position.x,",",tongue.position.y)
            print("Final coordinates: ",finalX,",",finalY)
            print("are we retracting: ",retracting)
            if(finalX > -200 && finalX < -120 && finalY < 475 && finalY > 398){
                //RED+=interval
                playSoundWith(fileName: "pop", fileExtension: "mp3")
                changedColor = true
                hitRed = true
                print("hit red")
            }
            else if(finalX < 80 && finalX > 5 && finalY > 242 && finalY < 360){
                //GREEN+=interval
                hitGreen = true
                changedColor = true
                playSoundWith(fileName: "pop", fileExtension: "mp3")
                    print("hit green")
                }
            
            else if( finalX > 223 && finalX < 320 && finalY > 400 && finalY < 490){
                //BLUE+=interval
                hitBlue = true
                changedColor = true
                playSoundWith(fileName: "pop", fileExtension: "mp3")
                print("hit blue")
            
            }
        }
        else if(retracting && actualLength>15){
            if(hitRed||hitBlue||hitGreen){
                moveFruit()
            }
            
            print("are we retracting: ",retracting)
            actualLength = actualLength-15
            print("subtracting 5")
            tongue.size.height = actualLength
            if(actualLength<=15 && changedColor){
                playSoundWith(fileName: "bling", fileExtension: "mp3")
                changedColor = false
            }
        }
        else if(actualLength<=15){
            if(hitRed){
                let apple: SKSpriteNode = childNode(withName: "red") as! SKSpriteNode
                apple.size.width = 0
                apple.size.height = 0
                apple.position.x = -160
                apple.position.y = 484.211
                RED+=interval
                hitRed = false
            }
            if(hitBlue){
                let blueberry: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
                blueberry.size.width = 0
                blueberry.size.height = 0
                blueberry.position.x = 268.8
                blueberry.position.y = 494.45
                BLUE+=interval
                hitBlue = false
            }
            if(hitGreen){
                let banana: SKSpriteNode = childNode(withName: "green") as! SKSpriteNode
                banana.size.width = 0
                banana.size.height = 0
                banana.position.x = 41.128
                banana.position.y = 355.55
                GREEN+=interval
                hitGreen = false
            }
            print("are we retracting: ",retracting)
            actualLength = 0
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
        playSoundWith(fileName: "win", fileExtension: "mp3")
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
    func playSoundWith(fileName: String, fileExtension: String){
        let audioSourceURL: URL!
        audioSourceURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        do{
            soundEffect = try AVAudioPlayer.init(contentsOf: audioSourceURL!)
            soundEffect.prepareToPlay()
            soundEffect.setVolume(1, fadeDuration: 0)
            soundEffect.play()
        }
        catch{
            print("darn")
        }
    }
    func moveFruit(){
        if(hitRed){
             let apple: SKSpriteNode = childNode(withName: "red") as! SKSpriteNode
            apple.position.x-=CGFloat(CGFloat(finalX)-tongue.position.x)/CGFloat(Int(desiredLength/15+desiredLength.truncatingRemainder(dividingBy: 15)))
            apple.position.y-=CGFloat(CGFloat(finalY)-tongue.position.y)/CGFloat(Int(desiredLength/15+desiredLength.truncatingRemainder(dividingBy: 15)))
        }
        else if(hitBlue){
            let blueberry: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
            blueberry.position.x-=CGFloat(CGFloat(finalX)-tongue.position.x)/CGFloat(Int(desiredLength/15+desiredLength.truncatingRemainder(dividingBy: 15)))
            blueberry.position.y-=CGFloat(CGFloat(finalY)-tongue.position.y)/CGFloat(Int(desiredLength/15+desiredLength.truncatingRemainder(dividingBy: 15)))
        }
        else if(hitGreen){
            let banana: SKSpriteNode = childNode(withName: "green") as! SKSpriteNode
            banana.position.x-=CGFloat(CGFloat(finalX)-tongue.position.x)/CGFloat(Int(desiredLength/15+desiredLength.truncatingRemainder(dividingBy: 15)))
            banana.position.y-=CGFloat(CGFloat(finalY)-tongue.position.y)/CGFloat(Int(desiredLength/15+desiredLength.truncatingRemainder(dividingBy: 15)))
        }
    }
    func respawnFruit(){
        let apple: SKSpriteNode = childNode(withName: "red") as! SKSpriteNode
        let blueberry: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
        let banana: SKSpriteNode = childNode(withName: "green") as! SKSpriteNode
        if(apple.size.width<102.4){
            apple.size.width+=10.204/2.0
            apple.size.height+=10.204/2.0
        }
        else if(blueberry.size.width<102.4){
            blueberry.size.width+=10.204/2.0
            blueberry.size.height+=10.204/2.0
        }
        else if(banana.size.width<102.4){
            banana.size.width+=10.204/2.0
            banana.size.height+=10.204/2.0
        }
    }
}
