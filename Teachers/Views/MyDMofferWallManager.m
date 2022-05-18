//
//  MyDMofferWallManager.m
//  Teachers
//
//  Created by wangyutao on 14-5-22.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "MyDMofferWallManager.h"
#import "DataEngine.h"
#import "TextAlertView.h"

@implementation MyDMofferWallManager
static MyDMofferWallManager *myDMofferWallManager = nil;

+ (MyDMofferWallManager *)sharedMyDMofferWallManager{
    @synchronized(self){
        if (myDMofferWallManager==nil) {
            myDMofferWallManager=[[MyDMofferWallManager alloc]initWithPublisherID:DMWallPublisherID];
//            myDMofferWallManager.delegate = myDMofferWallManager;
        }
    }
    return myDMofferWallManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (myDMofferWallManager == nil)
        {
            myDMofferWallManager = [super allocWithZone:zone];
            return  myDMofferWallManager;
        }
    }
    return  nil;
}

//- (void)dmOfferWallManager:(DMOfferWallManager *)manager
//        receivedTotalPoint:(NSNumber *)totalPoint
//        totalConsumedPoint:(NSNumber *)consumedPoint{
//    wallValue = totalPoint.integerValue - consumedPoint.integerValue;
//    
//    if (wallValue > 0) {
//        [self consumeWithPointNumber:wallValue];
//    }
//}
//
//- (void)dmOfferWallManager:(DMOfferWallManager *)manager
//    consumedWithStatusCode:(DMOfferWallConsumeStatus)statusCode
//                totalPoint:(NSNumber *)totalPoint
//        totalConsumedPoint:(NSNumber *)consumedPoint{
//    if (statusCode == eDMOfferWallConsumeSuccess) {
//        [[DataEngine sharedDataEngine] addGameCoins:wallValue];
//        [[DataEngine sharedDataEngine] saveContext];
//        TextAlertView *alert = [[TextAlertView alloc]initWithText:[NSString stringWithFormat:@"恭喜您从积分墙撸到%d软妹币！",wallValue]];
//        [alert initCenterButtonWithTitle:@"确定"];
//        [alert show];
//        [alert release];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCoins" object:nil userInfo:nil];
//    }
//    
//    
//}




@end
