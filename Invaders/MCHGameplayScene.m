//
//  MCHGameplayScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHGameplayScene.h"
#import "MCHInvader.h"
#import "MCHPlayer.h"
#import "MCHMissle.h"
#import "math.h"

static const uint32_t invadeCategory =  0x1 << 0;
static const uint32_t playerCategory =  0x1 << 1;
static const uint32_t wallCategory =  0x1 << 2;
static const uint32_t missleCategory =  0x1 << 3;

@implementation MCHGameplayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        NSMutableArray *invaders = [NSMutableArray arrayWithCapacity:6*13];
        CGSize invaderSize = CGSizeMake(12, 12);
        int startY = self.size.height-25;
        int invaderGroupStartX = ((self.size.width-((13*12)+(12*5)))/2)+5;
        int invaderGroupFinishX = invaderGroupStartX + ((13*12)+(12*5));
        int invaderRange = self.size.width-4-invaderGroupFinishX;
        for (int i=0; i<6; i++) {
            int startX = invaderGroupStartX;
            NSLog(@"startX:%d",startX);
            for (int j=0; j<13; j++) {
                MCHInvader *invader = [MCHInvader spriteNodeWithColor:[UIColor whiteColor] size:invaderSize];
                invader.direction = 0;
                invader.speed = 2;
                invader.position = CGPointMake(startX, startY);
                invader.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:invader.size];
                invader.physicsBody.categoryBitMask = invadeCategory;
                invader.physicsBody.collisionBitMask = playerCategory;
                invader.range = invaderRange;
                [invaders addObject:invader];
                [self addChild:invader];
                startX = startX + 17;
                [invader moveLeftRight];
            }
            startY = startY - 17;
        }
        self.player = [MCHPlayer spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(24, 24)];
        self.player.direction = CGPointMake(0, 0);
        self.player.speed = 20;
        self.player.position = CGPointMake(self.size.width/2, 0+self.player.size.height);
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.collisionBitMask = invadeCategory;
        self.player.physicsBody.contactTestBitMask = wallCategory;
        
        SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, self.size.height)];
        leftWall.position = CGPointMake(leftWall.size.width/2, self.size.height/2);
        leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
        leftWall.physicsBody.categoryBitMask = wallCategory;
        leftWall.physicsBody.dynamic = NO;
        
        SKSpriteNode *rightWAll = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, self.size.height)];
        rightWAll.position = CGPointMake(self.size.width-rightWAll.size.width/2, self.size.height/2);
        rightWAll.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWAll.size];
        rightWAll.physicsBody.categoryBitMask = wallCategory;
        rightWAll.physicsBody.dynamic = NO;
        
        [self addChild:self.player];
        [self addChild:leftWall];
        [self addChild:rightWAll];
        
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
    if(self.activePlayerMissle != nil){
        NSLog(@"not firing because there's already an active missle");
        return;
    }
    MCHMissle *missle = [MCHMissle spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(2,6)];
    missle.direction = CGPointMake(0,1);
    missle.position = attackingSprite.position; //missleCategory
    missle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missle.size];
    missle.physicsBody.categoryBitMask = missleCategory;
    missle.physicsBody.collisionBitMask = invadeCategory;
    missle.physicsBody.contactTestBitMask = invadeCategory;
    self.activePlayerMissle = missle;
    [self addChild:missle];
    SKAction *moveMissle = [SKAction moveByX:0.0 y:self.size.height*missle.direction.y duration:2.5];
    SKAction *resetActivePlayerMissle = [SKAction runBlock:^{
        self.activePlayerMissle = nil;
    }];
    SKAction *fireMissleSequence = [SKAction sequence:@[moveMissle,resetActivePlayerMissle,[SKAction removeFromParent]]];
    [missle runAction:fireMissleSequence withKey:@"firePlayerMissle"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
    NSLog(@"contact detected!");
    SKNode *node = contact.bodyA.node;
    SKNode *nodeb = contact.bodyB.node;
    if([node isKindOfClass:[MCHMissle class]] || [nodeb isKindOfClass:[MCHMissle class]]){
        NSLog(@"missle hit!");
        if(self.activePlayerMissle == nil){
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
        self.activePlayerMissle = nil;
    }
}
@end
