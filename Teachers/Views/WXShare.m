//
//  WXShare.m
//  Teachers
//
//  Created by wangyutao on 14-5-20.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "WXShare.h"
//#import "WXApi.h"
#import "UserTools.h"

@implementation WXShare

+(void)shareToWXWithView:(UIView *)view{
//    if (![WXApi isWXAppInstalled]) {
//
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未安装最新版本微信\n是否去下载最新版微信" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去下载", nil];
//        alertView.tag = 11;
//        [alertView show];
//        [alertView release];
//
//    } else {
//        WXMediaMessage *message = [WXMediaMessage message];
//        //        [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
//
//        WXImageObject *ext = [WXImageObject object];
//
//        //原图
//        UIImage* image = [UserTools imageFromView:view];
//        ext.imageData = UIImagePNGRepresentation(image);
//
//        message.mediaObject = ext;
//        //缩略图
//        //        [message setThumbImage:nil];
//        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//        req.bText = NO;
//        req.message = message;
//        req.scene = WXSceneTimeline;
//
//        [WXApi sendReq:req];
//    }
}

+(void)shareToWeiboWithView:(UIView *)view{
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = @"测试通过WeiboSDK发送文字到微博!";
//    WBImageObject *image = [WBImageObject object];
//    image.imageData = UIImagePNGRepresentation([UserTools imageFromView:view]);
//    message.imageObject = image;
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    
//    [WeiboSDK sendRequest:request];
}

@end
