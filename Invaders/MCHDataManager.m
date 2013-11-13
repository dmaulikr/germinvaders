//
//  MCHDataManager.m
//  Invaders
//
//  Created by Marc Henderson on 2013-11-12.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHDataManager.h"
#import "MCHSortableScore.h"

@implementation MCHDataManager

- (void)limitHighScoreList{
    NSMutableArray *trimmedArray = [[NSMutableArray alloc] initWithArray:_highscoreList];
    while ([trimmedArray count] > MAX_NUM_HIGH_SCORES) {
        [trimmedArray removeLastObject];
    }
    _highscoreList = trimmedArray;
}

- (void)sortHighScores{
    NSMutableArray *scoresToSort = [[NSMutableArray alloc] init];
    for(NSString *entry in _highscoreList){
        NSArray *entryParts = [entry componentsSeparatedByString:@" "];
        MCHSortableScore *score = [[MCHSortableScore alloc] init];
        NSString *scoreStr = (NSString *)[entryParts objectAtIndex:0];
        score.score = [scoreStr integerValue];
        NSString *levelStr = (NSString *)[entryParts objectAtIndex:2];
        score.level = [levelStr integerValue];
        [scoresToSort addObject:score];
    }
    
    NSArray *sortedScores = [scoresToSort sortedArrayUsingComparator:^(id score1, id score2){
        return ((MCHSortableScore *)score1).score <  ((MCHSortableScore *)score2).score;
    }];
    
    NSMutableArray *formattedSortedScore = [[NSMutableArray alloc] init];
    for(MCHSortableScore *score in sortedScores){
        [formattedSortedScore addObject:[NSString stringWithFormat:@"%d LEVEL %d",score.score,score.level]];
    }
    _highscoreList = formattedSortedScore;
}

- (NSArray *)gethighscoreList{
    if(!_highscoreList){
        _highscoreList = [[NSUserDefaults standardUserDefaults] arrayForKey:HIGH_SCORE_KEY];
        if(!_highscoreList){
            _highscoreList = [[NSMutableArray alloc] init];
        }
    }
    [self sortHighScores];
    return _highscoreList;
}

- (void)addNewHighScore:(int)score atLevel:(int)level{
    NSArray *currentList = [self gethighscoreList];
    NSMutableArray *editableList = [[NSMutableArray alloc] initWithArray:currentList];
    NSString *entry = [NSString stringWithFormat:@"%d LEVEL %d",score,level];
    [editableList addObject:entry];
    _highscoreList = editableList;
    [self sortHighScores];
    if ([_highscoreList count] > MAX_NUM_HIGH_SCORES) {
        [self limitHighScoreList];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_highscoreList forKey:HIGH_SCORE_KEY];
}

@end
