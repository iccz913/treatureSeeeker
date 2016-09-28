//
//  Seeker.m
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import "Seeker.h"
#import "Location.h"

@interface Seeker()

@property (nonatomic, strong) NSMutableArray * trace; // where the user been to, act like  LIFO stack
@property (nonatomic) BOOL stayedLastRound; // make sure we dont stay infinitely, if checked, then we back trace and seek other options
@end

@implementation Seeker


-(Seeker *) initWithName:(NSString *)name withColorName:(NSString *) colorName
{
    self = [super init];
    self.trace = [NSMutableArray new];
    self.colorName = colorName;
    self.name = name;
    
    return self;
}


-(void) reset
{
    self.trace = [NSMutableArray new];
}

-(void) startAt:(Location *) location;
{
    [self.trace addObject:location];
}


-(Location *) currentLocation
{
    return self.trace.count? self.trace.lastObject : nil;
}



-(NSArray *)path
{
    return [self.trace copy];
}


-(void) pickNextMoveFrom:(NSArray *) moves
{
    moves = [self filterOldTraceFromMoves:moves]; // not considering last location as a valid move;
    
    if(moves.count)
    {
        // randomly pick one from valid moves
        Location * nextMove = moves[arc4random_uniform((u_int32_t ) moves.count)];
        [self.trace addObject: nextMove];
        self.stayedLastRound = NO;
//        NSLog(@"%@ chooses to move to %@", self.name, nextMove.at);
    }
    else // either dont move or back trace
    {
        // randomly pick stay or backtrace
        int backtrace = arc4random_uniform((u_int32_t ) 1);
        
        if(backtrace || self.stayedLastRound)
        {
            if(self.trace.count > 1) // if not at origin
            {
                [self.trace removeObject: self.trace.lastObject];
//                NSLog(@"%@ has no moves, backing to  %@", self.name, [self.trace.lastObject at]);
            }
            else
//                NSLog(@"%@ has no moves, and can not back off, staying", self.name);
            
            self.stayedLastRound = NO;
        }
        else
        {
//            NSLog(@"%@ has no moves, choose to stay", self.name);
            self.stayedLastRound = YES;
        }
    }
}

-(NSArray *) filterOldTraceFromMoves:(NSArray *) moves
{
    NSMutableArray * ret = [NSMutableArray new];

    @autoreleasepool {
        for (Location * aLocation in moves) // moves has constant count, trace is unlimited, so we loop moves
        {
            NSArray * res = [self.trace filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"x = %d AND y = %d", aLocation.x, aLocation.y]];
            if(res.count == 0)
                [ret addObject: aLocation];
        }
    }
    
    return [ret copy];
}

@end
