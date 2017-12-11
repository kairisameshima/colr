//
//  MainMenuScene.swift
//  colorV2
//
//  Created by Kairi Malcolm Sameshima on 12/10/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import Foundation

import SpriteKit

class MainMenuScene: SKScene {
    
    /* UI Connections */
    var buttonPlay: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        
        /* Setup button selection handler */
        buttonPlay.selectedHandler = { [unowned self] in
            
            if let view = self.view {
                
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                // Debug helpers
                view.isPaused = false
                view.showsFPS = true
                view.showsPhysics = true
                view.showsDrawCount = true
            }
        }
        
    }
}

