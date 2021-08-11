//
//  GameScene.swift
//  NigeroKanji
//
//  Created by Aldino Efendi on 2021/07/25.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    @objc var background:SKSpriteNode!
    var sakuraFalls:SKEmitterNode!
    var player:SKSpriteNode!
    var pauseBTN = SKSpriteNode()
    var unpauseBTN = SKLabelNode(fontNamed: "Arial-BoldMT")
    var mapBTN = SKLabelNode(fontNamed: "Arial-BoldMT")
    var pauseBackground: SKSpriteNode!
    var questionBox: SKSpriteNode!
    var rectangle: SKSpriteNode!
    var lifeIcon: SKSpriteNode!
    var rectangleScore: SKSpriteNode!
    let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    let livesLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    let questionLabel = SKLabelNode(fontNamed: "arial")
    var questionLabel2 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel1 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel2 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel3 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel4 = SKLabelNode(fontNamed: "arial")
    let countDownLabel = SKLabelNode(fontNamed: "arial")
    var levelTimerLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    var answerLabel = SKLabelNode(fontNamed: "arial")
		var pauseLabel = SKLabelNode(fontNamed: "arial")
		var pauseDescriptionLabel = SKLabelNode(fontNamed: "arial")
    let spawnWallImage = SKSpriteNode(imageNamed: "wall")
    var model = Question()
    
    let spawnAnswer = SKSpriteNode(imageNamed: "Door")
    
    var livesNumber = 3
    var levelNumber = 1
    var levelTime = 10
    var levelTimerValue: Int = 9 {
        didSet {
            levelTimerLabel.text = "\(levelTimerValue)"
        }
    }
    
    var gameScore = 0
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)/10"
        }
    }
    
    enum GameState{
        case preGame
        case inGame
        case afterGame
    }
    
    var gameTimer:Timer!
    var possibleAliens = "alien2"
    var currentGameState = GameState.preGame
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Answer : UInt32 = 0b10 //2
        static let Alien: UInt32 = 0b100 //4
    }

    let gameArea: CGRect
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        self.gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
//        sakuraFalls = SKEmitterNode(fileNamed: "Starfield")
//        sakuraFalls.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
//        sakuraFalls.advanceSimulationTime(10)
//        sakuraFalls.setScale(1)
//        self.addChild(sakuraFalls)
//        sakuraFalls.zPosition = 1
        
        runningBackground1()
        runningBackground2()
        
			
        questionLabel.numberOfLines = 3
        questionLabel.fontSize = 75
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.fontColor = SKColor.white
        questionLabel.preferredMaxLayoutWidth = self.frame.size.width/1.25
        questionLabel.position = CGPoint(x: (self.size.width/2) + 20, y: (self.size.height/2) - 180)
        questionLabel.zPosition = 3
        questionLabel.isHidden = true
        self.addChild(questionLabel)
			
				questionLabel2.numberOfLines = 1
				questionLabel2.horizontalAlignmentMode = .center
				questionLabel2.fontSize = 180
				questionLabel2.preferredMaxLayoutWidth = self.frame.size.width/1.25
				questionLabel2.zPosition = 4
				questionLabel2.fontColor = SKColor.white
				questionLabel2.position = CGPoint(x: (self.size.width/2) + 20, y: (self.size.height/2) - 340)
				questionLabel2.isHidden = true
				self.addChild(questionLabel2)
        
        answerLabel.fontSize = 100
        answerLabel.fontColor = SKColor.brown
        answerLabel.preferredMaxLayoutWidth = self.frame.size.width/2
        answerLabel.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) - 300)
        answerLabel.zPosition = 1
        
        kanjiLebel1.fontSize = 75
        kanjiLebel1.fontColor = SKColor.white
        kanjiLebel1.position = CGPoint(x: self.frame.size.width/8, y: self.frame.size.height/1.5)
        kanjiLebel1.zPosition = 5
        self.addChild(kanjiLebel1)
				kanjiLebel1.isHidden = true
        
        kanjiLebel2.fontSize = 75
        kanjiLebel2.fontColor = SKColor.white
				kanjiLebel2.position = CGPoint(x: (self.frame.size.width/8) * 3, y: self.frame.size.height/1.5)
        kanjiLebel2.zPosition = 5
        self.addChild(kanjiLebel2)
				kanjiLebel2.isHidden = true
        
        kanjiLebel3.fontSize = 75
        kanjiLebel3.fontColor = SKColor.white
				kanjiLebel3.position = CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height/1.5)
        kanjiLebel3.zPosition = 5
        self.addChild(kanjiLebel3)
				kanjiLebel3.isHidden = true
        
        kanjiLebel4.fontSize = 75
        kanjiLebel4.fontColor = SKColor.white
				kanjiLebel4.position = CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height/1.5)
        kanjiLebel4.zPosition = 5
        self.addChild(kanjiLebel4)
				kanjiLebel4.isHidden = true
        
        // player
        player = SKSpriteNode(imageNamed: "ninja1")
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 - 88)
				player.setScale(0.4)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/4)
        player.physicsBody?.isDynamic = true
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Alien | PhysicsCategories.Answer
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.scoreLabel.text = "Score: \(gameScore)"
        self.scoreLabel.fontSize = 70
        self.scoreLabel.fontColor = SKColor.white
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.scoreLabel.position = CGPoint(x: (self.frame.size.width/2) + 150, y: self.frame.size.height/1.106)
        self.scoreLabel.zPosition = 5
        self.addChild(self.scoreLabel)
        
        self.livesLabel.text = "3"
        self.livesLabel.fontSize = 100
        self.livesLabel.fontColor = SKColor.white
        self.livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.livesLabel.position = CGPoint(x: (self.frame.size.width/2) - 50, y: self.frame.size.height/1.112)
        self.livesLabel.zPosition = 5
        self.addChild(self.livesLabel)
        
        // Timer
				levelTimerLabel.fontColor = SKColor(red: 50/255, green: 157/255, blue: 168/255, alpha: 1)
        levelTimerLabel.fontSize = 180
        levelTimerLabel.position = CGPoint(x: (self.frame.size.width/2) - 420, y: (self.frame.size.height/2) - 160 )
        levelTimerLabel.zPosition = 3
        addChild(levelTimerLabel)
        levelTimerLabel.isHidden = false

        pauseBTN = SKSpriteNode(imageNamed: "pausebutton")
        pauseBTN.position = CGPoint(x: (self.frame.size.width/8) - 20, y: self.frame.size.height/1.093)
        pauseBTN.setScale(1)
        pauseBTN.zPosition = 3
        addChild(pauseBTN)
        pauseBTN.isHidden = false
        
        rectangle = SKSpriteNode(imageNamed: "Rectangle")
        rectangle.position = CGPoint(x: (self.frame.size.width/2) - 150, y: self.frame.size.height/1.10)
        rectangle.setScale(3.5)
        rectangle.zPosition = 3
        addChild(rectangle)
        
        lifeIcon = SKSpriteNode(imageNamed: "LifeIcon")
        lifeIcon.position = CGPoint(x: (self.frame.size.width/2) - 230, y: self.frame.size.height/1.093)
        lifeIcon.setScale(3.5)
        lifeIcon.zPosition = 4
        addChild(lifeIcon)
        
        rectangleScore = SKSpriteNode(imageNamed: "RectangleScore")
        rectangleScore.position = CGPoint(x: (self.frame.size.width/2) + 320, y: self.frame.size.height/1.0992)
        rectangleScore.setScale(3.5)
        rectangleScore.zPosition = 3
        addChild(rectangleScore)
			
				pauseLabel.text = "Paused"
				pauseLabel.fontSize = 120
				pauseLabel.color = SKColor.white
				pauseLabel.position = CGPoint(x: (self.frame.size.width / 2), y: (self.frame.size.width/2) + 910)
				pauseLabel.zPosition = 10
				addChild(pauseLabel)
				pauseLabel.isHidden = true
				
				
				pauseDescriptionLabel.fontSize = 65
				pauseDescriptionLabel.numberOfLines = 2
				pauseDescriptionLabel.color = SKColor.white
				pauseDescriptionLabel.position = CGPoint(x: (self.frame.size.width / 2), y: (self.frame.size.width/2) + 650)
				pauseDescriptionLabel.zPosition = 10
				addChild(pauseDescriptionLabel)
				pauseDescriptionLabel.isHidden = true
        
        unpauseBTN.text = "Resume"
        unpauseBTN.color = UIColor.white
        unpauseBTN.position = CGPoint(x: (self.frame.size.width/2) + 220, y: (self.frame.size.height/2 - 220))
        unpauseBTN.zPosition = 9
        unpauseBTN.setScale(3)
        addChild(unpauseBTN)
        unpauseBTN.isHidden = true
        
        mapBTN.text = "Map"
        mapBTN.color = UIColor.white
        mapBTN.position = CGPoint(x: (self.frame.size.width/2) - 220, y: (self.frame.size.height/2 - 220))
        mapBTN.zPosition = 9
        mapBTN.setScale(3)
        addChild(mapBTN)
        mapBTN.isHidden = true
        
        pauseBackground = SKSpriteNode(imageNamed: "PauseBg")
        pauseBackground.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 50)
        pauseBackground.zPosition = 8
        pauseBackground.setScale(3.5)
        addChild(pauseBackground)
        pauseBackground.isHidden = true
        
        questionBox = SKSpriteNode(imageNamed: "questionBox")
        questionBox.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) - 200 )
        questionBox.zPosition = 2
        questionBox.setScale(3.5)
        addChild(questionBox)
        questionBox.isHidden = true
        
        playerMove()
        spawn()
        timmer()
        kanjiLabel()

        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
        if let accelerometerData = data {
           let acceleration = accelerometerData.acceleration
           self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
        
    }
    
    @objc func kanjiLabel(){
        model.showKanji()
        let kanjiBallon1 = model.screenKanji1.karakter
        let kanjiBallon2 = model.screenKanji2.karakter
        let kanjiBallon3 = model.screenKanji3.karakter
        let kanjiBallon4 = model.screenKanji4.karakter
        let question = model.kanjiArti
        let answer = model.kanjiKarakter
        
        scoreLabel.text = "Score: \(gameScore)"
				self.pauseDescriptionLabel.text = "Currently you have answered \n\(gameScore) questions correctly"
        self.kanjiLebel1.text = kanjiBallon1
        self.kanjiLebel2.text = kanjiBallon2
        self.kanjiLebel3.text = kanjiBallon3
        self.kanjiLebel4.text = kanjiBallon4
        self.questionLabel.text = "kanji of"
				self.questionLabel2.text = "\(question)"
        self.answerLabel.text = answer
           
    }
    
    func kanjiSpawnA() {

                    if kanjiLebel1.text != answerLabel.text {
                        addAlien1a()
                    }else {
                        addAnswer1a()
                    }
                    if kanjiLebel2.text != answerLabel.text{
                       addAlien2a()
                    }else {
                        addAnswer2a()
                    }
                    if kanjiLebel3.text != answerLabel.text {
                        addAlien3a()
                    }else {
                        addAnswer3a()
                    }
                    if kanjiLebel4.text != answerLabel.text {
                        addAlien4a()
                    }else {
                       addAnswer4a()
                    }
    }
    
    func kanjiSpawnB() {

                    if kanjiLebel1.text != answerLabel.text {
                        addAlien1b()
                    }else {
                        addAnswer1b()
                    }
                    if kanjiLebel2.text != answerLabel.text{
                       addAlien2b()
                    }else {
                        addAnswer2b()
                    }
                    if kanjiLebel3.text != answerLabel.text {
                        addAlien3b()
                    }else {
                        addAnswer3b()
                    }
                    if kanjiLebel4.text != answerLabel.text {
                        addAlien4b()
                    }else {
                       addAnswer4b()
                    }
    }
    
    @objc func playerMove() {
        let textureAtlas = SKTextureAtlas(named: "Player")
        let frame0 = textureAtlas.textureNamed("ninja1")
        let frame1 = textureAtlas.textureNamed("ninja2")
        let frame2 = textureAtlas.textureNamed("ninja3")
        let frame3 = textureAtlas.textureNamed("ninja4")
        let frame4 = textureAtlas.textureNamed("ninja5")
        let frame5 = textureAtlas.textureNamed("ninja6")
        let frame6 = textureAtlas.textureNamed("ninja7")
        let frame7 = textureAtlas.textureNamed("ninja8")
			
        let player1texture = [frame0, frame1, frame2, frame3, frame4, frame5, frame6, frame7]
        
        let animateAction = SKAction.animate(with: player1texture, timePerFrame: 0.1)
        player.run(animateAction)
    }
    
    @objc func runningBackground1() {
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        background.setScale(1)
        background.zPosition = -1
        self.addChild(background)
        let animationDuration:TimeInterval = 3.75
        var actionBackground = [SKAction]()
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        actionBackground.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: -background.size.height), duration: animationDuration))
        background.run(SKAction.sequence(actionBackground))
        
    }
    
    @objc func runningBackground2() {
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        background.setScale(1)
        let animationDuration:TimeInterval = 2.5
        self.addChild(background)
        var actionBackground = [SKAction]()
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height+frame.size.height/2)
        actionBackground.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), duration: animationDuration))
        background.run(SKAction.sequence(actionBackground))
        background.zPosition = -1

    }
    
    @objc func timmer() {
        
        levelTimerLabel.text = "\(levelTimerValue)"
				levelTimerLabel.isHidden = true
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({
                [unowned self] in

                if levelTimerValue > 0{
                   levelTimerValue -= 1
                    
                    if levelTimerValue == 8 {
                        spawnWall1()
                        kanjiSpawnA()
                    }
									
										if levelTimerValue == 7 {
												levelTimerLabel.isHidden = false
												questionBox.isHidden = false
												questionLabel.isHidden = false
												questionLabel2.isHidden = false
												kanjiLebel1.isHidden = false
												kanjiLebel2.isHidden = false
												kanjiLebel3.isHidden = false
												kanjiLebel4.isHidden = false
										}
                    
                    if levelTimerValue == 0 {
												kanjiLebel1.isHidden = true
												kanjiLebel2.isHidden = true
												kanjiLebel3.isHidden = true
												kanjiLebel4.isHidden = true
                        
                        var wallArray = [SKAction]()
                        wallArray.append(SKAction.removeFromParent())
                        questionLabel.isHidden = true
                        questionLabel2.isHidden = true
                        questionBox.isHidden = true
                        levelTimerLabel.isHidden = true
                        correctPosition()
                        spawnWall2()
                        kanjiSpawnB()
                    }
									
								} else {
										levelTimerValue = levelTime
										kanjiLabel()
										enableGyro()
										levelNumber += 1
//										if levelNumber == 10 {
//												runGameOver()
//										}
								}
            })
        let sequence = SKAction.sequence([block, wait])
    run(SKAction.repeatForever(sequence))
    }
    
    
    func spawn() {
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.7), target: self, selector: #selector(playerMove), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.5), target: self, selector: #selector(runningBackground1), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.5), target: self, selector: #selector(runningBackground2), userInfo: nil, repeats: true)
      
    }
    
    
    
    func runGameOver(){
        
        self.currentGameState = GameState.afterGame
        
        self.removeAllActions()
        
        let changeSceneAction = SKAction.run(self.changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func runGameWin(){
        
        self.currentGameState = GameState.afterGame
        self.removeAllActions()
        let changeSceneAction = SKAction.run(self.changeSceneWin)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
				
				sceneToMoveTo.question = "\(questionLabel2.text!)"
				sceneToMoveTo.kanji = "\(answerLabel.text!)"

        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func changeSceneMap(){
        
        print("you in map")
//        let sceneToMoveTo = ViewController(size: self.size)
//        sceneToMoveTo.scaleMode = self.scaleMode
//
//        let myTransition = SKTransition.fade(withDuration: 0.5)
//        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func changeSceneWin(){
        
        let sceneToMoveTo = GameWinScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode

        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    func addScore(){
        
        gameScore += 1
        self.scoreLabel.text = "Score: \(gameScore)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        self.scoreLabel.run(scaleSequence)
        
//        if(self.gameScore == 10){
//            player.removeFromParent()
//            self.runGameWin()
//        }
    }
    
    func loseLife(){

        self.livesNumber -= 1
        
        if livesNumber == -1 {
            self.livesLabel.text = "0"
        }else {
            self.livesLabel.text = "\(self.livesNumber)"
        }

        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        self.livesLabel.run(scaleSequence)

        if(self.livesNumber == 0){
            player.removeFromParent()
            self.runGameOver()
        }
    }
    
    func createPauseBTN()
    {
        pauseBTN = SKSpriteNode(imageNamed: "pausebutton")
        pauseBTN.position = CGPoint(x: (self.frame.size.width/8) - 50, y: self.frame.size.height/1.08)
        pauseBTN.setScale(0.5)
        pauseBTN.zPosition = 3
        addChild(pauseBTN)
        
    }

    @objc func pauseGame() {
        scene?.view?.isPaused = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches
        {
            let location = touch.location(in: self)

            if pauseBTN.contains(location) {
                gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(pauseGame), userInfo: nil, repeats: false)
                pauseBTN.isHidden = true
                unpauseBTN.isHidden = false
                pauseBackground.isHidden = false
                mapBTN.isHidden = false
                questionLabel.isHidden = true
								questionLabel2.isHidden = true
                questionBox.isHidden = true
                levelTimerLabel.isHidden = true
								pauseLabel.isHidden = false
								pauseDescriptionLabel.isHidden = false
								kanjiLebel1.isHidden = true
								kanjiLebel2.isHidden = true
								kanjiLebel3.isHidden = true
								kanjiLebel4.isHidden = true
							
            }

            if unpauseBTN.contains(location) {
                scene?.view?.isPaused = false
                pauseBTN.isHidden = false
                unpauseBTN.isHidden = true
                pauseBackground.isHidden = true
                mapBTN.isHidden = true
                questionLabel.isHidden = false
								questionLabel2.isHidden = false
                questionBox.isHidden = false
                levelTimerLabel.isHidden = false
								pauseLabel.isHidden = true
								pauseDescriptionLabel.isHidden = true
                
                if levelTimerValue < 7 {
                    kanjiLebel1.isHidden = false
                    kanjiLebel2.isHidden = false
                    kanjiLebel3.isHidden = false
                    kanjiLebel4.isHidden = false
                    
                }
                
            }
            
            if mapBTN.contains(location) {
              changeSceneMap()
                
            }
        }
    }
    
    @objc func spawnWall1() {
        
        spawnWallImage.setScale(1.40)
        spawnWallImage.zPosition = 2
        self.addChild(spawnWallImage)
        let animationDuration:TimeInterval = 1
        var wallArray = [SKAction]()
        spawnWallImage.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height + spawnWallImage.size.height) // start poin
        wallArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.25), duration: animationDuration))
        
        spawnWallImage.run(SKAction.sequence(wallArray))
