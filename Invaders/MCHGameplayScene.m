//
//  MCHGameplayScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHGameplayScene.h"
#import "MCHMyScene.h"
#import "MCHInvader.h"
#import "MCHPlayer.h"
#import "MCHMissle.h"
#import "MCHShield.h"
#import "math.h"

@implementation MCHGameplayScene

int numInvaderAcross;
int numInvaderRows;
int numInvadersPerBoard;
int numInvadersFiring;
int level;
int fireFrequencyCounter;
int numPlayers;
int score;
BOOL respawning = NO;

- (void)spawnPlayer:(SKTextureAtlas *)atlas {
    SKTexture *playerTexture = [atlas textureNamed:@"invader-player.png"];
    self.player = [[MCHPlayer alloc] initWithTexture:playerTexture color:[UIColor whiteColor] size:CGSizeMake(40,24)];
    self.player.parentScene = self;
    self.player.direction = CGPointMake(0, 0);
    self.player.speed = 20;
    self.player.position = CGPointMake(self.size.width/2, 40+self.player.size.height);
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.categoryBitMask = playerCategory;
    self.player.physicsBody.collisionBitMask = invadeCategory;
    self.player.physicsBody.contactTestBitMask = invadeCategory;
    [self addChild:self.player];
}

- (void)updateScoreDisplay {
    self.scoreDisplay.text = [NSString stringWithFormat:@"level %d  score %d  pipes %d",level,score,numPlayers];
}

- (void)spawnInvaders:(SKTextureAtlas *)atlas {
    
    [self.invaders removeAllObjects];
    
    int startY = self.size.height-85;
    CGSize invaderSize = CGSizeMake(30, 30);
    int invaderSpacing = 10;
    int invaderGroupStartX = ((self.size.width-((numInvaderAcross*invaderSize.width)+((numInvaderAcross-1)*invaderSpacing)))/2)+invaderSize.width/2;
    int invaderGroupFinishX = invaderGroupStartX + ((numInvaderAcross*invaderSize.width)+((numInvaderAcross-1)*invaderSpacing));
    int invaderRange = self.size.width-4-invaderGroupFinishX;
    
    NSArray *invaderRowIndexMap = @[@(0),@(1),@(1),@(3),@(3)];
    
    for (int i=0; i<numInvaderRows; i++) {
        int startX = invaderGroupStartX;
        NSLog(@"startX:%d",startX);
        
        int imageIndexValue = [(NSNumber *)[invaderRowIndexMap objectAtIndex:i] intValue];
        NSLog(@"imageIndexValue:%d",imageIndexValue);
        SKTexture *rowInvader0 = [atlas textureNamed:[NSString stringWithFormat:@"invader0-row%d.png",imageIndexValue]];
        SKTexture *rowInvader1 = [atlas textureNamed:[NSString stringWithFormat:@"invader1-row%d.png",imageIndexValue]];
        NSArray *nextInvaderRowArray = @[rowInvader0,rowInvader1];
        
        for (int j=0; j<numInvaderAcross; j++) {
            MCHInvader *invader = [[MCHInvader alloc] initWithTexture:[nextInvaderRowArray objectAtIndex:0] color:[UIColor whiteColor] size:invaderSize];
            invader.parentScene = self;
            invader.direction = 0;
            invader.speed = 4.5+(level/5);
            if(invader.speed > invader.maxSpeed){
                invader.speed = invader.maxSpeed;
            }
            invader.textureArray = nextInvaderRowArray;
            invader.position = CGPointMake(startX, startY);
            invader.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:invader.size];
            invader.physicsBody.categoryBitMask = invadeCategory;
            invader.physicsBody.collisionBitMask = playerCategory;
            invader.physicsBody.contactTestBitMask = playerCategory;
            invader.range = invaderRange;
            invader.value = 10 * (numInvaderRows-(i+1));
            [self.invaders addObject:invader];
            [self addChild:invader];
            startX = startX + invaderSize.width + invaderSpacing;
            [invader runMoveAnimation];
            [invader moveLeftRight];
        }
        startY = startY - invaderSize.height - invaderSpacing;
    }
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        numPlayers = 3;
        
        self.invaderFireFrequency = 60;
        fireFrequencyCounter = 0;
        level = 1;
        numInvadersFiring = level * 1;
        self.gameState = GAMEON;
        
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        
        self.invaders = [[NSMutableArray alloc] init];
        self.activeMissles = [[NSMutableArray alloc] init];
        self.shields = [[NSMutableArray alloc] init];
        
        numInvaderAcross = 6;
        numInvaderRows = 5;
        numInvadersPerBoard = numInvaderAcross * numInvaderRows;

        [self spawnInvaders:atlas];
        [self spawnPlayer:atlas];
        
        self.pauseButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.pauseButtonLabel.text = @"pause";
        self.pauseButtonLabel.fontSize = 18;
        self.pauseButtonLabel.position = CGPointMake(self.frame.size.width - self.pauseButtonLabel.frame.size.width+10,self.size.height-40);
        [self addChild:self.pauseButtonLabel];

        self.pauseButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.pauseButtonLabel.frame.size.width+20, self.pauseButtonLabel.frame.size.height+50)];
        self.pauseButton.position = CGPointMake(self.frame.size.width - self.pauseButton.frame.size.width/2,self.size.height-self.pauseButton.frame.size.height/2);
        [self addChild:self.pauseButton];

        self.menuButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.menuButtonLabel.text = @"menu";
        self.menuButtonLabel.fontSize = 18;
        self.menuButtonLabel.position = CGPointMake(0+10+(self.menuButtonLabel.frame.size.width/2),self.pauseButtonLabel.position.y);
        [self addChild:self.menuButtonLabel];

        self.menuButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.menuButtonLabel.frame.size.width+20, self.menuButtonLabel.frame.size.height+50)];
        self.menuButton.position = CGPointMake(self.menuButtonLabel.frame.size.width/2,self.pauseButton.position.y);
        [self addChild:self.menuButton];
        
        self.playerShootButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width,self.player.position.y+self.player.frame.size.height)];
        self.playerShootButton.position = CGPointMake(CGRectGetMidX(self.frame),self.playerShootButton.frame.size.height/2);
        [self addChild:self.playerShootButton];
        
        self.scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        [self updateScoreDisplay];
        self.scoreDisplay.fontSize = 18;
        self.scoreDisplay.position = CGPointMake(CGRectGetMidX(self.frame),self.pauseButtonLabel.frame.origin.y - (self.pauseButtonLabel.frame.size.height+5));
        [self addChild:self.scoreDisplay];
        
        [self buildShields:3];
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.collisionBitMask = invadeCategory;
    }

    return self;
}

