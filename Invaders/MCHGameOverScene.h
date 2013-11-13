//
//  MCHGameOverScene.h
//  Invaders
//
//  Created by Marc Henderson on 2013-11-13.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MCHGameOverScene : SKScene

@property (assign)int score;
@property (assign)int level;
@property (strong,atomic) SKSpriteNode *endGameBoss;
@property (strong,atomic) SKLabelNode *gameOverDisplay;
@property (strong,atomic) SKLabelNode *restartButtonLabel;
@property (strong,atomic) SKSpriteNode *restartButton;
@property (strong,atomic) SKLabelNode *scoreDisplay;
@property (strong,atomic) SKLabelNode *menuButtonLabel;
@property (strong,atomic) SKSpriteNode *menuButton;
@property (strong,atomic) UITextField *highScoreInput;

@end
