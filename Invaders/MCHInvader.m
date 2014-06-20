//
//  MCHInvader.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-27.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHInvader.h"
#import "MCHGameplayScene.h"

@implementation MCHInvader

- (id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size{
    self = [super initWithTexture:texture color:color size:size];
    if(self){
        self.readyToFire = YES;
        self.fireRate = 2.5;
        self.maxSpeed = 6.5;
        self.missleColor = color;
        //Update this method so that maybe we pass in values to fully initialize the invader - or if not using delete.
    }
    return self;
}

-(void)moveDown{
//    int moveValue = -self.size.height;
    int moveValue = -self.size.height/3;
    
    SKAction *moveAlien = [SKAction moveByX:0.0 y:moveValue duration:fabs(moveValue)/self.speed];
    [self runAction:moveAlien completion:^{
        self.speed = self.speed + 0.2;
        if(self.speed > self.maxSpeed){
            self.speed = self.maxSpeed;
        }
        MCHGameplayScene *gameScene = (MCHGameplayScene *)self.parent;
        float shieldTop = SHIELD_START_Y_POS;
        shieldTop += ((SKSpriteNode *)[gameScene.shields firstObject]).frame.size.height * 2;
        if(self.position.y < shieldTop){
            if(!gameScene.anInvaderChasingPlayer){
                gameScene.anInvaderChasingPlayer = YES;
                self.amChasingPlayer = YES;
//                [gameScene stopAllInvadersExcept:self];
                int downValue = gameScene.player.position.y - self.position.y;
                SKAction *moveDown = [SKAction moveByX:0.0 y:downValue duration:fabs(downValue)/self.speed];
                [self runAction:moveDown completion:^{
                    //the player may have moved away so keep chasing.
                    [self moveToPlayer];
                }];
            }else{
                [self moveLeftRight];
            }
        }else{
            [self moveLeftRight];
        }
    }];
}

-(void)moveLeftRight{
    float moveValue;
    if (self.direction == 0) {
        moveValue = self.range;
        self.direction = -1;
    }else{
        moveValue = self.range * (self.direction*2);
        self.direction = -self.direction;
    }
    SKAction *moveInvader = [SKAction moveByX:moveValue y:0.0 duration:fabs(moveValue)/self.speed];
    [self runAction:moveInvader completion:^{
        float shieldTop = SHIELD_START_Y_POS;
        if(self.position.y < shieldTop){
            [self moveLeftRight];
        }else{
            [self moveDown];
        }
    }];
}

-(void)runMoveAnimation{
    [self runAction:[SKAction sequence:@[
                                         [SKAction animateWithTextures:self.textureArray timePerFrame:self.speed/[self.textureArray count]],
                                         [SKAction runBlock:^{
        [self runMoveAnimation];
    }]]] completion:^{
        NSLog(@"moving & animating invader completion block executed...");
    }];

}

-(void)moveToPlayer{
    MCHGameplayScene *gameScene = (MCHGameplayScene *)self.parent;
    CGPoint playerPos = [gameScene getPlayerPosition];
    int distance;
    if (playerPos.x > self.position.x) {
        distance = playerPos.x - self.position.x;
    }else{
        distance = self.position.x - playerPos.x;
    }
    float moveDuration = distance / self.speed;
    
    SKAction *moveToPlayer = [SKAction moveTo:gameScene.player.position duration:moveDuration];
    [self runAction:moveToPlayer completion:^{
        //the player may have moved away so keep chasing.
        NSLog(@"moving invader to player completion block executed...");
        [self moveToPlayer];
    }];
    
}

-(void)fireMissle{
    if(!self.readyToFire){
        NSLog(@"not firing because we have a fire rate.");
        return;
    }
    MCHMissle *missle = [MCHMissle spriteNodeWithColor:self.missleColor size:CGSizeMake(2,6)];
    missle.direction = CGPointMake(0,-1);
    missle.position = self.position; //missleCategory
    missle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missle.size];
    missle.physicsBody.categoryBitMask = missleCategory;
    missle.physicsBody.collisionBitMask = playerCategory | missleCategory;
    missle.physicsBody.contactTestBitMask = playerCategory | missleCategory;
    self.readyToFire = NO;
    [self.parentScene.activeMissles addObject:missle];
    [self.parent addChild:missle];
    
    SKAction *moveMissle = [SKAction moveByX:0.0 y:self.parentScene.size.height*missle.direction.y duration:8];
    SKAction *fireMissleSequence = [SKAction sequence:@[moveMissle,[SKAction removeFromParent]]];
    [missle runAction:fireMissleSequence withKey:@"firePlayerMissle"];
    SKAction *wait = [SKAction waitForDuration:self.fireRate];
    SKAction *resetActiveInvaderMissle = [SKAction runBlock:^{
        self.readyToFire = YES;
    }];
    SKAction *fireRateControlSequence = [SKAction sequence:@[wait,resetActiveInvaderMissle]];
    [self.parent runAction:(SKAction *)fireRateControlSequence];
}

-(void)gameOver{
    [self removeAllActions];
    [self removeFromParent];
}

@end
