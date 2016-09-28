//
//  GameManager.m
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import "GameManager.h"
#import "Seeker.h"
#import "Map.h"
@interface GameManager()
@end

@implementation GameManager

-(GameManager *) init
{
    self = [super init];
    self.playerList = [NSMutableArray new];
    
    @autoreleasepool {
        for (int i = 0; i < 2; i++) // should be from user input
            self.playerList[i] = [[Seeker alloc] initWithName:[NSString stringWithFormat:@"Player %d", i + 1] withColorName: i == 0? @"red" : @"blue"];
    }
    
    self.map = [[Map alloc] initWithWidth:5 height:5]; // 5x5 grip;
    return self;
}

-(void) prepareNewGame
{
    self.round = 0;
    @autoreleasepool {
        for (Seeker * player in self.playerList)
            [player reset];
    }
    
    [self.map reset]; //reset price location
    
    NSArray * initLocations = [self.map getInitSeekerLocationsWithCount: self.playerList.count];
    
    if(initLocations.count)
    {
        @autoreleasepool {
            for (int i = 0; i < initLocations.count; i++)
                [self.playerList[i] startAt: initLocations[i]];
        }
        
//        NSLog(@"game prepared, price at : %@, player 1 at %@, player 2 at %@", self.map.priceLocation.at, [initLocations[0] at], [initLocations[1] at]);
    }
    
    self.status = prepared;
}

-(void) advanceRoundWithCompleteBlock:(executeBlock) block
{
    self.round++;
//    NSLog(@"********* round %d  **********", self.round);

    @autoreleasepool {
        for (Seeker * player in self.playerList)
            [self assignMovesForPlayer: player]; // only give player options, not giving where to actually go, player object will determine that
    }
    
    if(block)
        block();
}



-(void) assignMovesForPlayer:(Seeker *) seeker
{
    NSArray * validMoves = [self.map validNextMoveForLocation:seeker.currentLocation]; // all valid moves based on map
    
//    NSLog(@"%@ can move on map: %@", seeker.name, [Location stringFromListOfLocations: validMoves]);
    
    validMoves = [self filterMoves: validMoves forPlayer: seeker]; // make sure it doesn't cost other players path
    
//    NSLog(@"%@ can move after considering other's path: %@", seeker.name, [Location stringFromListOfLocations: validMoves]);
    
    [seeker pickNextMoveFrom: validMoves];
}



-(NSArray *) filterMoves:(NSArray *) moves forPlayer: (Seeker *) aPlayer
{
    NSMutableArray * ret = [NSMutableArray new];
    
    if(moves.count)
    {
        NSMutableArray * otherPlayersPath = [NSMutableArray new];
        
        @autoreleasepool {
            for (Seeker * player  in self.playerList)
            {
                if(player != aPlayer)
                    [otherPlayersPath addObjectsFromArray: player.path];
            }
        }
        
        @autoreleasepool {
            for (Location * aLocation in moves)
            {
                NSArray * res = [otherPlayersPath filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"x = %d AND y = %d", aLocation.x, aLocation.y]];
                
                if(res.count == 0) // move is not in other players' path
                    [ret addObject:aLocation];
            }
        }
    }
    
    return [ret copy];
}


-(void) checkCurrentRoundResultWithCompleteBlock:(gameProgressBlock) block
{
    Seeker * winner = nil;
    
    for (Seeker * player in self.playerList)
    {
        Location * aLocation = player.currentLocation;
        
        if([aLocation samePosition:self.map.priceLocation])
        {
            winner = player;
            break;
        }
    }
    
    if(winner)
    {
//        NSLog(@"%@ found treasure at %@ in round %d", winner.name, self.map.priceLocation.at, self.round);
        winner.score++;
    }
    
    self.status = winner? ended : advancing;
    
    if(block)
        block(self.status, winner);
}



-(NSString *) colorOfLocation:(Location *) aLocation
{
    NSString * color = @"gray";
    
    if([aLocation samePosition:self.map.priceLocation] && self.status != ended)
        color = @"green"; // price location
    
    else
    {
        for (Seeker * aPlayer in self.playerList)
        {
            if([aPlayer.currentLocation samePosition:aLocation])
                color = aPlayer.colorName;
            else if ([aPlayer.path filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"x = %d AND y = %d", aLocation.x, aLocation.y]].count)
                color = aPlayer.colorName;
        }
    }
    
    return [color stringByAppendingString:@"Dot"];
}

@end
