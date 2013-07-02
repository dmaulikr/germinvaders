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

-(void)moveDown{
    int moveValue = -self.size.height;
    
    SKAction *moveAlien = [SKAction moveByX:0.0 y:moveValue duration:fabs(moveValue)/self.speed];
    [self runAction:moveAlien completion:^{
        self.speed = self.speed + 0.2;
        if(self.position.y < 48){
            MCHGameplayScene *gameScene = (MCHGameplayScene *)self.parent;
            if(!gameScene.anInvaderChasingPlayer){
                gameScene.anInvaderChasingPlayer = YES;
                [gameScene stopAllInvadersExcept:self];
                int downValue = -self.size.height;
                SKAction *moveDown = [SKAction moveByX:0.0 y:downValue duration:fabs(downValue)/self.speed];
                [self runAction:moveDown completion:^{
                    //the player may have moved away so keep chasing.
                    [self moveToPlayer];
                }];
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
//    NSLog(@"invader moveValue:%f",moveValue);
    SKAction *moveAlien = [SKAction moveByX:moveValue y:0.0 duration:fabs(moveValue)/self.speed];
    [self runAction:moveAlien completion:^{
        [self moveDown];
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
    
    SKAction *moveToPlayer = [SKAction moveToX:playerPos.x duration:moveDuration];
    [self runAction:moveToPlayer completion:^{
        //the player may have moved away so keep chasing.
        [self moveToPlayer];
    }];
    
}

-(void)gameOver{
    [self removeAllActions];
}

@end