-(void)buildShields:(int)numShields{
    int shieldOrigX = 30;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
    SKTexture *shieldTexture = [atlas textureNamed:@"shield-bottle.png"];
    for (int i=0; i<numShields; i++){
        int shieldStartX = shieldOrigX;
        //I'm going to start with a simple 8 x 8 grid of shield particles that will make up 1 shield
        for(int x=0;x<6;x++){
            int shieldStartY = 110;
            for(int y=0;y<2;y++){
                MCHShield *shieldPiece = [[MCHShield alloc] initWithTexture:shieldTexture color:[UIColor whiteColor] size:CGSizeMake(10,26)];
                shieldPiece.position = CGPointMake(shieldStartX, shieldStartY);
                shieldPiece.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:shieldPiece.size];
                shieldPiece.physicsBody.categoryBitMask = shieldCategory;
                shieldPiece.physicsBody.collisionBitMask = missleCategory;
                shieldPiece.physicsBody.contactTestBitMask = missleCategory;
                [self.shields addObject:shieldPiece];
                [self addChild:shieldPiece];
                shieldStartY += (shieldPiece.frame.size.height+3);
            }
            shieldStartX += (10+3);
        }
        shieldOrigX += 100;
    }
}

- (void)respawnLevel{
    respawning = YES;
    [self removeAllActiveMissles];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        level++;
        [self spawnInvaders:[SKTextureAtlas atlasNamed:@"invader"]];
        [self updateScoreDisplay];
        respawning = NO;
    });
}

- (void)removeAllActiveMissles {
    //remove all active missles when the player is killed
    for(MCHMissle *nextMissle in self.activeMissles){
        [nextMissle removeFromParent];
    }
    [self.activeMissles removeAllObjects];
}

