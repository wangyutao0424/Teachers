//
//  DataEngine.m
//  LittleFriends
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "DataEngine.h"
#import "UserData.h"
#import "Config.h"
#import "GameData.h"
#import "Achievement.h"
#import "AchManager.h"

@implementation DataEngine

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static DataEngine *dataEngine=nil;


+(DataEngine *)sharedDataEngine{
    @synchronized(self){
        if (dataEngine==nil) {
            dataEngine=[[DataEngine alloc]init];
        }
    }
    return dataEngine;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (dataEngine == nil)
        {
            dataEngine = [super allocWithZone:zone];
            return  dataEngine;
        }
    }
    return  nil;
}

-(id)init{
    self = [super init];
    if (self) {
        
        [self initData];
        
    }
    return self;
}

-(void)initData{
    //第一次进入时初始化，否则获得目前的userData
    UserData *userdata = [self initUserData];
    
    //初始化游戏数据
    int tmpResource = [userdata.currentResource integerValue] + 1;
    NSString *fileName = [NSString stringWithFormat:@"GameData_%d.plist",tmpResource];
    NSString *path = CONF_ResourcePath(fileName);

    while ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //初始化
        NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:path];
        
        for (int i = 0 ; i < [dataArray count]; i++) {
            NSMutableArray *array = [dataArray objectAtIndex:i];
            [self randArray:array];
            [self initGameCoreDataWithDataArray:array];
        }
        
        tmpResource++;

        userdata.currentResource = [NSNumber numberWithInt:tmpResource];
        
        fileName = [NSString stringWithFormat:@"GameData_%d.plist",tmpResource ];
        path = CONF_ResourcePath(fileName);

    }
    
    [self saveContext];
    //初始化成就数据
    
    int achTmp = [userdata.currentAch integerValue] + 1;
    NSString *achName = [NSString stringWithFormat:@"AchData_%d.plist",achTmp];
    NSString *achPath = CONF_ResourcePath(achName);
    
    while ([[NSFileManager defaultManager] fileExistsAtPath:achPath]) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:achPath];
        
        [self initAchDataWithDataArray:dataArray];
        
        achTmp++;
        
        userdata.currentAch = [NSNumber numberWithInt:achTmp];
        
        achName = [NSString stringWithFormat:@"AchData_%d.plist",achTmp];
        achPath = CONF_ResourcePath(achName);
    }
    [self saveContext];

}

-(UserData *)initUserData{
    UserData *user = [self fetchExistEntity:@"UserData" withPredicate:nil];
	if (nil == user)
	{
		user =  [NSEntityDescription
					insertNewObjectForEntityForName:@"UserData"
					inManagedObjectContext: self.managedObjectContext];
        user.currentGold = [NSNumber numberWithInt:0];
        user.currentLv = [NSNumber numberWithInt:1];
        user.currentResource = [NSNumber numberWithInt:0];
        user.totalLevelNumber = [NSNumber numberWithInt:0];
        user.showTrueTime = [NSDate distantPast];
        user.currentAch = [NSNumber numberWithInt:0];
        user.wrongAnswer = [NSNumber numberWithInt:0];
        user.useLuTime = [NSDate distantPast];
        user.luCount = [NSNumber numberWithInt:0];
        user.collectedGold = [NSNumber numberWithInt:0];
        user.share = [NSNumber numberWithInt:0];
        user.showTrue = [NSNumber numberWithInt:0];
        user.wrong = [NSNumber numberWithInt:0];
        user.shareDate = [NSDate distantPast];
        user.effect = [NSNumber numberWithFloat:-1.0];
        user.music = [NSNumber numberWithFloat: -1.0];
	}
	return user;
	

}

-(void)initGameCoreDataWithDataArray:(NSMutableArray *)array{
    
    UserData *userData = [self fetchEntity:@"UserData" withPredicate:nil];
    
    int gameNumber = [userData.totalLevelNumber integerValue] + 1;
    
    for(NSDictionary *info in array)
    {
        GameData *game = nil;
        @try {
            game = [self fetchEntity:@"GameData" withPredicate:[NSPredicate predicateWithFormat:@"gameId == %@",[info objectForKey:@"id"]]];
            game.gameId = [info objectForKey:@"id"];
            game.answer = [info objectForKey:@"answer"];
            game.imageName = [info objectForKey:@"imageAddress"];
            game.options = [info objectForKey:@"options"];
            game.number = [NSNumber numberWithInt:gameNumber];

        }
        @catch (NSException *exception) {
            if(game)
                [_managedObjectContext deleteObject:game];
        }
        @finally {
            
        }
        
        gameNumber ++;
    }
    
    userData.totalLevelNumber = [NSNumber numberWithInt:gameNumber - 1];
    [self saveContext];
    
}

