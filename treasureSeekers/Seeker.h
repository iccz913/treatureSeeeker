//
//  Seeker.h
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;
@interface Seeker : NSObject
-(void) reset;
-(void) startAt:(Location *) location;
-(Location *) currentLocation;
-(NSArray *) path; // wrapper for player trace
-(Seeker *) initWithName:(NSString *)name withColorName:(NSString *) colorName;
-(void) pickNextMoveFrom:(NSArray *) moves;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * colorName;

@property (nonatomic) NSInteger score;

@end
