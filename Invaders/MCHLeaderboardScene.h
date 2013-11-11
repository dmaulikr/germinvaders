//
//  MCHLeaderboardScene.h
//  Invaders
//
//  Created by Marc Henderson on 2013-11-10.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MCHLeaderboardScene : SKScene

@property (strong,atomic) SKLabelNode *clearButtonLabel;
@property (strong,atomic) SKSpriteNode *clearButton;
@property (strong,atomic) SKLabelNode *menuButtonLabel;
@property (strong,atomic) SKSpriteNode *menuButton;
@property (strong,atomic) NSArray *leaderboardData;
@property (strong,atomic) NSMutableArray *leaderboardEntries;
@property (strong,atomic) SKLabelNode *leaderboardTitle;

@end
