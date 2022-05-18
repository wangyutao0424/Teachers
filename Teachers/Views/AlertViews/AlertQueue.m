//
//  AlertQueue.m
//  Teachers
//
//  Created by wangyutao on 14-5-21.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "AlertQueue.h"
#import "AppDelegate.h"

@implementation AlertQueue

DEF_SINGLETION(AlertQueue);

-(void)dealloc{
    [alertList release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        alertList = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return self;
}


- (void)addAlertQueque:(UIView *)alert{
//    if ([alertList count]) {
//        [[alertList firstObject] removeFromSuperview];
//    }
//    [alertList insertObject:alert atIndex:0];
//    UIWindow *window = [self getMainWindow];
//    [window addSubview:alert];
    if ([alertList count]==0) {
        UIWindow *window = [self getMainWindow];
        [window addSubview:alert];
    }
    [alertList addObject:alert];

}

- (void)removeAlert:(UIView *)alert{
    if ([alertList count]) {
        UIView *first = [alertList firstObject];
        [alertList removeObject:alert];
        if (first == alert) {
            [first removeFromSuperview];
            if ([alertList count] > 0) {
                first = [alertList objectAtIndex:0];
                UIWindow *window = [self getMainWindow];
                [window addSubview:first];
            }
        }
    }
}

- (UIWindow*)getMainWindow{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return app.window;
}

@end
