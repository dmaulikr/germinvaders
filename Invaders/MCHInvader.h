//
//  MCHInvader.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-27.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MCHInvader : SKSpriteNode

@property float speed;
@property int direction;
@property int range;
@property int value;
@property (strong,atomic) NSArray *textureArray;

- (id)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size;

-(void)moveDown;
-(void)moveLeftRight;
-(void)gameOver;
-(void)startRepeatingMoveAnimation;

@end
