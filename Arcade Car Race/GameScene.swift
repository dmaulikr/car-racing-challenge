//
//  GameScene.swift
//  Arcade Car Race
//
//  Created by Alex Ongarato on 08/03/15.
//  Copyright (c) 2015 Alex Ongarato. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    /* constants */
    let distBetweenLevels       : Int = 700;
    let totalColumns            : Int = 6;
    let velocityIncrement       : CGFloat = 1;
    
    /* variables */
    var buttonLeft              : SKSpriteNode!;
    var buttonRight             : SKSpriteNode!;
    var mainCharacter           : CustomSpriteNode!;
    var enemiesArray            : Array<CustomSpriteNode>!;
    var currentEnemyVelocity    : CGFloat = 1;
    var currentLevel            : CGFloat = 1;
    var buttonSize              : CGSize = CGSize();
    var charactersSize          : CGSize = CGSize();
    var levelTriggerCounter     : Int = 1;
    var enemyTriggerCounter     : Int = 0;
    var distBetweenEnemies      : Int = -1;
    var totalLifes              : Int = 10;
    var isGameOver              : Bool = false;
    var gameStatus              : SKLabelNode!;
    var pixelWidth              : CGFloat = 0;
    
    override func didMoveToView(view: SKView)
    {
        //background
        var bg:SKSpriteNode = SKSpriteNode(imageNamed: "Background");
        self.addChild(bg);
        bg.zPosition = 0;
        bg.anchorPoint.x = 0;
        bg.anchorPoint.y = 0;
        
        //pixels
        pixelWidth = ((self.width) / (totalColumns.floatValue * 3));
        NSLog("pixelWidth:\(pixelWidth)");
        
        var pixelSize:CGRect = CGRect(x: -2, y: 0, width: pixelWidth, height: pixelWidth);
        var pixelCGImage:CGImageRef = UIImage(named:"PixelOff")!.CGImage;
        
        UIGraphicsBeginImageContext(self.size);
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        CGContextDrawTiledImage(context, pixelSize, pixelCGImage);
        var tiledPixels:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        var pixelTexture:SKTexture = SKTexture(CGImage: tiledPixels.CGImage);
        var pixelsNode:SKSpriteNode = SKSpriteNode(texture: pixelTexture);
        self.addChild(pixelsNode);
        pixelsNode.zPosition = 1;
        pixelsNode.anchorPoint.x = 0;
        pixelsNode.anchorPoint.y = 0;
        
        //
        enemiesArray = Array<CustomSpriteNode>();
        
        charactersSize.width = self.width.roundValue / totalColumns.floatValue;
        charactersSize.height = (charactersSize.width * 1.5).roundValue;
        
        buttonSize.width = self.width.half.roundValue;
        buttonSize.height = buttonSize.width.half.roundValue;
        
        //set main controll buttons
        buttonLeft = self.childNodeWithName("bt_left") as! SKSpriteNode;
        buttonRight = self.childNodeWithName("bt_right") as! SKSpriteNode;
        
        buttonLeft.size = buttonSize;
        buttonRight.size = buttonSize;
        
        buttonLeft.alpha = 0.5;
        buttonRight.alpha = 0.5;
        
        buttonLeft.x = buttonLeft.width.half;
        buttonLeft.y = buttonLeft.height.half;
        
        buttonRight.x = self.width - buttonRight.width.half;
        buttonRight.y = buttonRight.height.half;
        
        //set main character
        mainCharacter = CustomSpriteNode();
        mainCharacter.color = UIColor.blackColor();
        mainCharacter.alpha = 0.5;
        mainCharacter.size = charactersSize;
        mainCharacter.x = mainCharacter.width.half;
        mainCharacter.y = buttonSize.height + charactersSize.height.half;
        
        self.addChild(mainCharacter);
        
        self.mainCharacter.zPosition = 20;
        self.buttonLeft.zPosition = 21;
        self.buttonRight.zPosition = 22;
        
        addNewEnemy();
        
        
        self.gameStatus = SKLabelNode();
        self.gameStatus.x = self.width.half;
        self.gameStatus.y = self.height - 25;
        self.gameStatus.fontSize = 25;
        self.gameStatus.text = "initializing...";
        
        self.addChild(self.gameStatus);
        printStatus();
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            var node:SKNode = self.nodeAtPoint(location);
            if(node.name == "bt_left")
            {
                if(mainCharacter.x > mainCharacter.width)
                {
                    mainCharacter.x -= mainCharacter.width;
                }
            }
            
            if(node.name == "bt_right")
            {
                if(mainCharacter.x < self.width - mainCharacter.width)
                {
                    mainCharacter.x += mainCharacter.width;
                }
            }
        }
    }
    
    
    func showGameOverMessage()
    {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster");
        myLabel.text = "GAME OVER";
        myLabel.fontSize = 35;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        if(isGameOver)
        {
            return;
        }
        
        levelTriggerCounter++;
        enemyTriggerCounter++;
        
        distBetweenEnemies = Int(charactersSize.height * 3) / Int(currentLevel);
        
        if(enemyTriggerCounter > distBetweenEnemies)
        {
            enemyTriggerCounter = 0;
            addNewEnemy();
        }
        
        for enemyBlock in enemiesArray
        {
            if(enemyBlock.intersectsNode(mainCharacter))
            {
                if(!enemyBlock.isTouched)
                {
                    enemyBlock.isTouched = true;
                    enemyBlock.color = UIColor.blueColor();
                    totalLifes--;
                    printStatus();
                    if(totalLifes == 0)
                    {
                        isGameOver = true;
                        showGameOverMessage();
                        return;
                    }
                    
                }
            }
            
            enemyBlock.y -= currentEnemyVelocity;
            
            if(enemyBlock.y + enemyBlock.size.height.half < 0)//end on enemy life
            {
                enemyBlock.y = self.height + enemyBlock.height.half;
                enemyBlock.removeFromParent();
                enemiesArray.removeAtIndex(0);
            }
            
            if(levelTriggerCounter > distBetweenLevels)
            {
                currentLevel++;
                currentEnemyVelocity += velocityIncrement;
                levelTriggerCounter = 0;
                //                addNewEnemy()//add bonus enemy
                printStatus();
            }
        }
    }
    
    func addNewEnemy()
    {
        var newEnemy:CustomSpriteNode = CustomSpriteNode();
        newEnemy.size = charactersSize;
        newEnemy.width -= 0.1;
        newEnemy.color = UIColor.redColor();
        newEnemy.x = mainCharacter.width.half + (charactersSize.width * random(totalColumns-1).floatValue);
        newEnemy.y = self.height + newEnemy.height.half;
        enemiesArray.append(newEnemy);
        self.addChild(newEnemy);
        newEnemy.zPosition = 10;
    }
    
    func random(i:Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(1+i)));
    }
    
    func printStatus()
    {
        self.gameStatus.text = "level:\(Int(currentLevel))  |  life:\(totalLifes)  |  vel.:\(currentEnemyVelocity)";
        NSLog(self.gameStatus.text);
    }
    
}

class CustomSpriteNode:SKSpriteNode
{
    //properties
    var isTouched:Bool = false;
}


