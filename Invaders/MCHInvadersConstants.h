//
//  MCHInvadersConstants.h
//  Invaders
//
//  Created by Marc Henderson on 2013-11-02.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#ifndef Invaders_MCHInvadersConstants_h
#define Invaders_MCHInvadersConstants_h

#pragma mark - Sprite Categories

typedef enum : uint8_t {
    invadeCategory  = 1,
    playerCategory  = 2,
    shieldCategory  = 3,
    missleCategory  = 4
} ColliderType;



#pragma mark - Game States

#define GAMEON 0
#define GAMEOVER 1

#pragma mark - Game Layout Positions
#define SHIELD_START_Y_POS 110;

#pragma mark - High Scores

#define HIGH_SCORE_KEY @"invaders-high-scores"
#define MAX_NUM_HIGH_SCORES 8


#endif
