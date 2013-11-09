//
//  MCHPlayerNode.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-28.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MCHGameplayScene;

@interface MCHPlayer : SKSpriteNode

@property float speed;
@property CGPoint direction;
@property float fireRate;
@property BOOL readyToFire;
@property (strong,atomic) MCHGameplayScene *parentScene;

- (id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size;

-(void)gameOver;
-(void)fireMissle;

@end
