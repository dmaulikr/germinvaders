//
//  MCHGameCenterManager.m
//  GermInvaders
//
//  Created by Marc Henderson on 2/22/2014.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import "MCHGameCenterManager.h"

@implementation MCHGameCenterManager
@synthesize gameCenterAvailable;

#pragma mark Initialization

static MCHGameCenterManager *sharedHelper = nil;
+ (MCHGameCenterManager *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[MCHGameCenterManager alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = YES;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = NO;
    }
}

#pragma mark User functions

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error){
            if (viewController != nil){
                NSLog(@"we are supposed to show a view controller.");
                UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                [vc presentViewController: viewController animated: YES completion:nil];
            }else if ([GKLocalPlayer localPlayer].isAuthenticated){
                NSLog(@"player is authenticated...");
                userAuthenticated = YES;
            }else{
                NSLog(@"player is not authenticated...");
                userAuthenticated = NO;
            }
        }];
    } else {
        NSLog(@"Already authenticated!");
    }
}

+ (void) reportScore: (int) score forIdentifier: (NSString*) identifier {
    NSLog(@"score being reported:%i",score);
    GKScore* highScore = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    highScore.value = score;
    [GKScore reportScores:@[highScore] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Error in reporting scores: %@", error);
        }else{
            NSLog(@"Score reported...");
        }
    }];
}

@end
