//
//  MCHInvader.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-27.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MCHGameplayScene;

@interface MCHInvader : SKSpriteNode

@property (nonatomic) float speed;
@property float maxSpeed;
@property int direction;
@property int range;
@property int value;
@property (strong,atomic) NSArray *textureArray;
@property float fireRate;
@property BOOL readyToFire;
@property (strong,atomic) MCHGameplayScene *parentScene;

- (id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size;

-(void)moveDown;
-(void)moveLeftRight;
-(void)gameOver;
-(void)runMoveAnimation;
-(void)fireMissle;

@end
