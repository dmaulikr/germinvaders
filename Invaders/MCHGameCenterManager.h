//
//  MCHGameCenterManager.h
//  GermInvaders
//
//  Created by Marc Henderson on 2/22/2014.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface MCHGameCenterManager : NSObject {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;

+ (MCHGameCenterManager *)sharedInstance;
+ (void) reportScore: (int) score forIdentifier: (NSString*) identifier;
- (void) authenticateLocalUser;

@end
