//
//  Location.h
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

-(Location *) initWithX:(NSInteger) x y:(NSInteger) y;
-(NSString *) at;
+(NSString *) stringFromListOfLocations:(NSArray *) locations;

-(BOOL) samePosition:(Location*) anotherLocation;
@end
