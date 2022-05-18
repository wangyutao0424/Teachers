//
//  UserData.h
//  LittleFriends
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSNumber * currentLv;
@property (nonatomic, retain) NSNumber * currentGold;
@property (nonatomic, retain) NSNumber * currentResource;
@property (nonatomic, retain) NSNumber * totalLevelNumber;
@property (nonatomic, retain) NSDate * showTrueTime;
@property (nonatomic, retain) NSNumber * currentAch;
@property (nonatomic, retain) NSNumber * wrongAnswer;
@property (nonatomic, retain) NSDate * useLuTime;
@property (nonatomic, retain) NSNumber * luCount;
@property (nonatomic, retain) NSNumber * collectedGold;
@property (nonatomic, retain) NSNumber * share;
@property (nonatomic, retain) NSNumber * showTrue;
@property (nonatomic, retain) NSNumber * wrong;
@property (nonatomic, retain) NSDate * shareDate;
@property (nonatomic, retain) NSNumber * effect;
@property (nonatomic, retain) NSNumber * music;
@end
