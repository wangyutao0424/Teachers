//
//  AchManager.m
//  LittleFriends
//
//  Created by Wang Yutao on 13-8-27.
//  Copyright (c) 2013年 Wang Yutao. All rights reserved.
//

#import "AchManager.h"
#import "Config.h"
#import "DataEngine.h"
#import "AchAlertView.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "WXShare.h"

@implementation AchManager
@synthesize achList,completeList,uncompleteList;

static AchManager *achManager=nil;

+(AchManager *)sharedAchManager{
    @synchronized(self){
        if (achManager==nil) {
            achManager=[[AchManager alloc]init];
        }
    }
    return achManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (achManager == nil)
        {
            achManager = [super allocWithZone:zone];
            return  achManager;
        }
    }
    return  nil;
}

-(void)dealloc{
    self.achList = nil;
    self.completeList = nil;
    self.uncompleteList = nil;
    [super dealloc];
}

-(id)init{
    self=[super init];
    if (self) {
        self.achList = [[DataEngine sharedDataEngine] fetchExistEntityList:@"Achievement" withPredicate:nil];
        self.completeList = [NSMutableArray arrayWithArray:[self.achList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"complete == %@",[NSNumber numberWithBool:YES]]]];
        self.uncompleteList = [NSMutableArray arrayWithArray:[self.achList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"complete == %@",[NSNumber numberWithBool:NO]]]];
    }
    return self;
}

-(void)setAchDataComplete:(Achievement *)achData{
    achData.complete = [NSNumber numberWithBool:YES];
    [[DataEngine sharedDataEngine]saveContext];
    [self.completeList addObject:achData];
    [self.uncompleteList removeObject:achData];
}

- (void)showAlertWithData:(Achievement*)ach{
    AchAlertView *alert = [[AchAlertView alloc]initWithAchData:ach];
    [alert initLeftButtonWithTitle:@"分享"];
    [alert initRightButtonWithTitle:@"确定"];
    alert.delegate = self;
    [alert show];
    [alert release];
}

-(void)alertView:(CustomAlertView *)alertView clickIndex:(int)index{
    [self shareWithView:alertView.superview];
}

#pragma mark - share
- (void)shareToWX:(UIView*)view {
    [WXShare shareToWXWithView:view];
}

- (void)shareToSina:(UIView *)view{
    [WXShare shareToWeiboWithView:view];
}

-(void)shareWithView:(UIView*)view{
    NSLog(@"分享");
    NSArray *btns = [NSArray arrayWithObjects:@"分享到微信", @"分享到新浪微博", nil];
    
    [UIActionSheet actionSheetWithTitle:@"每日第一次分享可奖励20软妹币呦~" message:nil buttons:btns showInView:view onDismiss:^(int buttonIndex){
        
        
        if (buttonIndex == 0) {
            [self shareToWX:view];
        } else if (buttonIndex == 1) {
            [self shareToSina:view];
        }
        
    } onCancel:^{
        
    }];
    
    
}



-(void)checkLevel{
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==0"];//0是关
    NSArray *array=[self.uncompleteList filteredArrayUsingPredicate:pre];
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if ([ach.need integerValue]==userData.currentLv.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }
}

-(void)checkUseShowTrue{
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==1"];//1是使用showtrue
    
    NSArray *array=[self.uncompleteList filteredArrayUsingPredicate:pre];
    
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if ([ach.need integerValue] <= userData.showTrue.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }
}

-(void)checkCurrentGold{
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==2"];//2是当前金币
    
    NSArray *array=[self.uncompleteList filteredArrayUsingPredicate:pre];
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if ([ach.need integerValue] <= userData.currentGold.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }
}

-(void)checkGetGold{
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==3"];//3是获得的金币
    
    NSArray *array=[self.uncompleteList filteredArrayUsingPredicate:pre];
    
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if ([ach.need integerValue] <= userData.collectedGold.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }
}


-(void)checkShared{
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==4"];//4是分享次数
    
    NSArray *array=[self.uncompleteList filteredArrayUsingPredicate:pre];
    
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if ([ach.need integerValue] <= userData.share.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }
}

-(void)checkWrong{
    
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==5"];//5是显示红色，也就是回答错误
    
    NSArray *array=[self.uncompleteList filteredArrayUsingPredicate:pre];
    
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if ([ach.need integerValue] <= userData.wrongAnswer.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }

}



-(void)checkLu{
    if (self.uncompleteList.count == 0) {
        return;
    }
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"type==6"];//6撸
    NSArray *array = [self.uncompleteList filteredArrayUsingPredicate:pre];
    if ([array count]) {
        UserData *userData = [[DataEngine sharedDataEngine]fetchUserData];
        for (Achievement *ach in array) {
            if (ach.need.integerValue == userData.luCount.integerValue) {
                [self setAchDataComplete:ach];
                [self showAlertWithData:ach];
                break;
            }
        }
    }
}

@end
