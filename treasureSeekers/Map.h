//
//  Map.h
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Map : NSObject
@property (nonatomic, strong) Location * priceLocation;
@property (nonatomic) int width;
@property (nonatomic) int height;

-(void) reset;
-(NSArray *) getInitSeekerLocationsWithCount:(NSInteger)seekerCount;
-(NSArray *) validNextMoveForLocation:(Location *) location;
-(Map *) initWithWidth:(int) width height:(int) height;

@end
