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
#import "math.h"

static const uint32_t invadeCategory =  0x1 << 0;
static const uint32_t playerCategory =  0x1 << 1;
//static const uint32_t wallCategory =  0x1 << 2;
static const uint32_t missleCategory =  0x1 << 3;

#define GAMEON 0
#define GAMEOVER 1

@implementation MCHGameplayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.gameState = GAMEON;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.invaders = [NSMutableArray arrayWithCapacity:6*13];
        self.activeMissles = [[NSMutableArray alloc] init];
        
        CGSize invaderSize = CGSizeMake(24, 24);
        int invaderSpacing = 5;
        int numInvadersAcross = 8;
        
        int startY = self.size.height-50;
        int invaderGroupStartX = ((self.size.width-((numInvadersAcross*invaderSize.width)+((numInvadersAcross-1)*invaderSpacing)))/2)+invaderSize.width/2;
        int invaderGroupFinishX = invaderGroupStartX + ((numInvadersAcross*invaderSize.width)+((numInvadersAcross-1)*invaderSpacing));
        int invaderRange = self.size.width-4-invaderGroupFinishX;
        int numInvaderRows = 7;
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        SKTexture *f1 = [atlas textureNamed:@"invader1.png"];
        SKTexture *f2 = [atlas textureNamed:@"invader2.png"];
        NSArray *invaderWalkArray = @[f1,f2];
        
        for (int i=0; i<numInvaderRows-1; i++) {
            int startX = invaderGroupStartX;
            NSLog(@"startX:%d",startX);
            for (int j=0; j<numInvadersAcross; j++) {
                MCHInvader *invader = [[MCHInvader alloc] initWithTexture:[invaderWalkArray objectAtIndex:0] color:[UIColor whiteColor] size:invaderSize];
                invader.direction = 0;
                invader.speed = 6;
                invader.textureArray = invaderWalkArray;
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
                [invader startRepeatingMoveAnimation];
                [invader moveLeftRight];
            }
            startY = startY - invaderSize.height + invaderSpacing;
        }
        self.player = [MCHPlayer spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(24, 24)];
        self.player.direction = CGPointMake(0, 0);
        self.player.speed = 20;
        self.player.position = CGPointMake(self.size.width/2, 0+self.player.size.height);
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.collisionBitMask = invadeCategory;
        self.player.physicsBody.contactTestBitMask = invadeCategory;
        self.player.fireRate = 0.25;
        self.player.readyToFire = YES;
        
        self.scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.scoreDisplay.text = [NSString stringWithFormat:@"Score:%d",self.player.score];;
        self.scoreDisplay.fontSize = 18;
        self.scoreDisplay.position = CGPointMake(CGRectGetMidX(self.frame),self.size.height-35);
        
//        SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, self.size.height)];
//        leftWall.position = CGPointMake(leftWall.size.width/2, self.size.height/2);
//        leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
//        leftWall.physicsBody.categoryBitMask = wallCategory;
//        leftWall.physicsBody.dynamic = NO;
//        
//        SKSpriteNode *rightWAll = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, self.size.height)];
//        rightWAll.position = CGPointMake(self.size.width-rightWAll.size.width/2, self.size.height/2);
//        rightWAll.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWAll.size];
//        rightWAll.physicsBody.categoryBitMask = wallCategory;
//        rightWAll.physicsBody.dynamic = NO;
        
        [self addChild:self.player];
        [self addChild:self.scoreDisplay];
//        [self addChild:leftWall];
//        [self addChild:rightWAll];
        
        self.physicsWorld.gravity = CGPointMake(0,0);
        self.physicsWorld.contactDelegate = self;
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.collisionBitMask = invadeCategory;
    }
    return self;
}

-(void)fireMissle:(MCHPlayer *)attackingSprite{
    NSLog(@"firing missle...");
    if(!self.player.readyToFire){
        NSLog(@"not firing because we have a fire rate.");
        return;
    }
    MCHMissle *missle = [MCHMissle spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(2,6)];
    missle.direction = CGPointMake(0,1);
    missle.position = attackingSprite.position; //missleCategory
    missle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missle.size];
    missle.physicsBody.categoryBitMask = missleCategory;
    missle.physicsBody.collisionBitMask = invadeCategory;
    missle.physicsBody.contactTestBitMask = invadeCategory;
    self.player.readyToFire = NO;
    [self.activeMissles addObject:missle];
    [self addChild:missle];
    
    SKAction *moveMissle = [SKAction moveByX:0.0 y:self.size.height*missle.direction.y duration:2.5];
    SKAction *fireMissleSequence = [SKAction sequence:@[moveMissle,[SKAction removeFromParent]]];
    [missle runAction:fireMissleSequence withKey:@"firePlayerMissle"];
    SKAction *wait = [SKAction waitForDuration:self.player.fireRate];
    SKAction *resetActivePlayerMissle = [SKAction runBlock:^{
        self.player.readyToFire = YES;
    }];
    SKAction *fireRateControlSequence = [SKAction sequence:@[wait,resetActivePlayerMissle]];
    [self runAction:(SKAction *)fireRateControlSequence];
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
        [self fireMissle:self.player];
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
        MCHInvader *invader;
        MCHMissle *missle;
        if([nodeb isKindOfClass:[MCHInvader class]]){
            invader = (MCHInvader *)nodeb;
            missle = (MCHMissle *)node;
        }else if([node isKindOfClass:[MCHInvader class]]){
            invader = (MCHInvader *)node;            
            missle = (MCHMissle *)nodeb;
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
        self.scoreDisplay.text = [NSString stringWithFormat:@"Score: %d",self.player.score];;
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
    }
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
