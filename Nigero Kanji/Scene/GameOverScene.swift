//
//  GameOverScene.swift
//  Stick-Hero
//
//  Created by Muhammad Noor Ansyari on 24/07/21.


import Foundation
import SpriteKit

class GameOverScene: SKScene{
 
    var restartLabel = SKLabelNode(fontNamed: "arial")
		var gameOverImage: SKSpriteNode!
		var gameOverBackground: SKSpriteNode!
		let gameOverLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
		let gameOverDescriptionLabel = SKLabelNode(fontNamed: "arial")
		var mapLabel = SKLabelNode(fontNamed: "arial")
    var background:SKSpriteNode!
    
    override func didMove(to view: SKView) {

//        let bckRnd = SKSpriteNode(imageNamed: "background")
//        bckRnd.size = self.size
//        bckRnd.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        bckRnd.zPosition = 0
//        self.addChild(bckRnd)
        
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//        starfield.advanceSimulationTime(10)
        background.setScale(1)
        self.addChild(background)
        background.zPosition = -1
			
				gameOverImage = SKSpriteNode(imageNamed: "ninjaheadcry")
				gameOverImage.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
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
				gameOverLabel.position = CGPoint(x: self.size.width / 2 , y: (self.size.height / 2) + 450)
				gameOverLabel.zPosition = 2
        self.addChild(gameOverLabel)
			
				gameOverDescriptionLabel.text = "The correct kanji for water is 水 \nYou are almost there, warrior! \nKeep going!"
				gameOverDescriptionLabel.numberOfLines = 3
				gameOverDescriptionLabel.fontSize = 50
				gameOverDescriptionLabel.fontColor = SKColor.white
				gameOverDescriptionLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
			gameOverDescriptionLabel.zPosition = 2
				self.addChild(gameOverDescriptionLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "arial")
//        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
//        let defaults = UserDefaults()
//        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
//        if (gameScore > highScoreNumber){
//            highScoreNumber = gameScore
//            defaults.set(highScoreNumber, forKey: "highScoreSaved")
//        }
        
//        let highScorelabel = SKLabelNode(fontNamed: "theboldfont")
//        highScorelabel.text = "High Score: \(highScoreNumber)"
//        highScorelabel.fontSize = 125
//        highScorelabel.fontColor = SKColor.white
//        highScorelabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
//        highScorelabel.zPosition = 1
//        self.addChild(highScorelabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.brown
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
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
            
        }
        
    }
    
    
}
