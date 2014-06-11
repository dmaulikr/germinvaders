//
//  MCHDataManager.m
//  Invaders
//
//  Created by Marc Henderson on 2013-11-12.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHDataManager.h"
#import "MCHSortableScore.h"
#import "MCHGameCenterManager.h"

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
        score.score = [scoreStr intValue];
        NSString *levelStr = (NSString *)[entryParts objectAtIndex:2];
        score.level = [levelStr intValue];
        [scoresToSort addObject:score];
    }

    NSArray *sortedScores = [scoresToSort sortedArrayUsingComparator:^NSComparisonResult(NSValue *a, NSValue *b) {
        MCHSortableScore *scoreA = (MCHSortableScore *)a;
        MCHSortableScore *scoreB = (MCHSortableScore *)b;
        return scoreA.score < scoreB.score;
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
    //First set the game center leaderboard score
    [MCHGameCenterManager reportScore:score forIdentifier:LEADERBOARD_ID];
    //Then set the local high score
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

- (void)clearHighScoreList{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HIGH_SCORE_KEY];
    _highscoreList = nil;
}

@end