- (void)respawnPlayer{
    
    [self removeAllActiveMissles];
    //pause the movement of all the invaders (resume their movements when the player is actually respawned
    for(MCHInvader *nextInvader in self.invaders){
        [nextInvader setPaused:YES];
    }
    
    numPlayers--;
    [self updateScoreDisplay];
    if(numPlayers > 0){
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self spawnPlayer:[SKTextureAtlas atlasNamed:@"invader"]];
            //pause the movement of all the invaders (resume their movements when the player is actually respawned
            for(MCHInvader *nextInvader in self.invaders){
                [nextInvader setPaused:NO];
            }
            respawning = NO;
        });
    }else{
        [self gameOver];;
    }
}

- (void)didMoveToView:(SKView *)view{
    UIPanGestureRecognizer *playerControlGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragPlayer:)];
    playerControlGesture.minimumNumberOfTouches = 1;
    playerControlGesture.delegate = self;
    [[self view] addGestureRecognizer:playerControlGesture];
    
    UITapGestureRecognizer *playerFireGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePlayerTap:)];
    playerFireGesture.delegate = self;
    [[self view] addGestureRecognizer:playerFireGesture];
}

-(void)restartGame{
    level = 1;
    score = 0;
    numPlayers = 3;
    [self updateScoreDisplay];

    self.gameOverDisplay.hidden = YES;
    self.restartButtonLabel.hidden = YES;
    self.restartButton.hidden = YES;
    self.endGameBoss.hidden = YES;
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
    [self spawnPlayer:atlas];
    [self spawnInvaders:atlas];
    [self buildShields:3];
    self.gameState = GAMEON;
}

-(void)dragPlayer:(UIPanGestureRecognizer *)gesture{
    if(self.gameState == GAMEOVER || respawning || self.paused){
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"detecting pan");
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        touchLocation = [self convertPointFromView:touchLocation];
        if (touchLocation.y < self.player.position.y) {
            self.movePlayer = YES;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"in pan");
        if(self.movePlayer){
            NSLog(@"and moving player");
            CGPoint trans = [gesture translationInView:self.view];
            BOOL applyMove = YES;
            if (trans.x < 0) {
                if((self.player.position.x - self.player.size.width) + trans.x < 0){
                    applyMove = NO;
                }
            }else{
                if((self.player.position.x + self.player.size.width) + trans.x > self.size.width){
                    applyMove = NO;
                }
            }
            if (applyMove) {
                SKAction *movePlayer =  [SKAction moveByX:trans.x y:0  duration:0];
                [self.player runAction:movePlayer];
                [self.playerControl runAction:movePlayer];
            }
        }
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ending pan");
        self.movePlayer = NO;
    }
    
}

-(void)handlePauseButtonTap{
    if(self.gameState == GAMEON){
        self.paused = !self.paused;
        if(self.paused){
            self.pauseButtonLabel.text = @"resume";
        }else{
            self.pauseButtonLabel.text = @"pause";
        }
    }
}

-(void)handleMenuButtonTap{
    [self goMenu];
}

-(void)handleRestartButtonTap{
    if(self.gameState == GAMEOVER){
        SKEmitterNode *explosion = [self newExplosionEmitter];
        explosion.position = self.endGameBoss.position;
        [self addChild:explosion];
        [explosion runAction:[SKAction sequence:@[
                                                  [SKAction waitForDuration:0.25],
                                                  [SKAction runBlock:^{
            explosion.particleBirthRate = 0;
        }],
                                                  [SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange],
                                                  [SKAction removeFromParent],
                                                  ]] completion:^{
            [self restartGame];
        }];
        self.endGameBoss.hidden = YES;
    }
}

-(void)handlePlayerShootButtonTap{
    if(!self.gameState == GAMEOVER && !respawning && !self.paused){
        [self.player fireMissle];
    }
}

-(void)handlePlayerTap:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:gesture.view];
    location = [self convertPointFromView:location];
    SKNode *node = [self nodeAtPoint:location];
    if([node isEqual:self.pauseButton]){
        [self handlePauseButtonTap];
    }else if([node isEqual:self.menuButton]){
        [self handleMenuButtonTap];
    }else if([node isEqual:self.restartButton]){
        [self handleRestartButtonTap];
    }else if([node isEqual:self.playerShootButton]){
        [self handlePlayerShootButtonTap];
    }
}

