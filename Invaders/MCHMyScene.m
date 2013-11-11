//
//  MCHMyScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-06-26.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHMyScene.h"
#import "MCHGameplayScene.h"

@implementation MCHMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        
        self.title = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.title.text = @"INVADERS";
        self.title.fontSize = 70;
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height - self.title.frame.size.height * 2);

        self.subtitle = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.subtitle.text = @"(r o b f o rd edition)";
        self.subtitle.fontSize = 38;
        self.subtitle.position = CGPointMake(CGRectGetMidX(self.frame),self.title.position.y - self.title.frame.size.height);
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        SKTexture *fordHeadTexture = [atlas textureNamed:@"invader0-row0.png"];
        self.fordHead = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(30, 30)];
        self.fordHead.position = CGPointMake(self.subtitle.position.x-105, self.subtitle.position.y+10);

        fordHeadTexture = [atlas textureNamed:@"invader0-row1.png"];
        self.fordHead2 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(30, 30)];
        self.fordHead2.position = CGPointMake(self.subtitle.position.x-22, self.subtitle.position.y+10);

        self.playButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.playButton.text = @"NEW GAME";
        self.playButton.fontSize = 28;
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));

        self.leaderboardButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.leaderboardButton.text = @"LEADERBOARD";
        self.leaderboardButton.fontSize = 28;
        self.leaderboardButton.position = CGPointMake(CGRectGetMidX(self.frame),self.playButton.position.y - self.playButton.frame.size.height*3);

        [self addChild:self.title];
        [self addChild:self.subtitle];
        [self addChild:self.fordHead];
        [self addChild:self.fordHead2];
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
        //transition to gameplay scene
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
