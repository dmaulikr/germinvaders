//
//  MCHPlayerNode.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-28.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHPlayer.h"
#import "MCHMissle.h"
#import "MCHGameplayScene.h"

@implementation MCHPlayer

- (id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size{
    self = [super initWithTexture:texture color:color size:size];
    if(self){
        self.fireRate = 0.25;
        self.readyToFire = YES;
    }
    return self;
}

-(void)gameOver{
    [self removeAllActions];
    [self removeFromParent];
}

-(void)fireMissle{
    NSLog(@"firing missle...");
    if(!self.readyToFire){
        NSLog(@"not firing because we have a fire rate.");
        return;
    }
    MCHMissle *missle = [MCHMissle spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(2,6)];
    missle.direction = CGPointMake(0,1);
    missle.position = CGPointMake(self.position.x-10, self.position.y);// self.position; //missleCategory
    missle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missle.size];
    missle.physicsBody.categoryBitMask = missleCategory;
    missle.physicsBody.collisionBitMask = invadeCategory | missleCategory;
    missle.physicsBody.contactTestBitMask = invadeCategory | missleCategory;
    self.readyToFire = NO;
    [self.parentScene.activeMissles addObject:missle];
    [self.parent addChild:missle];
    
    SKAction *moveMissle = [SKAction moveByX:0.0 y:self.parentScene.size.height*missle.direction.y duration:2.5];
    SKAction *fireMissleSequence = [SKAction sequence:@[moveMissle,[SKAction removeFromParent]]];
    [missle runAction:fireMissleSequence withKey:@"firePlayerMissle"];
    SKAction *wait = [SKAction waitForDuration:self.fireRate];
    SKAction *resetActivePlayerMissle = [SKAction runBlock:^{
        self.readyToFire = YES;
    }];
    SKAction *fireRateControlSequence = [SKAction sequence:@[wait,resetActivePlayerMissle]];
    [self.parent runAction:(SKAction *)fireRateControlSequence];
}


@end
