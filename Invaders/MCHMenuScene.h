//
//  MCHMyScene.h
//  Invaders
//

//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

@interface MCHMenuScene : SKScene <GKGameCenterControllerDelegate>

@property (strong,atomic)SKSpriteNode *playButton;
@property (strong,atomic)SKSpriteNode *highscoreButton;
@property (strong,atomic)SKSpriteNode *leaderboardButton;
@property (strong,atomic)SKLabelNode *title;
@property (strong,atomic)SKLabelNode *subtitle;
@property (strong,atomic)SKSpriteNode *fordHead;
@property (strong,atomic)SKSpriteNode *fordHead2;
@property (strong,atomic)SKSpriteNode *fordHead3;
@property (strong,atomic)SKSpriteNode *fordHead4;
@property (strong,atomic)SKLabelNode *versionDisplay;

@end
