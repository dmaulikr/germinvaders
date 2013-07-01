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
    SKAction *moveAlien = [SKAction moveByX:0.0 y:-self.size.height duration:0.75];
    [self runAction:moveAlien completion:^{
        [self moveLeftRight];
    }];
}

-(void)moveLeftRight{
    int dur = 2.5;
    float moveValue;
    if (self.direction == 0) {
        moveValue = self.range;
        self.direction = -1;
    }else{
        moveValue = self.range * (self.direction*2);
        self.direction = -self.direction;
        dur = dur*2;
    }
    SKAction *moveAlien = [SKAction moveByX:moveValue y:0.0 duration:dur];
    [self runAction:moveAlien completion:^{
        [self moveDown];
    }];
}

@end
