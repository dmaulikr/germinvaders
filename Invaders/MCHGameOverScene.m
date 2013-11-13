//
//  MCHGameOverScene.m
//  Invaders
//
//  Created by Marc Henderson on 2013-11-13.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "MCHGameOverScene.h"
#import "MCHMenuScene.h"

@implementation MCHGameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        
        
        SKLabelNode *tempLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        tempLabel.text = @"tap to dismiss";
        tempLabel.fontSize = 38;
        tempLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        
        [self addChild:tempLabel];
    }
    return self;
}

-(void)goMenu{
    SKScene *introScene = [[MCHMenuScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:introScene transition:doors];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self goMenu];
    /*
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node isEqual:self.menuButton]){
        [self goMenu];
    }else if([node isEqual:self.clearButton]){
        [self clearLeaderboard];
    }
     */
}

@end