- (void)initAchDataWithDataArray:(NSArray*)array{
    
    for(NSDictionary *info in array)
    {
        Achievement *ach = nil;
        @try {
            ach = [self fetchEntity:@"Achievement" withPredicate:[NSPredicate predicateWithFormat:@"achId == %@",[info objectForKey:@"id"]]];
            ach.title = [info objectForKey:@"title"];
            ach.type = [NSNumber numberWithInt:[[info objectForKey:@"type"] intValue]];
            ach.need = [NSNumber numberWithInt:[[info objectForKey:@"need"] intValue]];
            ach.text = [info objectForKey:@"description"];
            ach.achId = [NSNumber numberWithInt:[[info objectForKey:@"id"]intValue]];
            ach.complete = ach.complete.boolValue ? ach.complete : [NSNumber numberWithBool:NO];
            ach.needText = [info objectForKey:@"needText"];
        }
        @catch (NSException *exception) {
            if(ach)
                [_managedObjectContext deleteObject:ach];
        }
        @finally {

        }
        
    }
    
    [self saveContext];
}

//打乱数组
- (void)randArray:(NSMutableArray *)ary{
    NSUInteger count = [ary count];//5
    for (NSUInteger i = 0; i < count; ++i) {//i=0-4
        int nElements = count-i;//e=5-1
        int n = (arc4random() % nElements) + i;
        [ary exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(UserData *)fetchUserData{
    UserData *userdata = [self fetchEntity:@"UserData" withPredicate:nil];
    return userdata;
}

#pragma add count

//获得的金币
- (NSInteger)addGameCoins:(NSInteger)coinsCount{
    [self addCollectedGold:coinsCount];
    UserData *user = [self fetchUserData];
    NSInteger coins = user.currentGold.longValue + coinsCount;
    user.currentGold = [NSNumber numberWithLong:coins];
    if (coins >= 0) {
        //检查
        [[AchManager sharedAchManager] checkCurrentGold];
    }
    return coins;
}

//获得过的金币
- (void)addCollectedGold:(NSInteger)gold{
    if (gold <= 0) {
        return;
    }
    UserData *user = [self fetchUserData];
    user.collectedGold = [NSNumber numberWithInt:user.collectedGold.integerValue + gold];
    [[AchManager sharedAchManager]checkGetGold];
}

//关数增加
- (NSInteger)addGameLevelCounts:(NSInteger)count{
    UserData *user = [self fetchUserData];
    NSInteger lv = user.currentLv.intValue + count;
    user.currentLv = [NSNumber numberWithInt:lv];
    [[AchManager sharedAchManager] checkLevel];
    return lv;
}

//错误次数
-(NSInteger)addWrongNumber{
    UserData *user = [self fetchUserData];
    NSInteger wrong = user.wrongAnswer.intValue + 1;
    user.wrongAnswer = [NSNumber numberWithInt:wrong];
    [[AchManager sharedAchManager] checkWrong];
    return wrong;
}

//使用正确答案增加
- (void)addShowTure{
    UserData *user = [self fetchUserData];
    NSInteger show = user.showTrue.integerValue +1;
    user.showTrue = [NSNumber numberWithInt:show];
    [[AchManager sharedAchManager] checkUseShowTrue];
}

//分享次数增加
- (void)addShare{
    UserData *user = [self fetchUserData];
    NSInteger share = user.share.integerValue +1;
    user.share = [NSNumber numberWithInt:share];
    [[AchManager sharedAchManager] checkShared];
}

//撸次数增加
- (void)addLu{
    UserData *user = [self fetchUserData];
    NSInteger lu = user.luCount.integerValue +1;
    user.luCount = [NSNumber numberWithInt:lu];
    [[AchManager sharedAchManager] checkLu];
}

#pragma fetch coredata

- (NSArray *) fetchExistEntityList: (NSString *) entityName withPredicate: (NSPredicate *) predicate
{
    NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName: entityName inManagedObjectContext: self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	[request setPredicate: predicate];
	NSError *error= nil;
	NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];

	return array;
}

- (id ) fetchExistEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate
{
	
    
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName: entityName inManagedObjectContext: self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	[request setPredicate: predicate];
	[request setFetchLimit: 1];
	NSError *error= nil;
	NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	id  _entity = nil;
	if (array == nil || array.count <=0 )
	{
		
	}else
	{
		_entity = [array objectAtIndex: 0];
	}
	return _entity;
}

- (id ) fetchEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate
{
	id _entity = [self fetchExistEntity: entityName withPredicate: predicate];
	if (nil == _entity)
	{
		_entity =  [NSEntityDescription
					insertNewObjectForEntityForName: entityName
					inManagedObjectContext: self.managedObjectContext];
	}
	return _entity;
	
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coredata.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
