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
    var tongueIsFlying = false
    var colorLevel:SKSpriteNode!
    var redLevel: SKLabelNode!
    var greenLevel: SKLabelNode!
    var blueLevel: SKLabelNode!
    var show_level = true;


    var steve_head: SKSpriteNode!
    var steve_body: SKSpriteNode!
    var open_mouth = false;

    override func didMove(to view: SKView) {
        fernBase = childNode(withName: "ferns") as! SKSpriteNode
        fernBase2 = childNode(withName: "ferns_2") as! SKSpriteNode
        let apple: SKSpriteNode = childNode(withName: "red") as! SKSpriteNode
        let banana: SKSpriteNode = childNode(withName: "green") as! SKSpriteNode
        let blueberry: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
        
        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode
        let steve_head: SKSpriteNode = childNode(withName: "head") as! SKSpriteNode
        let steve_body: SKSpriteNode = childNode(withName: "body") as! SKSpriteNode

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
            //print(touch.location(in: self))
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)

            if(touchedNode.name != nil){
                if touchedNode.name == "dragSpace" && !tongueIsFlying{
                    //print("here??")
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
                //print("help")
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
        print("actual length: ",actualLength)
        print("tongue.size.height: ",tongue.size.height)
        changeSteveColor()
        displayScore()
        respawnFruit()
    }
    func calculateTongue(startPoint: CGPoint, endPoint: CGPoint){
        print("CALCULATING TONGUE")
        print(startPoint,"  ",endPoint)
        playSoundWith(fileName: "swish", fileExtension: "mp3")
        let diffX = startPoint.x - endPoint.x
        let diffY = startPoint.y - endPoint.y
        print("diffX: ",diffX,"diffY: ",diffY)
        let hypot = sqrt(diffX*diffX+diffY*diffY)
        print("First vector length: ",hypot)
        desiredAngle = atan(diffX/diffY)
        print("Vector angle: ",180.0/3.1415*desiredAngle)
        desiredLength = min(3*hypot,1000)
        finalX = Double(sin(desiredAngle)*desiredLength+tongue.position.x)
        finalY = Double(cos(desiredAngle)*desiredLength+tongue.position.y)
        tongue.zRotation = -desiredAngle
        if(collideRed()){
            print("hit da red")
            tongue.zRotation = -0.0523
            desiredLength = 788.64
            hitRed = true
            changedColor = true
        }
        if(collideGreen()){
            hitGreen = true
            changedColor = true
            desiredLength = 698.0
            tongue.zRotation = -0.389
            print("hit da green")
        }
        if(collideBlue()){
            hitBlue = true
            hitGreen = false
            changedColor = true
            desiredLength = 912.0
            tongue.zRotation = -0.5358
            print("hit da blue")
        }
        print("Z rotation: ",tongue.zRotation*180/3.14159265)
        print("Final X: ",finalX,"Final Y:",finalY)
        
        
    }
    func changeTongueLength(){
        let tongue: SKSpriteNode = childNode(withName: "tongue") as! SKSpriteNode
        let head: SKSpriteNode = childNode(withName: "head") as! SKSpriteNode
        if(actualLength<desiredLength && !retracting){
            tongueIsFlying = true
            if(!open_mouth){
                var actions = Array<SKAction>()
                actions.append(SKAction.rotate(byAngle: -1.5, duration: 0.3))
                actions.append(SKAction.moveBy(x: 40.0, y: 0.0, duration: 0.3))
                let group = SKAction.group(actions);
                head.run(group)
                
                open_mouth = true;
            }

            actualLength = actualLength+20
           // print("adding 5")
            tongue.size.height = actualLength
        }
        else if(actualLength>=desiredLength && !retracting && actualLength>0 ){//reached max length
            retracting = true
            
        }
        else if(retracting && actualLength>20){
            if(hitRed||hitBlue||hitGreen){
                moveFruit()
            }


            //print("are we retracting: ",retracting)
            actualLength = actualLength-20
            //print("subtracting 5")
            tongue.size.height = actualLength
            if(open_mouth){
                var actions = Array<SKAction>()
                actions.append(SKAction.rotate(byAngle: 1.5, duration: 0.5))
                actions.append(SKAction.moveBy(x: -40.0, y: 0.0, duration: 0.5))
                let group = SKAction.group(actions);
                head.run(group)
                open_mouth = false;
            }
            if(actualLength<=15 && changedColor){
                playSoundWith(fileName: "bling", fileExtension: "mp3")
                changedColor = false
            }
        }
        else if(actualLength<=20){
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
            //print("are we retracting: ",retracting)
            actualLength = 0
            //print("stop moving")
            tongue.size.height = actualLength
            retracting = false
            desiredLength = 0;
            tongueIsFlying = false
        }

    }
    func changeSteveColor() {
        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode
        
        let steve_head: SKSpriteNode = childNode(withName: "head") as! SKSpriteNode
        let steve_body: SKSpriteNode = childNode(withName: "body") as! SKSpriteNode
        
        currentColor = UIColor.init(red:CGFloat(RED)/255.0, green:CGFloat(GREEN)/255.0, blue:CGFloat(BLUE)/255.0, alpha:1.0 )
        
        //print(currentColor)
        //print(BASE_COLOR)
        
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
        //print(Range)
        var BASE = Int(arc4random_uniform(UInt32(Range)))
        BASE *= interval2
        //print(BASE)
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
            let tempAngle = atan((-160-tongue.position.x)/(440-tongue.position.y))
            let changeX = sin(tempAngle)*20
            let changeY = cos(tempAngle)*20
             let apple: SKSpriteNode = childNode(withName: "red") as! SKSpriteNode
            apple.position.x-=changeX
            apple.position.y-=changeY
        }
        else if(hitBlue){
            let blueberry: SKSpriteNode = childNode(withName: "blue") as! SKSpriteNode
            let tempAngle = atan((268-tongue.position.x)/(439-tongue.position.y))
            let changeX = sin(tempAngle)*20
            let changeY = cos(tempAngle)*20
            blueberry.position.x-=changeX
            blueberry.position.y-=changeY
        }
        else if(hitGreen){
            let banana: SKSpriteNode = childNode(withName: "green") as! SKSpriteNode
            let tempAngle = atan((56-tongue.position.x)/(295-tongue.position.y))
            let changeX = sin(tempAngle)*20
            let changeY = cos(tempAngle)*20
            banana.position.x-=changeX
            banana.position.y-=changeY
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
    func collideBlue() ->Bool{
        let xLineLeft = CGFloat(214)
        let xLineRight = CGFloat(325)
        let yLineTop = CGFloat(500)
        let yLineBot = CGFloat(397)
        let slope = (CGFloat(finalY)-tongue.position.y)/(CGFloat(finalX)-tongue.position.x)
        let yIntercept = CGFloat(finalY)-(slope*CGFloat(finalX))
        let leftIntersect = slope*xLineLeft+yIntercept
        let rightIntersect = slope*xLineRight+yIntercept
        let botIntersect = (yLineBot-yIntercept)/slope
        let topIntersect = (yLineTop-yIntercept)/slope
        if(leftIntersect >= yLineBot && leftIntersect <= yLineTop){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(xLineLeft), lastY: Double(leftIntersect)) < Double(desiredLength)){
                hitBlue = true
                hitRed = false
                hitGreen = false
                return true
            }
        }
        else if(rightIntersect >= yLineBot && rightIntersect <= yLineTop){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(xLineLeft), lastY: Double(leftIntersect)) < Double(desiredLength)){
                hitBlue = true
                hitRed = false
                hitGreen = false
                return true
            }
        }
        else if(botIntersect >= xLineLeft && botIntersect <= xLineRight){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(botIntersect), lastY: Double(yLineBot)) < Double(desiredLength)){
                hitBlue = true
                hitRed = false
                hitGreen = false
                return true
            }
        }
        else if(topIntersect >= xLineLeft && topIntersect <= xLineRight){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(topIntersect),lastY: Double(yLineTop)) < Double(desiredLength)){
                hitBlue = true
                hitRed = false
                hitGreen = false
                return true
            }
        }
        return false
    }
    func collideRed() ->Bool{
        print("Yea wtf: ",tongue.zRotation)
        let xLineLeft = CGFloat(-208.0)
        let xLineRight = CGFloat(-114.0)
        let yLineTop = CGFloat(491.0)
        let yLineBot = CGFloat(393.0)
        //print(finalX,",",finalY)
        let slope = (CGFloat(finalY)-tongue.position.y)/(CGFloat(finalX)-tongue.position.x)
        let yIntercept = CGFloat(finalY)-(slope*CGFloat(finalX))
        print("slope: ",slope,"y-intercept",yIntercept)
        let leftIntersect = slope*xLineLeft+yIntercept
        let rightIntersect = slope*xLineRight+yIntercept
        let botIntersect = (yLineBot-yIntercept)/slope
        let topIntersect = (yLineTop-yIntercept)/slope
        print("bot intersect: ",botIntersect,",",yLineBot)
        if(leftIntersect >= yLineBot && leftIntersect <= yLineTop){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(xLineLeft), lastY: Double(leftIntersect)) < Double(desiredLength)){
                hitRed = true
                hitBlue = false
                hitGreen = false
                return true
            }
        }
        else if(rightIntersect >= yLineBot && rightIntersect <= yLineTop){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(xLineLeft), lastY: Double(leftIntersect)) < Double(desiredLength)){
                hitRed = true
                hitBlue = false
                hitGreen = false
                return true
            }
        }
        else if(botIntersect >= xLineLeft && botIntersect <= xLineRight){
            print("almost hit the thing")
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(botIntersect), lastY: Double(yLineBot)) <= Double(desiredLength)){
                print("HIT BOTTOM LINE")
                hitRed = true
                hitBlue = false
                hitGreen = false
                return true
            }
        }
        else if(topIntersect >= xLineLeft && topIntersect <= xLineRight){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(topIntersect),lastY: Double(yLineTop)) < Double(desiredLength)){
                hitRed = true
                hitBlue = false
                hitGreen = false
                return true
            }
        }
        return false
    }
    func collideGreen() ->Bool{
        let xLineLeft = CGFloat(0.0)
        let xLineRight = CGFloat(89.0)
        let yLineTop = CGFloat(370)
        let yLineBot = CGFloat(273)
        let slope = (CGFloat(finalY)-tongue.position.y)/(CGFloat(finalX)-tongue.position.x)
        let yIntercept = CGFloat(finalY)-(slope*CGFloat(finalX))
        let leftIntersect = slope*xLineLeft+yIntercept
        let rightIntersect = slope*xLineRight+yIntercept
        let botIntersect = (yLineBot-yIntercept)/slope
        let topIntersect = (yLineTop-yIntercept)/slope
        if(leftIntersect >= yLineBot && leftIntersect <= yLineTop){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(xLineLeft), lastY: Double(leftIntersect)) < Double(desiredLength)){
                print("hit left")
                hitRed = false
                hitBlue = false
                hitGreen = true
                return true
            }
        }
        else if(rightIntersect >= yLineBot && rightIntersect <= yLineTop){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(xLineLeft), lastY: Double(leftIntersect)) < Double(desiredLength)){
                print("hit right")
                hitRed = false
                hitBlue = false
                hitGreen = true
                return true
            }
        }
        else if(botIntersect >= xLineLeft && botIntersect <= xLineRight){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(botIntersect), lastY: Double(yLineBot)) < Double(desiredLength)){
                print("hit bot")
                hitRed = false
                hitBlue = false
                hitGreen = true
                return true
            }
        }
        else if(topIntersect >= xLineLeft && topIntersect <= xLineRight){
            if(distance(firstX: Double(tongue.position.x), firstY: Double(tongue.position.y), lastX: Double(topIntersect),lastY: Double(yLineTop)) < Double(desiredLength)){
                print("hit top")
                hitRed = false
                hitBlue = false
                hitGreen = true
                return true
            }
        }
        return false
    }
    func distance(firstX: Double, firstY: Double, lastX: Double, lastY: Double)-> Double{
       return sqrt(pow(lastX-firstX,2)+pow(lastY-firstY,2))
    }
    
}
