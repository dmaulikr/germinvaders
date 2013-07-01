//
//  MCHMissle.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-28.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MCHMissle : SKSpriteNode

@property float speed;
@property CGPoint direction;
@property BOOL explodedInvader;

-(void)gameOver;

@end
