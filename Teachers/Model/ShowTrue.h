//
//  ShowTrue.h
//  Teachers
//
//  Created by wangyutao on 14-5-15.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameData;

@interface ShowTrue : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * gameId;
@property (nonatomic, retain) GameData *gameData;

@end
