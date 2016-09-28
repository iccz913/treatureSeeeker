//
//  GameManager.h
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Seeker, Map, Location;

typedef enum : NSUInteger {
    ended = 0,
    advancing = 1,
    prepared,
} gameStatus;

typedef void (^executeBlock)();
typedef void (^gameProgressBlock)(gameStatus status, Seeker * winner);

@interface GameManager : NSObject
@property (nonatomic, strong) Map * map;
@property (nonatomic, strong) NSMutableArray * playerList;
@property (nonatomic) int round;
@property (nonatomic) gameStatus status;

-(void) prepareNewGame;
-(void) advanceRoundWithCompleteBlock:(executeBlock) block;
-(void) checkCurrentRoundResultWithCompleteBlock:(gameProgressBlock) block;
-(NSString *) colorOfLocation:(Location *) aLocation;

@end
