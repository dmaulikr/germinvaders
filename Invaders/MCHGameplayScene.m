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
int numInvadersHit;
int numInvadersFiring;
int level;
int fireFrequencyCounter;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.invaderFireFrequency = 60;
        fireFrequencyCounter = 0;
        level = 1;
        numInvadersFiring = level * 1;
        self.gameState = GAMEON;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.invaders = [NSMutableArray arrayWithCapacity:6*13];
        self.activeMissles = [[NSMutableArray alloc] init];
        
        CGSize invaderSize = CGSizeMake(24, 24);
        int invaderSpacing = 7;
        numInvaderAcross = 6;
        
        int startY = self.size.height-50;
        int invaderGroupStartX = ((self.size.width-((numInvaderAcross*invaderSize.width)+((numInvaderAcross-1)*invaderSpacing)))/2)+invaderSize.width/2;
        int invaderGroupFinishX = invaderGroupStartX + ((numInvaderAcross*invaderSize.width)+((numInvaderAcross-1)*invaderSpacing));
        int invaderRange = self.size.width-4-invaderGroupFinishX;
        numInvaderRows = 5;
        numInvadersHit = 0;
        
        numInvadersPerBoard = numInvaderAcross * numInvaderRows;
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
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
                invader.speed = 6;
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
            startY = startY - invaderSize.height + invaderSpacing;
        }
        SKTexture *playerTexture = [atlas textureNamed:@"invader-player.png"];
        self.player = [[MCHPlayer alloc] initWithTexture:playerTexture color:[UIColor whiteColor] size:CGSizeMake(40,24)];
        self.player.parentScene = self;
        self.player.direction = CGPointMake(0, 0);
        self.player.speed = 20;
        self.player.position = CGPointMake(self.size.width/2, 0+self.player.size.height);
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.collisionBitMask = invadeCategory;
        self.player.physicsBody.contactTestBitMask = invadeCategory;
        
        self.scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.scoreDisplay.text = [NSString stringWithFormat:@"Score:%d",self.player.score];;
        self.scoreDisplay.fontSize = 18;
        self.scoreDisplay.position = CGPointMake(CGRectGetMidX(self.frame),self.size.height-35);
        
        [self addChild:self.player];
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
    int shieldOrigX = 40;
    for (int i=0; i<numShields; i++){
        int shieldStartX = shieldOrigX;
        //I'm going to start with a simple 8 x 8 grid of shield particles that will make up 1 shield
        for(int x=0;x<6;x++){
            int shieldStartY = 70;
            for(int y=0;y<6;y++){
                MCHShield *shieldPiece = [MCHShield spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
                shieldPiece.position = CGPointMake(shieldStartX, shieldStartY);
                shieldPiece.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:shieldPiece.size];
                shieldPiece.physicsBody.categoryBitMask = shieldCategory;
                shieldPiece.physicsBody.collisionBitMask = missleCategory;
                shieldPiece.physicsBody.contactTestBitMask = missleCategory;
                [self addChild:shieldPiece];
                shieldStartY += (4+1);
            }
            shieldStartX += (4+2);
        }
        shieldOrigX += 100;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.gameState == GAMEOVER){
        [self goMenu];
        return;
    }
    
    UITouch *touch = (UITouch *)[[event.allTouches objectEnumerator] nextObject];
    NSLog(@"touch.x:%f, touch.y:%f",[touch locationInView:self.view].x,[touch locationInView:self.view].y);
    NSLog(@"player.x:%f, player.y:%f",self.player.position.x,self.size.height-self.player.position.y);
    float playerX = [self convertPointToView:self.player.position].x;
    float touchX = [touch locationInView:self.view].x;
    float distance;
    
    CGRect playerFrame = CGRectMake(self.player.position.x-self.player.size.width/2, (self.size.height-self.player.position.y)-self.player.size.height/2, self.player.size.width, self.player.size.height);
    if (CGRectContainsPoint(playerFrame, [touch locationInView:self.view])) {
        //fire missle
        NSLog(@"we touched the player.");
        [self.player fireMissle];
    }else if(playerX > touchX){
        distance = playerX - touchX;
        float moveDuration = distance / self.player.speed;
        NSLog(@"moveDuration is:%f and distance is:%f",moveDuration,distance);
        SKAction *moveToTouch = [SKAction moveByX: -(distance) y: 0.0 duration: moveDuration];
        [self.player runAction:moveToTouch withKey:@"movePlayerToTouch"];
    }else{
        distance = touchX - playerX;
        float moveDuration = distance / self.player.speed;
        NSLog(@"moveDuration is:%f and distance is:%f",moveDuration,distance);
        SKAction *moveToTouch = [SKAction moveByX: distance y: 0.0 duration: moveDuration];
        [self.player runAction:moveToTouch withKey:@"movePlayerToTouch"];
    }
    
//    float distance = ([self convertPointToView:self.player.position] + [touch locationInView:self.view].x)/2;
}

CGFloat APADistanceBetweenPoints(CGPoint first, CGPoint second) {
    return hypotf(second.x - first.x, second.y - first.y);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(self.gameState == GAMEOVER){
        return;
    }
    fireFrequencyCounter++;
    if(fireFrequencyCounter == self.invaderFireFrequency){
        for(int x=0;x<=numInvadersFiring;x++){
            int firingInvader = rand() % (self.invaders.count - 0) + 0;
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
        self.player.score = self.player.score + invader.value;
        self.scoreDisplay.text = [NSString stringWithFormat:@"Score: %d",self.player.score];
        //MCH - for now this is cheesy but it gets the job done - it's a game over condition detector
        numInvadersHit++;
        if (numInvadersHit == numInvadersPerBoard || playerHit) {
            [self gameOver];
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
        }
    }else if([node isKindOfClass:[MCHShield class]] || [nodeb isKindOfClass:[MCHShield class]]){
        NSLog(@"shield in collision...");
        [self handleShieldMissleHitWithNode:node andNodeB:nodeb];
    }
}

-(void)handleShieldMissleHitWithNode:(SKNode *)node andNodeB:(SKNode *)nodeb{
    MCHMissle *missle;
    if([nodeb isKindOfClass:[MCHShield class]]){
        missle = (MCHMissle *)node;
    }else if([node isKindOfClass:[MCHShield class]]){
        missle = (MCHMissle *)nodeb;
    }
    if(missle.explodedInvader){
        NSLog(@">>>>>>>>>>>>>>>>missle double hit detected!");
        //we don't want a single missle to take out 2 invaders
        return;
    }
    [node removeFromParent];
    [nodeb removeFromParent];
    missle.explodedInvader = YES;
    [self.activeMissles removeObject:missle];
}

-(void)gameOver{
    self.gameState = GAMEOVER;
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myLabel.text = @"GAME OVER";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    for(MCHInvader *invader in self.invaders){
        [invader gameOver];
    }
    for(MCHMissle *missle in self.activeMissles){
        [missle gameOver];
    }
    [self.player gameOver];
    
    [self addChild:myLabel];
    
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
}

@end
