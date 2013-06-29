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

int direction = 5;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.activeMissles = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *invaderRows = [NSMutableArray arrayWithCapacity:6];
        int startY = self.size.height-25;
        for (int i=0; i<6; i++) {
            int startX = 24+36;
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:13];
            for (int j=0; j<13; j++) {
                MCHInvader *invader = [MCHInvader spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(12, 12)];
                invader.direction = CGPointMake(1, 0);
                invader.speed = 2;
                invader.position = CGPointMake(startX, startY);
                invader.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:invader.size];
                invader.physicsBody.categoryBitMask = invadeCategory;
                invader.physicsBody.collisionBitMask = playerCategory;
                invader.physicsBody.contactTestBitMask = wallCategory;
                invader.rowNum = i;
                startX = startX + 17;
                [self addChild:invader];
                [row addObject:invader];
            }
            startY = startY - 17;
            [invaderRows addObject:row];
        }
        self.invaderRows = [NSArray arrayWithArray:invaderRows];
        
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
    MCHMissle *missle = [MCHMissle spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(2,6)];
    missle.direction = CGPointMake(0,1);
    missle.speed = 12;
    missle.position = attackingSprite.position; //missleCategory
    missle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    missle.physicsBody.categoryBitMask = missleCategory;
    missle.physicsBody.collisionBitMask = invadeCategory;
    missle.physicsBody.contactTestBitMask = invadeCategory;
    [self addChild:missle];
    SKAction *moveMissle = [SKAction moveByX:0.0 y:self.size.height*missle.direction.y duration: missle.speed];
    [missle runAction:moveMissle withKey:@"firePlayerMissle"];
//    [self.activeMissles setObject:@"missle" forKey:missle];
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
    for (int i=0; i<6; i++) {
        NSArray *row = (NSArray *)[self.invaderRows objectAtIndex:i];
        for (int j=0; j<13; j++) {
            MCHInvader *invader = (MCHInvader *)[row objectAtIndex:j];
            int movement = (int)roundf(invader.speed*invader.direction.x);
            invader.position = CGPointMake(invader.position.x+movement,invader.position.y);
        }
    }
    
//    for(MCHMissle *missle in self.activeMissles){
//        float moveDuration = distance / missle.speed;
//        SKAction *moveMissle = [SKAction moveByX:0.0 y: self.size.height*missle.direction.y duration: 2.5];
//    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    NSLog(@"we hit the wall");
    SKNode *node = contact.bodyA.node;
    SKNode *nodeb = contact.bodyB.node;
    if ([node isKindOfClass:[MCHInvader class]] && ![nodeb isKindOfClass:[MCHMissle class]]) {
        MCHInvader *invaderCollider = (MCHInvader *)node;
        NSArray *row = (NSArray *)[self.invaderRows objectAtIndex:invaderCollider.rowNum];
        for (int j=0; j<13; j++) {
            MCHInvader *invader = (MCHInvader *)[row objectAtIndex:j];
            int movement = (int)roundf(invader.speed*invader.direction.x);
            invader.position = CGPointMake(invader.position.x+movement,invader.position.y);
            invader.position = CGPointMake(invader.position.x, invader.position.y - invader.size.height);
            invader.direction = CGPointMake(-(invader.direction.x),invader.direction.y);
        }
    } else if([node isKindOfClass:[MCHMissle class]] || [nodeb isKindOfClass:[MCHMissle class]]){
//        [self.activeMissles removeObjectForKey:node];
//        [self.activeMissles removeObjectForKey:nodeb];
        [node removeFromParent];
        [nodeb removeFromParent];
    }
}
@end
