//
//  AppDelegate.m
//  Teachers
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"
#import "DataEngine.h"
#import "AchManager.h"
#import "NSDate+Additions.h"
//#import "MobClick.h"
#import "MyDMofferWallManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [application setStatusBarHidden:YES withAnimation:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [DataEngine sharedDataEngine];
    [AchManager sharedAchManager];

    //注册微信
//    [WXApi registerApp:@"wxc81005a11c1d7af3"];
//    
//    //注册微博
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:kSinaAppKey];
//    
//    //注册友盟
//    [MobClick startWithAppkey:UMAppKey reportPolicy:SEND_INTERVAL   channelId:nil];
//    [MobClick checkUpdate];
//    [MobClick updateOnlineConfig];

    
    [self setSound];
    
    StartViewController *start = [[StartViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:start];
    [self.window setRootViewController:nav];
    [start release];
    
    [self.window makeKeyAndVisible];
    
    //开屏广告
//    _splashAd = [[DMSplashAdController alloc]  initWithPublisherId:@"56OJzYlIuNGKMq7doK" placementId:@"16TLm_ZoAphTONUEf6HsB_2z" window:self.window];
//    _splashAd.delegate = self;
//
//    if (_splashAd.isReady)
//    {
//        [_splashAd present];
//    }
    
    return YES;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    [WeiboSDK handleOpenURL:url delegate:self];
//    return  [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    [WeiboSDK handleOpenURL:url delegate:self];
//    return  [WXApi handleOpenURL:url delegate:self];
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[MyDMofferWallManager sharedMyDMofferWallManager] checkOwnedPoint];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(void) onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        if (resp.errCode == 0) {
//            //发送成功
//            [self shareSuccess];
//        }
//        else{
//            //发送失败
//            [self shareFaild];
//        }
//    }
//}
//
//-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        if ((int)response.statusCode == 0) {
//            //分享成功
//            [self shareSuccess];
//        }
//        else{
//            //分享失败
//            [self shareFaild];
//        }
//    }
//}

-(void)shareSuccess{
    BOOL isFirst = [self isTodayFirstShare];
    NSString *string = @"分享成功";
    
    if (isFirst) {
        [[DataEngine sharedDataEngine] addGameCoins:20];
        UserData *user = [[DataEngine sharedDataEngine] fetchUserData];
        user.shareDate = [NSDate date];
        [[DataEngine sharedDataEngine] saveContext];
        string = @"今日首次分享成功!\n 奖励20软妹币!";
    }
    
    [[DataEngine sharedDataEngine] addShare];
    
    TextAlertView *alert = [[TextAlertView alloc]initWithText:string];
    [alert initCenterButtonWithTitle:@"确定"];
    [alert show];
    [alert release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCoins" object:nil userInfo:nil];
}

-(void)shareFaild{
    TextAlertView *alert = [[TextAlertView alloc]initWithText:@"分享失败!"];
    [alert initCenterButtonWithTitle:@"确定"];
    [alert show];
    [alert release];
}

- (BOOL)isTodayFirstShare{
    UserData *user = [[DataEngine sharedDataEngine] fetchUserData];
    NSInteger firstDate = [[user.shareDate stringWithFormat:@"yyyyMMdd"] integerValue];
    NSInteger today = [[[NSDate date] stringWithFormat:@"yyyyMMdd"] integerValue];
    return today > firstDate ? YES: NO;
}

- (void)setSound{
    UserData *user = [[DataEngine sharedDataEngine] fetchUserData];
    
    if (user.effect.floatValue == -1.0) {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.1];
    }
    else{
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:user.effect.floatValue];
    }
    
    if (user.music.floatValue == -1.0) {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.01];
    }
    else{
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:user.music.floatValue];
    }
}

@end