CGFloat APADistanceBetweenPoints(CGPoint first, CGPoint second) {
    return hypotf(second.x - first.x, second.y - first.y);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(self.gameState == GAMEOVER || respawning || self.paused){
        return;
    }
    fireFrequencyCounter++;
    if(fireFrequencyCounter == self.invaderFireFrequency){
        for(int x=0;x<numInvadersFiring;x++){
            int firingInvader = arc4random() % (self.invaders.count - 0);
//            int firingInvader = rand() % (self.invaders.count - 0) + 0;
            MCHInvader *invader = (MCHInvader *)[self.invaders objectAtIndex:firingInvader];
            [invader fireMissle];
        }
        fireFrequencyCounter = 0;
    }
}

- (SKEmitterNode*) newExplosionEmitter{
    NSString *invaderExplosionPath = [[NSBundle mainBundle] pathForResource:@"InvaderExplosion" ofType:@"sks"];
    SKEmitterNode *invaderExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:invaderExplosionPath];
    return invaderExplosion;
}
- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKNode *node = contact.bodyA.node;
    SKNode *nodeb = contact.bodyB.node;
    if([node isKindOfClass:[MCHMissle class]] || [nodeb isKindOfClass:[MCHMissle class]]){
        
        if([node isKindOfClass:[MCHMissle class]] && [nodeb isKindOfClass:[MCHMissle class]]){
            NSLog(@"------------->>>>>>MISSLE to MISSLE hit!!!!!");
            [node removeFromParent];
            [nodeb removeFromParent];
            MCHMissle *missle1 = (MCHMissle *)node;
            MCHMissle *missle2 = (MCHMissle *)nodeb;
            [self.activeMissles removeObject:missle1];
            [self.activeMissles removeObject:missle2];
            return;
        }
        
        BOOL playerHit = NO;
        //test if one of these is a shield
        if([node isKindOfClass:[MCHShield class]] || [nodeb isKindOfClass:[MCHShield class]]){
            NSLog(@"shield found in a missle collision");
            [self handleShieldMissleHitWithNode:node andNodeB:nodeb];
            return;
        }
        MCHInvader *invader;
        MCHMissle *missle;
        if([nodeb isKindOfClass:[MCHInvader class]]){
            invader = (MCHInvader *)nodeb;
            missle = (MCHMissle *)node;
        }else if([node isKindOfClass:[MCHInvader class]]){
            invader = (MCHInvader *)node;            
            missle = (MCHMissle *)nodeb;
        }else if([node isKindOfClass:[MCHPlayer class]] || [nodeb isKindOfClass:[MCHPlayer class]]){
            playerHit = YES;
        }
        if(missle.explodedInvader){
            NSLog(@">>>>>>>>>>>>>>>>double hit detected!");
            //we don't want a single missle to take out 2 invaders
            return;
        }
        SKEmitterNode *explosion = [self newExplosionEmitter];
        explosion.position = node.position;
        [self addChild:explosion];
        [explosion runAction:[SKAction sequence:@[
                                                  [SKAction waitForDuration:0.25],
                                                  [SKAction runBlock:^{
            explosion.particleBirthRate = 0;
        }],
                                                  [SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange],
                                                  [SKAction removeFromParent],
                                                  ]]];
        [node removeFromParent];
        [nodeb removeFromParent];
        missle.explodedInvader = YES;
        [self.activeMissles removeObject:missle];
        score += invader.value;
        [self.invaders removeObject:invader];
        [self updateScoreDisplay];
        //MCH - for now this is cheesy but it gets the job done - it's a game over condition detector
        if ([self.invaders count] < 1) {
            [self respawnLevel];
        }
        if(playerHit){
            [self respawnPlayer];
        }
    }else if([node isKindOfClass:[MCHPlayer class]] || [nodeb isKindOfClass:[MCHPlayer class]]){
        NSLog(@"player in collision...");
        MCHPlayer *player;
        MCHInvader *invader;
        MCHMissle *missle;
        if([nodeb isKindOfClass:[MCHPlayer class]]){
            player = (MCHPlayer *)nodeb;
            if([node isKindOfClass:[MCHInvader class]]){
                invader = (MCHInvader *)node;
            }else if([node isKindOfClass:[MCHMissle class]]){
                missle = (MCHMissle *)node;                
            }
        }else if([node isKindOfClass:[MCHPlayer class]]){
            player = (MCHPlayer *)node;
            if([nodeb isKindOfClass:[MCHInvader class]]){
                invader = (MCHInvader *)nodeb;
            }else if([nodeb isKindOfClass:[MCHMissle class]]){
                missle = (MCHMissle *)nodeb;
            }
        }
        if(player && invader){
            [self gameOver];
        }else if(player && missle){
            //do a ship kill and reset for player or game over if player ship count is 0
            [self respawnPlayer];
        }
    }else if([node isKindOfClass:[MCHShield class]] || [nodeb isKindOfClass:[MCHShield class]]){
        NSLog(@"shield in collision...");
        [self handleShieldMissleHitWithNode:node andNodeB:nodeb];
    }
}

