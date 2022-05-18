//
//  LuViewController.h
//  Teachers
//
//  Created by wangyutao on 14-5-19.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
//#import "DMAdView.h"
@interface LuViewController : UIViewController{
    CMMotionManager * motionManager;
//    DMAdView *_dmAdView;

}
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) CMMotionManager *motionManager;

@end
