//
//  MCHGameplayScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHGameplayScene.h"
static const uint32_t invadeCategory =  0x1 << 0;
static const uint32_t shipCategory =  0x1 << 1;
static const uint32_t wallCategory =  0x1 << 2;
//static const uint32_t planetCategory =  0x1 << 3;

@implementation MCHGameplayScene

int direction = 5;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.invader = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(25, 25)];
        self.invader.position = CGPointMake(50, self.size.height-50);
        self.invader.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.invader.size];
        self.invader.physicsBody.categoryBitMask = invadeCategory;
        
        self.invader.physicsBody.collisionBitMask = shipCategory;
        self.invader.physicsBody.contactTestBitMask = wallCategory;
        
        SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(25, self.size.height)];
        leftWall.position = CGPointMake(leftWall.size.width/2, self.size.height/2);
        leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
        leftWall.physicsBody.categoryBitMask = wallCategory;
        
        SKSpriteNode *rightWAll = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(25, self.size.height)];
        rightWAll.position = CGPointMake(self.size.width-leftWall.size.width/2, self.size.height/2);
        rightWAll.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
        rightWAll.physicsBody.categoryBitMask = wallCategory;
        
        
        [self addChild:self.invader];
        [self addChild:leftWall];
        [self addChild:rightWAll];
        
        self.physicsWorld.gravity = CGPointMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    self.invader.position = CGPointMake(self.invader.position.x+direction, self.invader.position.y);
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    if(direction > 0){
        direction = -5;
    }else{
        direction = 5;
    }
    self.invader.position = CGPointMake(self.invader.position.x, self.invader.position.y - self.invader.size.height);
    NSLog(@"we hit the wall");
}
@end
