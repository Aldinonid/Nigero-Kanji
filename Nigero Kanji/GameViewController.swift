//
//  GameViewController.swift
//  NigeroKanji
//
//  Created by Aldino Efendi on 2021/07/25.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    var musicPlayer:AVAudioPlayer!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let scene = GameScene(size:CGSize(width: DefinedScreenWidth, height: DefinedScreenHeight))
//
//        // Configure the view.
//        let skView = self.view as! SKView
////        skView.showsFPS = true
////        skView.showsNodeCount = true
//
//        /* Sprite Kit applies additional optimizations to improve rendering performance */
//        skView.ignoresSiblingOrder = true
//
//        /* Set the scale mode to scale to fit the window */
//        scene.scaleMode = .aspectFill
//
//        skView.presentScene(scene)
//    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           guard let view = self.view as! SKView? else  {
               return
           }
           
           // Load the SKScene from 'GameScene.sks'
           var size: CGSize = self.view.bounds.size
           size.width *= UIScreen.main.scale
           size.height *= UIScreen.main.scale
           let scene = GameScene(size: size)
           // Set the scale mode to scale to fit the window
           scene.scaleMode = .aspectFill
           
           // Present the scene
           view.presentScene(scene)
           
           view.ignoresSiblingOrder = true
           
           view.showsFPS = true
           view.showsNodeCount = true
           
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        musicPlayer = setupAudioPlayerWithFile("Backsong", type: "m4a")
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        let url = Bundle.main.url(forResource: file as String, withExtension: type as String)
        var audioPlayer:AVAudioPlayer?

        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch {
            print("NO AUDIO PLAYER")
        }

        return audioPlayer!
    }


    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
