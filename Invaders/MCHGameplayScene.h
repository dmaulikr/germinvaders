//
//  MCHGameplayScene.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MCHPlayer.h"
#import "MCHMissle.h"

@interface MCHGameplayScene : SKScene <SKPhysicsContactDelegate>
@property (strong,atomic) NSMutableArray *invaders;
@property (strong,atomic) MCHPlayer *player;
@property (strong,atomic) MCHMissle *activePlayerMissle;
@property (strong,atomic) SKLabelNode *scoreDisplay;
@end
