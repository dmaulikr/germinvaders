//
//  MCHDataManager.h
//  Invaders
//
//  Created by Marc Henderson on 2013-11-12.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCHDataManager : NSObject

@property (strong,atomic) NSArray *highscoreList;

- (NSArray *)gethighscoreList;
- (void)addNewHighScore:(int)score atLevel:(int)level;

@end
