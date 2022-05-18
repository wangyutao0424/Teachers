//
//  AchManager.h
//  LittleFriends
//
//  Created by Wang Yutao on 13-8-27.
//  Copyright (c) 2013年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Achievement.h"
#import "UserData.h"
#import "CustomAlertView.h"

@interface AchManager : NSObject<CustomAlertViewDelegate>
{
	NSManagedObjectContext *managedObjectContext;
    NSArray *achList;
    NSMutableArray *completeList;
    NSMutableArray *uncompleteList;
}

@property (nonatomic, retain) NSArray *achList;
@property (nonatomic, retain) NSMutableArray *completeList;
@property (nonatomic, retain) NSMutableArray *uncompleteList;

+(AchManager *)sharedAchManager;
-(void)checkLu;
-(void)checkLevel;
-(void)checkCurrentGold;
-(void)checkGetGold;
-(void)checkShared;
-(void)checkWrong;
-(void)checkUseShowTrue;

-(void)setAchDataComplete:(Achievement *)achData;

@end
