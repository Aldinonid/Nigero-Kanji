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
    var unpauseBTN = SKLabelNode(fontNamed: "arial")
    var pauseBackground: SKSpriteNode!
    let scoreLabel = SKLabelNode(fontNamed: "arial")
    let livesLabel = SKLabelNode(fontNamed: "arial")
    let questionLabel = SKLabelNode(fontNamed: "arial")
    let kanjiLebel1 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel2 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel3 = SKLabelNode(fontNamed: "arial")
    let kanjiLebel4 = SKLabelNode(fontNamed: "arial")
    let countDownLabel = SKLabelNode(fontNamed: "arial")
    var levelTimerLabel = SKLabelNode(fontNamed: "arial")
    var answerLabel = SKLabelNode(fontNamed: "arial")
    var model = Question()
    
    var livesNumber = 3
    var levelNumber = 1
    var spawnTime = 7
    var levelTime = 7
    var levelTimerValue: Int = 8 {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    var gameScore = 0
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
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
        
//        model.showKanji()
//        let kanjiBallon1 = model.screenKanji1.karakter
//        let kanjiBallon2 = model.screenKanji2.karakter
//        let kanjiBallon3 = model.screenKanji3.karakter
//        let kanjiBallon4 = model.screenKanji4.karakter
//        let question = model.kanjiArti
//        let answer = model.kanjiKarakter
//
//        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
//        let block = SKAction.run({
//                [unowned self] in
//
//                if gameTime > 0 {
//                   gameTime -= 1
//                }else {
//
//                    if kanjiBallon1 != answer {
//                        addAlien1()
//                    }else {
//                        addAnswer1()
//                    }
//                    if kanjiBallon2 != answer{
//                       addAlien2()
//                    }else {
//                        addAnswer2()
//                    }
//                    if kanjiBallon3 != answer {
//                        addAlien3()
//                    }else {
//                        addAnswer3()
//                    }
//                    if kanjiBallon4 != answer {
//                        addAlien4()
//                    }else {
//                       addAnswer4()
//                    }
//                    print("looping 1")
//                }
//            })
//            let sequence = SKAction.sequence([block, wait])
//        self.run(SKAction.repeatForever(sequence))
//        self.run(sequence)
        
        
//        self.questionLabel.text = "Guess Which the Meaning of Kanji is \"\(question)\""
        questionLabel.numberOfLines = 3
        questionLabel.fontSize = 75
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.fontColor = SKColor.brown
        questionLabel.preferredMaxLayoutWidth = self.frame.size.width/2
        questionLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        questionLabel.zPosition = 1
        self.addChild(questionLabel)
        
//        answerLabel.text = answer
        answerLabel.fontSize = 100
        answerLabel.fontColor = SKColor.brown
        answerLabel.preferredMaxLayoutWidth = self.frame.size.width/2
        answerLabel.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) - 300)
        answerLabel.zPosition = 1
       self.addChild(answerLabel)
        
//        kanjiLebel1.text = kanjiBallon1
        kanjiLebel1.fontSize = 175
        kanjiLebel1.fontColor = SKColor.brown
        kanjiLebel1.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height/1.25)
        kanjiLebel1.zPosition = 1
        self.addChild(kanjiLebel1)
        
//        kanjiLebel2.text = kanjiBallon2
        kanjiLebel2.fontSize = 175
        kanjiLebel2.fontColor = SKColor.brown
        kanjiLebel2.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height/1.25)
        kanjiLebel2.zPosition = 1
        self.addChild(kanjiLebel2)
        
//        kanjiLebel3.text = kanjiBallon3
        kanjiLebel3.fontSize = 175
        kanjiLebel3.fontColor = SKColor.brown
        kanjiLebel3.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height/1.25)
        kanjiLebel3.zPosition = 1
        self.addChild(kanjiLebel3)
        
