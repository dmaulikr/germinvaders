//
//  MCHGameplayScene.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MCHPlayer.h"

@interface MCHGameplayScene : SKScene <SKPhysicsContactDelegate>
@property (strong,atomic) NSArray *invaderRows;
@property (strong,atomic) MCHPlayer *player;
@end
