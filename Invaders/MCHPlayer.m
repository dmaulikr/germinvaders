//
//  MCHPlayerNode.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-28.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHPlayer.h"

@implementation MCHPlayer

- (id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size{
    self = [super initWithTexture:texture color:color size:size];
    if(self){
        //Update this method so that maybe we pass in values to fully initialize the player - or if not using delete.
    }
    return self;
}

-(void)gameOver{
    [self removeAllActions];
}

@end