//        let sequence = SKAction.sequence([block, wait])
    }
    
    @objc func spawnWall2() {
        
        spawnWallImage.setScale(1.40)
        spawnWallImage.zPosition = 2
        let animationDuration:TimeInterval = 1
        var wallArray = [SKAction]()
        spawnWallImage.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.25) // start poin
        wallArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: -spawnWallImage.size.height), duration: animationDuration)) // end poin
        wallArray.append(SKAction.removeFromParent())
        
        spawnWallImage.run(SKAction.sequence(wallArray))
    
    }
    
    @objc func addAnswer1a() {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/8, y: self.frame.size.height + spawnAnswer.size.height)
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/8, y: self.frame.size.height/1.42), duration: animationDuration))
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    }
    
    @objc func addAnswer1b() {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/8, y: self.frame.size.height/1.5)
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/8, y: -spawnAnswer.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    }

    
    @objc func addAnswer2a () {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
//        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: (self.frame.size.width/8) * 3, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 3, y: self.frame.size.height/1.42), duration: animationDuration))
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer2b() {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: (self.frame.size.width/8) * 3, y: self.frame.size.height/1.5)
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 3, y: -spawnAnswer.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    }
    
    @objc func addAnswer3a () {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")

        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
//        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height/1.42), duration: animationDuration))
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer3b() {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height/1.5)
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 5, y: -spawnAnswer.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    }
    
    @objc func addAnswer4a() {
        
        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
//        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height/1.42), duration: animationDuration)) //
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer4b() {

        let spawnAnswer = SKSpriteNode(imageNamed: "Door")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(2)
        spawnAnswer.zPosition = 3
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height/1.5)
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 7, y: -spawnAnswer.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        spawnAnswer.run(SKAction.sequence(actionArray))
    }
    
    @objc func addAlien1a() {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/8 , y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/8 , y: self.frame.size.height/1.42), duration: animationDuration)) // end
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien1b() {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/8, y: self.frame.size.height/1.5) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/8, y: -alien.size.height), duration: animationDuration)) // end
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien2a () {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: (self.frame.size.width/8) * 3, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8 ) * 3, y: self.frame.size.height/1.42), duration: animationDuration))
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien2b() {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: (self.frame.size.width/8) * 3, y: self.frame.size.height/1.5) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 3, y: -alien.size.height), duration: animationDuration)) // end
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien3a () {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height/1.42), duration: animationDuration))
        
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien3b() {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: (self.frame.size.width/8) * 5, y: self.frame.size.height/1.5) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 5, y: -alien.size.height), duration: animationDuration)) // end
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien4a () {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1.05
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height/1.42), duration: animationDuration))
        actionArray.append(SKAction.wait(forDuration: 7))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien4b() {
        
        let alien = SKSpriteNode(imageNamed: "Door")
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(2)
        alien.zPosition = 3
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: (self.frame.size.width/8) * 7, y: self.frame.size.height/1.5) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 7, y: -alien.size.height), duration: animationDuration)) // end
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        

        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
            
        } else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if(body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Alien){
            
            //if player hits enemy
            if(body1.node != nil){

                body2.node?.removeFromParent()
                self.changeDoor(spawnPosition: body1.node!.position)
                let loseALife = SKAction.run(self.loseLife)
                let enemySequence = SKAction.sequence([loseALife])
                    run(enemySequence)
                
            }
            
            if(body2.node != nil){
                self.changeDoor(spawnPosition: body2.node!.position)
            }
        }
        
        if(body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Answer){
            
            //if bullet hits enemy
            if(body1.node != nil){
                
                self.changeDoor(spawnPosition: body2.node!.position)
                addScore()
                body2.node?.removeFromParent()
                
            }
        }
    }
    
    func changeDoor(spawnPosition: CGPoint){
        
        let doorOpen = SKSpriteNode(imageNamed: "DoorOpen")
        doorOpen.position = spawnPosition
        doorOpen.zPosition = 8
        doorOpen.setScale(0.5)
        self.addChild(doorOpen)
        
//        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
//        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
//        let delete = SKAction.removeFromParent()
//        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        let animationDuration:TimeInterval = 0.325
        var doorArray = [SKAction]()
        doorArray.append(SKAction.move(to: CGPoint(x: spawnPosition.x, y: -doorOpen.size.height), duration: animationDuration)) // end
        doorArray.append(SKAction.removeFromParent())
        doorOpen.run(SKAction.sequence(doorArray))
//        doorOpen.run(explosionSequence)
    }
    
    func correctPosition() {
            motionManger.accelerometerUpdateInterval = 0.0
            motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
               let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.0 + self.xAcceleration * 0.0}}

            motionManger.accelerometerUpdateInterval = 0.0
            var playerArray = [SKAction]()

        if self.player.position.x > 0 && self.player.position.x < 292.49  {
                
                playerArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/8, y: player.size.height / 2 + 150), duration: 0.5))
                player.run(SKAction.sequence(playerArray))
                
                //Kiri 1 146.24996948242188
                //Kiri 2 438.75
                //Kiri 3 731.2499389648438
                //Kiri 4 1023.75
            }
        else if self.player.position.x > 292.5 && self.player.position.x < 585  {
            playerArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 3, y: player.size.height / 2 + 150), duration: 0.5))
                player.run(SKAction.sequence(playerArray))

        }else if self.player.position.x > 585.01 && self.player.position.x < 877.5  {
            playerArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 5, y: player.size.height / 2 + 150), duration: 0.5))
                player.run(SKAction.sequence(playerArray))

        }else if self.player.position.x > 877.51 && self.player.position.x < self.frame.width {
                    
                playerArray.append(SKAction.move(to: CGPoint(x: (self.frame.size.width/8) * 7, y: player.size.height / 2 + 150), duration: 0.5))
                    player.run(SKAction.sequence(playerArray))
                }

        
    }
    
    func enableGyro () {
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
        
    }

    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 100
        
        if (self.player.position.x > (self.gameArea.maxX - self.player.size.width)){
            self.player.position.x = (self.gameArea.maxX - self.player.size.width)
        }

        if (self.player.position.x < (self.gameArea.minX + self.player.size.width)){
            self.player.position.x = (self.gameArea.minX + self.player.size.width)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
