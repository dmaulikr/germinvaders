//
//  MCHGameplayScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHGameplayScene.h"

@implementation MCHGameplayScene

int direction = 5;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.invader = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(25, 25)];
        self.invader.position = CGPointMake(50, self.size.height-50);
        [self addChild:self.invader];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    self.invader.position = CGPointMake(self.invader.position.x+direction, self.invader.position.y);
    if(direction > 0){
        if (self.invader.position.x > self.size.width-50) {
            direction = -5;
            self.invader.position = CGPointMake(self.invader.position.x, self.invader.position.y - self.invader.size.height);
        }
    }else{
        if (self.invader.position.x < 50) {
            direction = 5;
            self.invader.position = CGPointMake(self.invader.position.x, self.invader.position.y - self.invader.size.height);
        }
    }
    
//    NSLog(@"invader.x=%f",self.invader.position.x);
}

@end
