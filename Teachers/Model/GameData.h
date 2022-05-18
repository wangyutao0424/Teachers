//
//  GameData.h
//  Teachers
//
//  Created by wangyutao on 14-5-15.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GameData : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * gameId;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * options;
@property (nonatomic, retain) NSSet *showtrues;
@end

@interface GameData (CoreDataGeneratedAccessors)

- (void)addShowtruesObject:(NSManagedObject *)value;
- (void)removeShowtruesObject:(NSManagedObject *)value;
- (void)addShowtrues:(NSSet *)values;
- (void)removeShowtrues:(NSSet *)values;

@end