//        kanjiLebel4.text = kanjiBallon4
        kanjiLebel4.fontSize = 175
        kanjiLebel4.fontColor = SKColor.brown
        kanjiLebel4.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height/1.25)
        kanjiLebel4.zPosition = 1
        self.addChild(kanjiLebel4)
        
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
        
        self.scoreLabel.text = "Score: 0"
        self.scoreLabel.fontSize = 70
        self.scoreLabel.fontColor = SKColor.brown
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.scoreLabel.position = CGPoint(x: self.frame.size.width/12, y: self.frame.size.height/1.08)
        self.scoreLabel.zPosition = 100
        self.addChild(self.scoreLabel)
        
        self.livesLabel.text = "Lives: 3"
        self.livesLabel.fontSize = 70
        self.livesLabel.fontColor = SKColor.brown
        self.livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.livesLabel.position = CGPoint(x: self.frame.size.width/1.05, y: self.frame.size.height/1.08)
        self.livesLabel.zPosition = 100
        self.addChild(self.livesLabel)
        
        // Timer
        levelTimerLabel.fontColor = SKColor.brown
        levelTimerLabel.fontSize = 70
        levelTimerLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.08)
        addChild(levelTimerLabel)

        pauseBTN = SKSpriteNode(imageNamed: "pausebutton")
        pauseBTN.position = CGPoint(x: (self.frame.size.width/8) - 50, y: self.frame.size.height/1.08)
        pauseBTN.setScale(3)
        pauseBTN.zPosition = 3
        addChild(pauseBTN)
        pauseBTN.isHidden = false
        
        unpauseBTN.text = "Resume"
        unpauseBTN.color = UIColor.brown
        unpauseBTN.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        unpauseBTN.zPosition = 3
        unpauseBTN.setScale(5)
        addChild(unpauseBTN)
        unpauseBTN.isHidden = true
        
        pauseBackground = SKSpriteNode(imageNamed: "pauseBackground")
        pauseBackground.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 50)
        pauseBackground.zPosition = 2
        pauseBackground.setScale(2.5)
        addChild(pauseBackground)
        pauseBackground.isHidden = true

        
        playerMove()
        spawn()
        timmer()
      
        kanjiSpawn()
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
        self.kanjiLebel1.text = kanjiBallon1
        self.kanjiLebel2.text = kanjiBallon2
        self.kanjiLebel3.text = kanjiBallon3
        self.kanjiLebel4.text = kanjiBallon4
        self.questionLabel.text = "coba tebak kanji mana yang artinya \"\(question)\""
        self.answerLabel.text = answer
           
    }
    
    func kanjiSpawn() {
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({
                [unowned self] in

                if spawnTime > 0 {
                   spawnTime -= 1
                }else {

                    if kanjiLebel1.text != answerLabel.text {
                        addAlien1()
                    }else {
                        addAnswer1()
                    }
                    if kanjiLebel2.text != answerLabel.text{
                       addAlien2()
                    }else {
                        addAnswer2()
                    }
                    if kanjiLebel3.text != answerLabel.text {
                        addAlien3()
                    }else {
                        addAnswer3()
                    }
                    if kanjiLebel4.text != answerLabel.text {
                        addAlien4()
                    }else {
                       addAnswer4()
                    }
                    spawnTime = levelTime
                }
            })
            let sequence = SKAction.sequence([block, wait])
        run(SKAction.repeatForever(sequence))
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
        
        levelTimerLabel.text = "Time : \(levelTimerValue)"
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({
                [unowned self] in

                if levelTimerValue > 0{
                   levelTimerValue -= 1
                    
                    if levelTimerValue == 1 {
                        correctPosition()
                    }
                }else{
                    levelTimerValue = levelTime
                    kanjiLabel()
                    enableGyro()
                    levelNumber += 1
                    if levelNumber == 10 {
                        runGameOver()
                    }
                }
            })
        let sequence = SKAction.sequence([block, wait])
    run(SKAction.repeatForever(sequence))
    }
    
    
    func spawn() {
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.6), target: self, selector: #selector(playerMove), userInfo: nil, repeats: true)
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

        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
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
        
        if(self.gameScore == 10){
            player.removeFromParent()
            self.runGameWin()
        }
    }
    
    func loseLife(){

        self.livesNumber -= 1
        
        if livesNumber == -1 {
            self.livesLabel.text = "Lives: 0"
        }else {
            self.livesLabel.text = "Lives: \(self.livesNumber)"
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
                
            }

            if unpauseBTN.contains(location) {
                scene?.view?.isPaused = false
                pauseBTN.isHidden = false
                unpauseBTN.isHidden = true
                pauseBackground.isHidden = true
                
            }
        }
    }
    

    
    @objc func addAnswer1 () {

        let spawnAnswer = SKSpriteNode(imageNamed: "alien")

        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/3.75, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer2 () {

        let spawnAnswer = SKSpriteNode(imageNamed: "alien")
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2.375, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer3 () {

        let spawnAnswer = SKSpriteNode(imageNamed: "alien")

        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.75, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer4 () {
        
        let spawnAnswer = SKSpriteNode(imageNamed: "alien")

        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        spawnAnswer.alpha = 0
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.375, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien1 () {
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/3.75, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien2 () {
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2.375, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien3 () {
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.75, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien4 () {
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.375, y: -alien.size.height), duration: animationDuration)) // end poin
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
                let loseALife = SKAction.run(self.loseLife)
                let enemySequence = SKAction.sequence([loseALife])
                    run(enemySequence)
            }
        }
        
        if(body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Answer){
            
            //if bullet hits enemy
            if(body1.node != nil){
                print(player.position.x)
                addScore()
                body2.node?.removeFromParent()

            }
        }
    }
    
    func torpedoDidCollideWithAlien (player:SKSpriteNode, alienNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        alienNode.removeFromParent()
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
    }
    
    func startNewLevel(){
       
//       self.levelNumber += 1
//
//       if(self.action(forKey: "spawningEnemies") != nil){
//           self.removeAction(forKey: "spawningEnemies")
//       }
//
////       var levelDuration = TimeInterval()
//
//
//       switch levelNumber {
//       case 1:
//       case 2: var kanjiStage2 = [kanjiLevel1, kanjiLevel2!, kanjiLevel3!, kanjiLevel4!] as [Any]
//
//       default:
////           levelDuration = 0.5
//           print("cannot find level info")
//       }
//
//       let spawn = SKAction.run(self.spawnAlien)
////       let waitToSpawn = SKAction.wait(forDuration: 2)
//       let spawnSequence = SKAction.sequence([spawn])
//       let spawnForever = SKAction.repeatForever(spawnSequence)
//       self.run(spawnForever, withKey: "spawningEnemies")
   }
    func correctPosition() {
            motionManger.accelerometerUpdateInterval = 0.0
            motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
               let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.0 + self.xAcceleration * 0.0}}

            motionManger.accelerometerUpdateInterval = 0.0
            var playerArray = [SKAction]()

        if self.player.position.x > 0 && self.player.position.x < 402.315 {
                
            playerArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/3.75, y: player.size.height / 2 + 150), duration: 1))
                player.run(SKAction.sequence(playerArray))
                //Kiri 1 312
                //Kiri 2 492.6314697265625
                //Kiri 3 668.5711669921875
                //Kiri 4 850.9088745117188
            }
        
        if self.player.position.x > 402.316 && self.player.position.x < 580.6  {
                print(player.position.x)
                playerArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2.375, y: player.size.height / 2 + 150), duration: 1))
                player.run(SKAction.sequence(playerArray))

            }
        if self.player.position.x > 580.601 && self.player.position.x < 759.739  {
                print(player.position.x)
                playerArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.75, y: player.size.height / 2 + 150), duration: 1))
                player.run(SKAction.sequence(playerArray))

            }

        if self.player.position.x > 759.740 && self.player.position.x < self.frame.size.width  {
                    print(player.position.x)
                    playerArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.375, y: player.size.height / 2 + 150), duration: 1))
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
