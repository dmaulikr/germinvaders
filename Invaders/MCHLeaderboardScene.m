//
//  MCHLeaderboardScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-11-10.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHLeaderboardScene.h"
#import "MCHMenuScene.h"
#import "MCHAppDelegate.h"
#import "MCHDataManager.h"

@implementation MCHLeaderboardScene

- (void)renderLeaderboardEntries {
    float startY = self.leaderboardTitle.position.y - self.leaderboardTitle.frame.size.height*1.5 - 5;
    for(NSString *labelString in self.leaderboardData){
        SKLabelNode *boardEntry = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        boardEntry.text = [NSString stringWithFormat:@"%@",labelString];
        boardEntry.fontSize = 20;
        boardEntry.position = CGPointMake(CGRectGetMidX(self.frame),startY);
        [self addChild:boardEntry];
        [self.leaderboardEntries addObject:boardEntry];
        startY -= boardEntry.frame.size.height*2.35;
    }
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];

        
        MCHAppDelegate *appdelegate = (MCHAppDelegate *)[[UIApplication sharedApplication] delegate];
                
        self.leaderboardData = [appdelegate.dataManager gethighscoreList];
        if([self.leaderboardData count] < 1){
            self.leaderboardData = @[@"play the game and set a high score"];
        }
        
        self.leaderboardTitle = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.leaderboardTitle.text = @"HIGH SCORES";
        self.leaderboardTitle.fontSize = 42;
        self.leaderboardTitle.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height - self.leaderboardTitle.frame.size.height * 3);
        [self addChild:self.leaderboardTitle];
        
        self.leaderboardEntries = [[NSMutableArray alloc] init];
        
        [self renderLeaderboardEntries];
        
        self.clearButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.clearButtonLabel.text = @"clear";
        self.clearButtonLabel.fontSize = 18;
        self.clearButtonLabel.position = CGPointMake(self.frame.size.width - self.clearButtonLabel.frame.size.width+10,self.size.height-40);
        [self addChild:self.clearButtonLabel];
        
        self.clearButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.clearButtonLabel.frame.size.width+40, self.clearButtonLabel.frame.size.height+70)];
        self.clearButton.position = CGPointMake(self.frame.size.width - self.clearButton.frame.size.width/2,self.size.height-self.clearButton.frame.size.height/2);
        [self addChild:self.clearButton];
        
        self.menuButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.menuButtonLabel.text = @"menu";
        self.menuButtonLabel.fontSize = 18;
        self.menuButtonLabel.position = CGPointMake(0+10+(self.menuButtonLabel.frame.size.width/2),self.clearButtonLabel.position.y);
        [self addChild:self.menuButtonLabel];
        
        self.menuButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.menuButtonLabel.frame.size.width+40, self.menuButtonLabel.frame.size.height+70)];
        self.menuButton.position = CGPointMake(0+self.menuButton.frame.size.width/2,self.clearButton.position.y);
        [self addChild:self.menuButton];
    }
    return self;
}

-(void)goMenu{
    SKScene *introScene = [[MCHMenuScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:introScene transition:doors];
}

-(void)clearLeaderboard{
    for(SKLabelNode *entry in self.leaderboardEntries){
        [entry removeFromParent];
    }
    [self.leaderboardEntries removeAllObjects];
    self.leaderboardData = nil;
    self.leaderboardEntries = nil;
    [self renderLeaderboardEntries];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node isEqual:self.menuButton]){
        [self goMenu];
    }else if([node isEqual:self.clearButton]){
        [self clearLeaderboard];
    }
}

@end
