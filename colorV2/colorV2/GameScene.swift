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
    
    var interval = 48.0
    var interval2 = 48
    
    var steve: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        let fernBase: SKSpriteNode = childNode(withName: "ferns") as! SKSpriteNode
        let fernBase2: SKSpriteNode = childNode(withName: "ferns_2") as! SKSpriteNode

        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode

        let BASE_R = CGFloat(getColrValue())
        let BASE_G = CGFloat(getColrValue())
        let BASE_B = CGFloat(getColrValue())
        
        let BASE_COLOR = UIColor.init(red: BASE_R/255.0, green: BASE_G/255.0, blue: BASE_B/255.0, alpha: 1.0)
    
        fernBase.color = BASE_COLOR
        fernBase.colorBlendFactor = 1.0
        fernBase2.color = BASE_COLOR
        fernBase2.colorBlendFactor = 1.0
        
        steve.setScale(0.5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
  

        for touch in (touches){
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            print(touchedNode.name)
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

                
                
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        changeSteveColor()
    }
    
    func changeSteveColor() {
        let steve: SKSpriteNode = childNode(withName: "steve") as! SKSpriteNode

        steve.color = UIColor.init(red:CGFloat(RED)/255.0, green:CGFloat(GREEN)/255.0, blue:CGFloat(BLUE)/255.0, alpha:1.0 )
        steve.colorBlendFactor = 1.0

    }
    func getColrValue() -> Int{
        var BASE = Int(arc4random_uniform(255))
        if BASE % interval2 != 0{
            BASE = BASE + (BASE % interval2)
            if(BASE > 255){
                BASE = 255
            }
        }
        return BASE;
    }
}
