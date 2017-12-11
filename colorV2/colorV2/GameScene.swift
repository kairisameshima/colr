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

    let Chameleon_body = SKSpriteNode(imageNamed: "Chameleon_noHead.png")
    let Chameleon_Head = SKSpriteNode(imageNamed: "ChameleonHead.png")
    let redFruit = SKSpriteNode(imageNamed: "redFruit.png")
    let greenFruit = SKSpriteNode(imageNamed: "greenFruit.png")
    let blueFruit = SKSpriteNode(imageNamed: "blueFruit.png")

    let fernBase = SKSpriteNode(imageNamed: "fern_base.png")

    
    //color variables
    var RED = CGFloat.init()
    var BLUE = CGFloat.init()
    var GREEN = CGFloat.init()
    var BASE_COLOR = UIColor.clear
    
    var interval = 8

    func initialize(){
        //Things to do in the intialize FOR NOW with simplified game,
        
//        //initialize could also double as a reset in which case
        RED = CGFloat.init()
        BLUE = CGFloat.init()
        GREEN = CGFloat.init()

        //Generate a random color that works within a certain interval, in this case 8

        //initialize whatever chameleon is sitting on to base color

        //initialize chameleon to black
        Chameleon_body.color = UIColor.init(red:0.0, green:0.0, blue:0.0, alpha:1)
        Chameleon_body.colorBlendFactor = 1.0

        
    }
    
    override func didMove(to view: SKView) {        
        let BASE_R = CGFloat(getColrValue())
        let BASE_G = CGFloat(getColrValue())
        let BASE_B = CGFloat(getColrValue())
        
        let BASE_COLOR = UIColor.init(red: BASE_R/255.0, green: BASE_G/255.0, blue: BASE_B/255.0, alpha: 1.0)
        fernBase.color = BASE_COLOR
//        fernBase.color = .purple
        fernBase.colorBlendFactor = 1.0
        addChild(fernBase)

//        background.size = self.frame.size
//        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
//        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        self.addChild(background)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //I don't know if this is the exact place you'd do it but
        
//        //if you register a hit on red, blue, green etc... you'd use one of the corresponding
//        if RED < 256{
//            RED += 8
//        }
//        if GREEN < 256{
//            GREEN += 8
//        }
//        if BLUE < 256{
//            BLUE += 8
//        }
//
//        //Shedding would be similar based on the color, check if the color is greater than 0 and if it is subtract then update chameleon color
//        if RED > 0{
//            RED -= 8
//        }
//        if GREEN > 0{
//            GREEN -= 8
//        }
//        if BLUE > 0{
//            BLUE -= 8
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        

    }
    func getColrValue() -> Int{
        var BASE = Int(arc4random_uniform(255))
        if BASE % 8 != 0{
            BASE = BASE + (BASE % 8)
            if(BASE > 255){
                BASE = 255
            }
        }
        return BASE;
    }

}
