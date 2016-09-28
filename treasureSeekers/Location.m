//
//  Location.m
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import "Location.h"

@implementation Location


-(Location *) initWithX:(NSInteger) x y:(NSInteger) y
{
    self = [super init];
    self.x = x;
    self.y = y;
    
    return self;
}

-(NSString *)at
{
    return [NSString stringWithFormat:@"(%ld, %ld)", self.x, self.y];
}

+(NSString *) stringFromListOfLocations:(NSArray *) locations
{
    NSString * ret = @"";
    
    for (Location * aLocation in locations)
        ret = [ret stringByAppendingFormat:@"%@ ", aLocation.at];
    
    return ret;
}

-(BOOL) samePosition:(Location*) anotherLocation
{
    return self.x == anotherLocation.x && self.y == anotherLocation.y;
}
@end
