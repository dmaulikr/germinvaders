//
//  MCHInvader.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-27.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHInvader.h"

@implementation MCHInvader

-(void)moveDown{
    int moveValue = -self.size.height;
    
    SKAction *moveAlien = [SKAction moveByX:0.0 y:moveValue duration:fabs(moveValue)/self.speed];
    [self runAction:moveAlien completion:^{
        self.speed = self.speed + 0.2;
        [self moveLeftRight];
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

@end
