//
//  GameOverScene.swift
//  Stick-Hero
//
//  Created by Muhammad Noor Ansyari on 24/07/21.


import Foundation
import SpriteKit

class GameOverScene: SKScene{
 
    var restartLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
		var gameOverImage: SKSpriteNode!
		var gameOverBackground: SKSpriteNode!
		let gameOverLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
		let gameOverDescriptionLabel = SKLabelNode(fontNamed: "arial")
		var mapLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    var background:SKSpriteNode!
	
		var question = ""
		var kanji = ""
    
    override func didMove(to view: SKView) {
        
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        background.setScale(1)
        self.addChild(background)
        background.zPosition = -1
			
				gameOverImage = SKSpriteNode(imageNamed: "ninjaheadcry")
				gameOverImage.position = CGPoint(x: (self.frame.size.width/2) + 50 , y: (self.frame.size.height/2) + 200 )
				gameOverImage.setScale(3)
				gameOverImage.zPosition = 2
				self.addChild(gameOverImage)
			
				gameOverBackground = SKSpriteNode(imageNamed: "GameAlertBackground")
				gameOverBackground.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 50)
				gameOverBackground.setScale(3.5)
				self.addChild(gameOverBackground)
        
			
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 90
        gameOverLabel.fontColor = SKColor.white
				gameOverLabel.position = CGPoint(x: self.size.width / 2 , y: (self.size.height / 2) + 400)
				gameOverLabel.zPosition = 2
        self.addChild(gameOverLabel)
			
				gameOverDescriptionLabel.text = "The correct kanji for \(question) is \(kanji) \nYou are almost there, warrior! \nKeep going!"
				gameOverDescriptionLabel.numberOfLines = 3
				gameOverDescriptionLabel.fontSize = 50
				gameOverDescriptionLabel.fontColor = SKColor.white
				gameOverDescriptionLabel.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) - 150 )
				gameOverDescriptionLabel.zPosition = 2
				self.addChild(gameOverDescriptionLabel)
			
				restartLabel.text = "Restart"
				restartLabel.fontSize = 90
				restartLabel.fontColor = SKColor.white
				restartLabel.position = CGPoint(x: (self.size.width / 2) + 230, y: (self.size.height / 2) - 370 )
				restartLabel.zPosition = 2
				self.addChild(restartLabel)
			
				mapLabel.text = "Map"
				mapLabel.fontSize = 90
				mapLabel.color = UIColor.white
				mapLabel.position = CGPoint(x: (self.frame.size.width / 2) - 230, y: (self.frame.size.height/2) - 370)
				mapLabel.zPosition = 2
				addChild(mapLabel)
        
        
    }
	
	func changeSceneMap() {
		print("Going to Map Scene")
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if(restartLabel.contains(pointOfTouch)){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
						
					if mapLabel.contains(pointOfTouch) {
						changeSceneMap()
					}
            
        }
        
    }
    
    
}
