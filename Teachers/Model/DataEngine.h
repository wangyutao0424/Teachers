//
//  DataEngine.h
//  LittleFriends
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserData;
@interface DataEngine : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(DataEngine *)sharedDataEngine;
-(UserData *)fetchUserData;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (id ) fetchExistEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate;
- (NSArray *) fetchExistEntityList: (NSString *) entityName withPredicate: (NSPredicate *) predicate;

- (NSInteger)addGameLevelCounts:(NSInteger)count;
- (NSInteger)addGameCoins:(NSInteger)coinsCount;
- (NSInteger)addWrongNumber;
- (void)addShare;
- (void)addShowTure;
- (void)addLu;
@end
