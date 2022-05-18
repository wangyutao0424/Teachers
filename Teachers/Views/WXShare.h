//
//  WXShare.h
//  Teachers
//
//  Created by wangyutao on 14-5-20.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WeiboSDK.h"

@interface WXShare : NSObject
+ (void)shareToWXWithView:(UIView*)view;
+ (void)shareToWeiboWithView:(UIView*)view;

@end
