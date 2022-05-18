//
//  UserTools.m
//  Teachers
//
//  Created by wangyutao on 14-5-14.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "UserTools.h"

@implementation UserTools

+ (UIImage *)imageFromView:(UIView *)theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    
    
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(theView.frame.size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
