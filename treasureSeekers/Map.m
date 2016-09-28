//
//  Map.m
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import "Map.h"

@interface Map()
@property (nonatomic, strong) NSArray * seekerStartLocations;
@end

@implementation Map


-(Map *) initWithWidth:(int) width height:(int) height
{
    self = [super init];
    self.width = MAX(1,width); // 0 doesnt make sense
    self.height = MAX(1,height);
    
    // only can start in the corners, position 0 - 4
    self.seekerStartLocations = @[[[Location alloc] initWithX:0 y:0], [[Location alloc] initWithX:0 y:height - 1], [[Location alloc] initWithX:width - 1 y:0], [[Location alloc] initWithX:width - 1 y:height - 1]];
    
    return self;
}


-(void)reset
{
    //reset price location
    self.priceLocation = [self generatePriceLocation];
}



-(NSArray *)getInitSeekerLocationsWithCount:(NSInteger)seekerCount
{
    if (seekerCount == 0)
        return @[];
    
    NSArray * ret = [self shuffleArray:self.seekerStartLocations];
    
    return [[ret subarrayWithRange:NSMakeRange(0, seekerCount)] copy];
}


- (NSArray *)shuffleArray:(NSArray *) array
{
    NSMutableArray * temp = [array mutableCopy];
    NSUInteger count = [array count];
    
    @autoreleasepool {
        for (NSUInteger i = 0; i < count - 1; ++i) {
            NSInteger remainingCount = count - i;
            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
            [temp exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
    }
    
    return [temp copy];
}

-(Location *) generatePriceLocation
{
    BOOL valid = true;
    int x  = 0; int y = 0;
    
    @autoreleasepool {
        do
        {
            x = arc4random_uniform(self.width - 1);
            y = arc4random_uniform(self.height - 1);
            
            @autoreleasepool {
                for (Location * location in self.seekerStartLocations)
                {
                    if(x == location.x && y == location.y)
                    {
                        valid = false;
                        break;
                    }
                    else
                        valid = true;
                }
            }
            
        } while (!valid);
    }

    
    return [[Location alloc] initWithX: x y: y];
}



-(NSArray *) validNextMoveForLocation:(Location *) location
{
    NSMutableArray * ret = [[self getAdjacentFromLocation:location] mutableCopy]; // get all adjacents
    
    return [ret copy];
}



-(NSArray *) getAdjacentFromLocation:(Location *) location
{
    NSMutableArray * ret = [NSMutableArray new];
    
    if(location.y != 0) // going up
        [ret addObject: [[Location alloc] initWithX: location.x y: location.y - 1]];
    
    if(location.y < self.height - 1) // going down
        [ret addObject: [[Location alloc] initWithX: location.x y: location.y + 1]];
    
    if(location.x != 0) // going left
        [ret addObject: [[Location alloc] initWithX: location.x -1 y: location.y]];
    
    if(location.x < self.width - 1) // going right
        [ret addObject: [[Location alloc] initWithX: location.x + 1 y: location.y]];
    
    return [ret copy];
}



@end
