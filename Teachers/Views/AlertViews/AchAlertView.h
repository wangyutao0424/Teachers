//
//  AchAlertView.h
//  Teachers
//
//  Created by wangyutao on 14-5-20.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "CustomAlertView.h"
#import "Achievement.h"

@interface AchAlertView : CustomAlertView
{
    UIImageView *picView;
}

@property (nonatomic, retain) Achievement *achData;

- (id)initWithAchData:(Achievement*)ach;

@end
