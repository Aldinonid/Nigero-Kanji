//
//  GameWinScene.swift
//  NigeroKanji
//
//  Created by Jeremy Yonathan on 01/08/21.
//




import Foundation
import SpriteKit

class GameWinScene: SKScene{
 
		var nextLevelLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
		var gameWinImage: SKSpriteNode!
		var gameWinBackground: SKSpriteNode!
		let gameWinLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
		let gameWinDescriptionLabel = SKLabelNode(fontNamed: "arial")
		var mapLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
		var background:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
			background = SKSpriteNode(imageNamed: "MainGameScreen")
			background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
			background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
			background.setScale(1)
			self.addChild(background)
			background.zPosition = -1
			
			gameWinImage = SKSpriteNode(imageNamed: "ninjahead")
			gameWinImage.position = CGPoint(x: (self.frame.size.width/2) + 50 , y: (self.frame.size.height/2) + 200 )
			gameWinImage.setScale(3)
			gameWinImage.zPosition = 2
			self.addChild(gameWinImage)
			
			gameWinBackground = SKSpriteNode(imageNamed: "GameAlertBackground")
			gameWinBackground.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 50)
			gameWinBackground.setScale(3.5)
			self.addChild(gameWinBackground)
			
			
			gameWinLabel.text = "Congratulations"
			gameWinLabel.fontSize = 90
			gameWinLabel.fontColor = SKColor.white
			gameWinLabel.position = CGPoint(x: self.size.width / 2 , y: (self.size.height / 2) + 400)
			gameWinLabel.zPosition = 2
			self.addChild(gameWinLabel)
			
			gameWinDescriptionLabel.text = "You’ve mastered all the kanji \nin Level 1, warrior. \nGo ahead to the next level!"
			gameWinDescriptionLabel.numberOfLines = 3
			gameWinDescriptionLabel.fontSize = 50
			gameWinDescriptionLabel.fontColor = SKColor.white
			gameWinDescriptionLabel.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) - 150 )
			gameWinDescriptionLabel.zPosition = 2
			self.addChild(gameWinDescriptionLabel)
			
			nextLevelLabel.text = "Next Level"
			nextLevelLabel.fontSize = 80
			nextLevelLabel.fontColor = SKColor.white
			nextLevelLabel.position = CGPoint(x: (self.size.width / 2) + 230, y: (self.size.height / 2) - 370 )
			nextLevelLabel.zPosition = 2
			self.addChild(nextLevelLabel)
			
			mapLabel.text = "Map"
			mapLabel.fontSize = 80
			mapLabel.color = UIColor.white
			mapLabel.position = CGPoint(x: (self.frame.size.width / 2) - 230, y: (self.frame.size.height/2) - 370)
			mapLabel.zPosition = 2
			addChild(mapLabel)
        
    }
	
	func changeSceneMap() {
		print("Going to Map Scene")
	}
	
	func changeSceneNextLevel() {
		print("Going to Next Level Scene")
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if(nextLevelLabel.contains(pointOfTouch)){
                changeSceneNextLevel()
            }
					
						if (mapLabel.contains(pointOfTouch)){
								changeSceneMap()
						}
            
        }
        
    }
    
    
}

