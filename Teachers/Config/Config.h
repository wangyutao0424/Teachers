//
//  Config.h
//  cocos2dtest
//
//  Created by Wang Yutao on 13-8-12.
//  Copyright (c) 2013年 Wang Yutao. All rights reserved.
//

#ifndef cocos2dtest_Config_h
#define cocos2dtest_Config_h

//===================友盟事件===================

//免费提示次数
#define UMPromptFree @"PromptFree"

//付费提示次数
#define UMPromptPay @"PromptPay"

//普通关答对次数
#define UMNormalQuestion @"NormalQuestionFinished"

//隐藏关进入次数
#define UMSecretEnter @"SecretEnter"

//隐藏关通关数
#define UMSecretFinished @"SecretFinished"

//隐藏关失败数
#define UMSecretFailed @"SecretFailed"

//分享成功次数
#define UMShared @"Shared"

//=============================================




// 根据文件路径取全路径
#define CONF_ResourcePath(filename) ([[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(filename)])

// 数据存储的基准目录
#define CONF_BaseDir_Local_Game_BaseDir [NSHomeDirectory() stringByAppendingPathComponent:@"Library/LocalGameData"]

//用户数据地址
#define CONF_BaseDir_Local_UserFile [NSHomeDirectory() stringByAppendingPathComponent:@"Library/LocalGameData/userData.plist"]

//secretKey
#define SecretKey [NSString stringWithFormat:@"BniuSB"]

#define CONF_Database_Local_Path [CONF_BaseDir_Local_Game_BaseDir stringByAppendingPathComponent:@"jp.db"]

//UserDefault
#define CONF_UD_DefDeviceToken @"userDeviceToken"

//anchorpoint
#define NormalAnchropoint ccp(0.5,0.5)

//字体
#define FZBiaoTi @"FZY1JW--GB1-0"
#define FZZhengWen @"FZLTZHUNHK--GBK1-0"
#define FontEnglish  @"Helvetica-Bold"

//color
#define NumberColor ccc3(226, 198, 184) 

//#define kSinaAppKey             @"1703839106"
//#define kSinaAppSecret          @"f7a612784ab53ce0582ff7325e04d96b"
//#define kSinaAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#define kSinaAppKey             @"4213616700"
#define kSinaAppSecret          @"7a7d7c873f17260c5b76836461c268df"
#define kSinaAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#define WXAppKey @"wxc81005a11c1d7af3"

#define DMPublisherID @"56OJzYlIuNGKMq7doK"
#define DMBannerId @"16TLm_ZoAphTONUEkq9LIhzk"
#define DMStart @"16TLm_ZoAphTONUEf6HsB_2z"
#define DMWallPublisherID @"96ZJ1Elwze3ibwTBg7"

#define UMAppKey @"537d912856240b77a20b43f8"


#define isMusicOff [[NSUserDefaults standardUserDefaults] boolForKey:@"isMusicOff"]
#define isEffectOff [[NSUserDefaults standardUserDefaults] boolForKey:@"isEffectOff"]
#endif
