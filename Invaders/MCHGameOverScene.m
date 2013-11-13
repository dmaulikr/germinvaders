//
//  MCHGameOverScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-11-13.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHGameOverScene.h"
#import "MCHMenuScene.h"
#import "MCHAppDelegate.h"
#import "MCHDataManager.h"
#import "MCHGameplayScene.h"

@implementation MCHGameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        
        /*
        SKLabelNode *tempLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        tempLabel.text = @"tap to dismiss";
        tempLabel.fontSize = 38;
        tempLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        
        [self addChild:tempLabel];
        */
        
        self.menuButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.menuButtonLabel.text = @"menu";
        self.menuButtonLabel.fontSize = 18;
        self.menuButtonLabel.position = CGPointMake(0+10+(self.menuButtonLabel.frame.size.width/2),self.size.height-40);
        [self addChild:self.menuButtonLabel];
        
        self.menuButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.menuButtonLabel.frame.size.width+20, self.menuButtonLabel.frame.size.height+50)];
        self.menuButton.position = CGPointMake(self.menuButtonLabel.frame.size.width/2,self.size.height-self.menuButton.frame.size.height/2);
        [self addChild:self.menuButton];
        
        self.scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.scoreDisplay.text = [NSString stringWithFormat:@"score %d level %d",self.level,self.score];
        self.scoreDisplay.fontSize = 18;
        self.scoreDisplay.position = CGPointMake(CGRectGetMidX(self.frame),self.menuButtonLabel.frame.origin.y - (self.menuButtonLabel.frame.size.height+5));
        [self addChild:self.scoreDisplay];
        
        if(self.score > 0){
            MCHAppDelegate *appdelegate = (MCHAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appdelegate.dataManager addNewHighScore:self.score atLevel:self.level];
        }
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"invader"];
        SKTexture *endBossTexture = [atlas textureNamed:@"robfordendgame-sized.png"];
        self.endGameBoss = [[SKSpriteNode alloc] initWithTexture:endBossTexture color:[UIColor whiteColor] size:CGSizeMake(257/2,300)];
        self.endGameBoss.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:self.endGameBoss];
        
        self.gameOverDisplay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.gameOverDisplay.text = @"GAME OVER";
        self.gameOverDisplay.fontSize = 38;
        self.gameOverDisplay.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:self.gameOverDisplay];
        
        self.restartButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        self.restartButtonLabel.text = @"replay game";
        self.restartButtonLabel.fontSize = 24;
        self.restartButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),self.gameOverDisplay.position.y - self.gameOverDisplay.frame.size.height - 20);
        [self addChild:self.restartButtonLabel];
        
        self.restartButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.restartButtonLabel.frame.size.width*1.2, self.restartButtonLabel.frame.size.height*1.2 + self.gameOverDisplay.frame.size.height + 60)];
        self.restartButton.position = CGPointMake(self.restartButtonLabel.position.x, self.gameOverDisplay.position.y);
        [self addChild:self.restartButton];
        
        /*
         if (false) { //this is where we'll prompt user for name for high score save
         if(!self.highScoreInput){
         self.highScoreInput = [[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2, self.size.height/2+20, 200, 40)];
         self.highScoreInput.center = self.view.center;
         self.highScoreInput.borderStyle = UITextBorderStyleRoundedRect;
         self.highScoreInput.textColor = [UIColor blackColor];
         self.highScoreInput.font = [UIFont systemFontOfSize:17.0];
         self.highScoreInput.placeholder = @"enter your name";
         self.highScoreInput.backgroundColor = [UIColor whiteColor];
         self.highScoreInput.autocorrectionType = UITextAutocorrectionTypeYes;
         self.highScoreInput.keyboardType = UIKeyboardAppearanceAlert;
         self.highScoreInput.clearButtonMode = UITextFieldViewModeWhileEditing;
         //    textField.delegate = self.delegate;
         [self.view addSubview:self.highScoreInput];
         }
         self.highScoreInput.hidden = NO;
         
         }
         */
        
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view{
    self.endGameBoss.hidden = NO;
}

- (SKEmitterNode*) newExplosionEmitter{
    NSString *invaderExplosionPath = [[NSBundle mainBundle] pathForResource:@"InvaderExplosion" ofType:@"sks"];
    SKEmitterNode *invaderExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:invaderExplosionPath];
    return invaderExplosion;
}

-(void)goMenu{
    SKScene *introScene = [[MCHMenuScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:introScene transition:doors];
}

-(void)goGameplayScene{
    SKScene *introScene = [[MCHGameplayScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:introScene transition:doors];
}

-(void)restartGame{
    SKEmitterNode *explosion = [self newExplosionEmitter];
    explosion.position = self.endGameBoss.position;
    [self addChild:explosion];
    [explosion runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.25],
                                              [SKAction runBlock:^{
        explosion.particleBirthRate = 0;
    }],
                                              [SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange],
                                              [SKAction removeFromParent],
                                              ]] completion:^{
        [self goGameplayScene];
    }];
    self.endGameBoss.hidden = YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node isEqual:self.menuButton]){
        [self goMenu];
    }else if([node isEqual:self.restartButton]){
        [self restartGame];
    }
}

@end
