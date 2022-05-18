//
//  GGWindow.m
//  usedcar
//
//  Created by wei on 12-11-19.
//  Copyright (c) 2012年 vv. All rights reserved.
//

#import "GGWindow.h"

@implementation GGWindow

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake )
	{
		// User was shaking the device. Post a notification named "shake".
		[[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}


@end
