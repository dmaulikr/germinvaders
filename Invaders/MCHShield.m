//
//  MCHShield.m
//  Invaders
//
//  Created by Marc Henderson on 2013-08-10.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHShield.h"

@implementation MCHShield

-(void)gameOver{
    [self removeAllActions];
    [self removeFromParent];
}

@end
