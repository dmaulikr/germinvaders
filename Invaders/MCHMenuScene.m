//
//  MCHMyScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHMenuScene.h"
#import "MCHGameplayScene.h"
#import "MCHLeaderboardScene.h"

@implementation MCHMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        
        self.title = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.title.text = @"INVADERS";
        self.title.fontSize = 70;
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height - self.title.frame.size.height * 2);

        /*
        self.subtitle = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.subtitle.text = @"(r o b f o rd edition)";
        self.subtitle.fontSize = 38;
        self.subtitle.position = CGPointMake(CGRectGetMidX(self.frame),self.title.position.y - self.title.frame.size.height);
         */
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        SKTexture *fordHeadTexture = [atlas textureNamed:@"invader0-row0.png"];
        self.fordHead = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(30, 44)];
        self.fordHead.position = CGPointMake(CGRectGetMidX(self.frame)-100, self.title.position.y - self.title.frame.size.height - 30);

        fordHeadTexture = [atlas textureNamed:@"invader0-row1.png"];
        self.fordHead2 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(30, 44)];
        self.fordHead2.position = CGPointMake(CGRectGetMidX(self.frame)- 5, self.fordHead.position.y);
        
        fordHeadTexture = [atlas textureNamed:@"invader0-row3.png"];
        self.fordHead3 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(30, 44)];
        self.fordHead3.position = CGPointMake(CGRectGetMidX(self.frame)+45, self.fordHead.position.y);
        
        fordHeadTexture = [atlas textureNamed:@"invader0-row4.png"];
        self.fordHead4 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(30, 44)];
        self.fordHead4.position = CGPointMake(CGRectGetMidX(self.frame)+100, self.fordHead.position.y);

        SKLabelNode *playButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        playButtonLabel.text = @"NEW GAME";
        playButtonLabel.fontSize = 28;
        playButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 60);
        [self addChild:playButtonLabel];
        
        self.playButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, playButtonLabel.frame.size.height+60)];
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),playButtonLabel.position.y+playButtonLabel.frame.size.height/2);

        SKLabelNode *highScoreButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        highScoreButtonLabel.text = @"HIGH SCORES";
        highScoreButtonLabel.fontSize = 28;
        highScoreButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),playButtonLabel.position.y - playButtonLabel.frame.size.height*4);
        [self addChild:highScoreButtonLabel];
        
        self.leaderboardButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, highScoreButtonLabel.frame.size.height+60)];
        self.leaderboardButton.position = CGPointMake(CGRectGetMidX(self.frame),highScoreButtonLabel.position.y+highScoreButtonLabel.frame.size.height/2);
        
        [self addChild:self.title];
//        [self addChild:self.subtitle];
        [self addChild:self.fordHead];
        [self addChild:self.fordHead2];
        [self addChild:self.fordHead3];
        [self addChild:self.fordHead4];
        [self addChild:self.playButton];
        [self addChild:self.leaderboardButton];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node isEqual:self.playButton]){
        SKScene *gameScene = [[MCHGameplayScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:gameScene transition:doors];
    }else if([node isEqual:self.leaderboardButton]){
        SKScene *leaderboardScene = [[MCHLeaderboardScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:leaderboardScene transition:doors];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