-(void)handleShieldMissleHitWithNode:(SKNode *)node andNodeB:(SKNode *)nodeb{
    MCHMissle *missle;
    MCHShield *shield;
    if([nodeb isKindOfClass:[MCHMissle class]]){
        missle = (MCHMissle *)nodeb;
        shield = (MCHShield *)node;
    }else if([node isKindOfClass:[MCHMissle class]]){
        missle = (MCHMissle *)node;
        shield = (MCHShield *)nodeb;
    }
    if (missle) {
        if(missle.explodedInvader){
            NSLog(@">>>>>>>>>>>>>>>>missle double hit detected!");
            //we don't want a single missle to take out 2 invaders
            return;
        }
        missle.explodedInvader = YES;
        [self.activeMissles removeObject:missle];
        [missle gameOver];
    }
    if(shield){
        SKEmitterNode *explosion = [self newExplosionEmitter];
        explosion.position = shield.position;
        [self addChild:explosion];
        [explosion runAction:[SKAction sequence:@[
                                                  [SKAction waitForDuration:0.25],
                                                  [SKAction runBlock:^{
            explosion.particleBirthRate = 0;
        }],
                                                  [SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange],
                                                  [SKAction removeFromParent],
                                                  ]]];
        [self.shields removeObject:shield];
        [shield gameOver];
    }
}

-(void)gameOver{
    self.gameState = GAMEOVER;
    
    for(MCHInvader *invader in self.invaders){
        [invader gameOver];
    }
    [self.invaders removeAllObjects];
    for(MCHMissle *missle in self.activeMissles){
        [missle gameOver];
    }
    [self.activeMissles removeAllObjects];
    for(MCHShield *shield in self.shields){
        [shield gameOver];
    }
    [self.shields removeAllObjects];
    [self.player gameOver];

    if(!self.endGameBoss){
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        SKTexture *endBossTexture = [atlas textureNamed:@"robfordendgame-sized.png"];
        self.endGameBoss = [[SKSpriteNode alloc] initWithTexture:endBossTexture color:[UIColor whiteColor] size:CGSizeMake(257/2,300)];
        self.endGameBoss.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:self.endGameBoss];
    }else{
        self.endGameBoss.hidden = NO;
    }
    
    if(!self.gameOverDisplay){
        self.gameOverDisplay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.gameOverDisplay.text = @"GAME OVER";
        self.gameOverDisplay.fontSize = 38;
        self.gameOverDisplay.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:self.gameOverDisplay];
    }else{
        self.gameOverDisplay.hidden = NO;
    }

    if(!self.restartButtonLabel){
        self.restartButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.restartButtonLabel.text = @"touch here to replay";
        self.restartButtonLabel.fontSize = 24;
        self.restartButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),self.gameOverDisplay.position.y - self.gameOverDisplay.frame.size.height - 20);
        [self addChild:self.restartButtonLabel];
        
        self.restartButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.restartButtonLabel.frame.size.width*1.2, self.restartButtonLabel.frame.size.height*1.2 + self.gameOverDisplay.frame.size.height + 60)];
        self.restartButton.position = CGPointMake(self.restartButtonLabel.position.x, self.gameOverDisplay.position.y);
        [self addChild:self.restartButton];
    }else{
        self.restartButtonLabel.hidden = NO;
        self.restartButton.hidden = NO;
    }
}

-(void)stopAllInvadersExcept:(MCHInvader *)invader{
    for(MCHInvader *nextInvader in self.invaders){
        if (nextInvader != invader) {
            [nextInvader gameOver];
        }
    }    
}

-(CGPoint)getPlayerPosition{
    return self.player.position;
}

-(void)goMenu{
    SKScene *introScene = [[MCHMyScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:introScene transition:doors];
    level = 1;
    score = 0;
    numPlayers = 3;
}

@end
