//
//  AlertQueue.h
//  Teachers
//
//  Created by wangyutao on 14-5-21.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface AlertQueue : NSObject{
    NSMutableArray *alertList;
}

AS_SINGLETION(AlertQueue);

- (void)addAlertQueque:(UIView*)alert;
- (void)removeAlert:(UIView*)alert;

@end
