//
//  GameViewController.swift
//  colorV2
//
//  Created by Kairi Malcolm Sameshima on 12/10/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
class GameViewController: UIViewController {
    var backgroundMusic: AVAudioPlayer!
    func playSoundWith(fileName: String, fileExtension: String){
        let audioSourceURL: URL!
        audioSourceURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        do{
            backgroundMusic = try AVAudioPlayer.init(contentsOf: audioSourceURL!)
            backgroundMusic.prepareToPlay()
            backgroundMusic.setVolume(0.1, fadeDuration: 0)
            backgroundMusic.play()
            backgroundMusic.numberOfLoops = -1
        }
        catch{
            print("darn")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

        let scene = GameScene(fileNamed: "MainMenuScene")
        let skView = view as! SKView
        playSoundWith(fileName: "background", fileExtension: "mp3")
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.isMultipleTouchEnabled = true


        if let scene = GKScene(fileNamed: "MainMenuScene") {
        
            
            // Get the SKScene from the loaded GKScene

            if let sceneNode = scene.rootNode as! MainMenuScene? {
                
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.isMultipleTouchEnabled = true

                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

