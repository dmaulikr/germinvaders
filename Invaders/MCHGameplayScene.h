//
//  MCHGameplayScene.h
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <stdlib.h>
#import "MCHPlayer.h"
#import "MCHMissle.h"

@class MCHInvader;

@interface MCHGameplayScene : SKScene <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
@property (strong,atomic) NSMutableArray *invaders;
@property (strong,atomic) NSMutableArray *activeMissles;
@property (strong,atomic) NSMutableArray *shields;
@property (strong,atomic) MCHPlayer *player;
@property (strong,atomic) SKSpriteNode *playerControl;
@property (strong,atomic) SKLabelNode *scoreDisplay;
@property (strong,atomic) SKLabelNode *pauseButtonLabel;
@property (strong,atomic) SKSpriteNode *pauseButton;
@property (strong,atomic) SKLabelNode *menuButtonLabel;
@property (strong,atomic) SKSpriteNode *menuButton;
@property (strong,atomic) SKLabelNode *gameOverDisplay;
@property (strong,atomic) SKSpriteNode *restartButton;
@property (strong,atomic) SKLabelNode *restartButtonLabel;
@property (strong,atomic) SKSpriteNode *playerShootButton;
@property (strong,atomic) SKSpriteNode *endGameBoss;
@property (strong,atomic) UITextField *highScoreInput;
@property int gameState;
@property BOOL anInvaderChasingPlayer;
@property BOOL movePlayer;
@property int invaderFireFrequency;

-(CGPoint)getPlayerPosition;
-(void)stopAllInvadersExcept:(MCHInvader *)invader;
@end
