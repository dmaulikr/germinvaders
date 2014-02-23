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
        
//        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"scene-background"];
        [background setName:@"background"];
        [background setAnchorPoint:CGPointZero];
        [self addChild:background];
        
        self.title = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.title.text = @"GERM INVADERS";
        self.title.fontSize = 44;
        self.title.fontColor = [UIColor whiteColor];
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height - self.title.frame.size.height * 2);

        /*
        self.subtitle = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.subtitle.text = @"(r o b f o rd edition)";
        self.subtitle.fontSize = 38;
        self.subtitle.position = CGPointMake(CGRectGetMidX(self.frame),self.title.position.y - self.title.frame.size.height);
         */
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        SKTexture *fordHeadTexture = [atlas textureNamed:@"invader0-row0.png"];
        self.fordHead = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(60, 56)];
        self.fordHead.position = CGPointMake(CGRectGetMidX(self.frame)-120, self.title.position.y - self.title.frame.size.height-80);

        fordHeadTexture = [atlas textureNamed:@"invader0-row1.png"];
        self.fordHead2 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(60, 56)];
        self.fordHead2.position = CGPointMake(CGRectGetMidX(self.frame)-42, self.fordHead.position.y);
        
        fordHeadTexture = [atlas textureNamed:@"invader0-row3.png"];
        self.fordHead3 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(60, 56)];
        self.fordHead3.position = CGPointMake(CGRectGetMidX(self.frame)+30, self.fordHead.position.y);
        
        fordHeadTexture = [atlas textureNamed:@"invader0-row4.png"];
        self.fordHead4 = [[SKSpriteNode alloc] initWithTexture:fordHeadTexture color:[UIColor whiteColor] size:CGSizeMake(60, 56)];
        self.fordHead4.position = CGPointMake(CGRectGetMidX(self.frame)+110, self.fordHead.position.y);

        SKLabelNode *playButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        playButtonLabel.text = @"NEW GAME";
        playButtonLabel.fontSize = 28;
        playButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 30);
        playButtonLabel.fontColor = [UIColor whiteColor];
        [self addChild:playButtonLabel];
        
        self.playButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, playButtonLabel.frame.size.height+60)];
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),playButtonLabel.position.y+playButtonLabel.frame.size.height/2);

        SKLabelNode *highScoreButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        highScoreButtonLabel.text = @"HIGH SCORES";
        highScoreButtonLabel.fontSize = 28;
        highScoreButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),playButtonLabel.position.y - playButtonLabel.frame.size.height*3);
        highScoreButtonLabel.fontColor = [UIColor whiteColor];
        [self addChild:highScoreButtonLabel];
        
        self.highscoreButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, highScoreButtonLabel.frame.size.height+60)];
        self.highscoreButton.position = CGPointMake(CGRectGetMidX(self.frame),highScoreButtonLabel.position.y+highScoreButtonLabel.frame.size.height/2);
        
        SKLabelNode *leaderboardButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        leaderboardButtonLabel.text = @"LEADERBOARD";
        leaderboardButtonLabel.fontSize = 28;
        leaderboardButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),highScoreButtonLabel.position.y - highScoreButtonLabel.frame.size.height*3);
        leaderboardButtonLabel.fontColor = [UIColor whiteColor];
        [self addChild:leaderboardButtonLabel];
        
        self.leaderboardButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, leaderboardButtonLabel.frame.size.height+60)];
        self.leaderboardButton.position = CGPointMake(CGRectGetMidX(self.frame),leaderboardButtonLabel.position.y+leaderboardButtonLabel.frame.size.height/2);
        
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
        self.versionDisplay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.versionDisplay.text = [NSString stringWithFormat:@"version %@",version];
        self.versionDisplay.fontSize = 12;
        self.versionDisplay.position = CGPointMake(CGRectGetMidX(self.frame),self.versionDisplay.frame.size.height + 5);
        self.versionDisplay.fontColor = [UIColor whiteColor];
        [self addChild:self.versionDisplay];
        
        [self addChild:self.title];
        [self addChild:self.fordHead];
        [self addChild:self.fordHead2];
        [self addChild:self.fordHead3];
        [self addChild:self.fordHead4];
        [self addChild:self.playButton];
        [self addChild:self.highscoreButton];
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
    }else if([node isEqual:self.highscoreButton]){
        SKScene *leaderboardScene = [[MCHLeaderboardScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:leaderboardScene transition:doors];
    }else if([node isEqual:self.leaderboardButton]){
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil){
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            UIViewController *vc = self.view.window.rootViewController;
            [vc presentViewController: gameCenterController animated: YES completion:nil];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController {
    UIViewController *vc = self.view.window.rootViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
