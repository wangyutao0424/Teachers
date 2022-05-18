//
//  AchAlertView.m
//  Teachers
//
//  Created by wangyutao on 14-5-20.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "AchAlertView.h"

@implementation AchAlertView

-(id)initWithAchData:(Achievement *)ach{
    self = [super initCustomAlertViewWithBgFrame:CGRectMake(40, ([[UIScreen mainScreen] bounds].size.height - 360)/2, 240, 360)];
    if (self) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bgView.frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont fontWithName:FZFontName size:20];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        
        [bgView addSubview:title];
        [title release];
        
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(120-85, 45, 170, 170)];
        bg.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:bg];
        [bg release];
        
        picView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 160, 160)];
        [bg addSubview:picView];
        [picView release];
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(15, 225, bgView.frame.size.width- 30, 60)];
        text.backgroundColor = [UIColor clearColor];
        text.font = [UIFont fontWithName:FZFontName size:15];
        text.textColor = [UIColor whiteColor];
        text.numberOfLines = 3;
        text.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:text];
        [text release];
        
        title.text = ach.title;
        picView.image = [UIImage imageNamed:@"ach_big"];
        text.text = ach.text;
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"ach.wav"];
    }
}

- (void)clickLeftBtn:(UIButton*)btn{
    //分享
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    if (delegate && [delegate respondsToSelector:@selector(alertView:clickIndex:)]) {
        [delegate alertView:self clickIndex:btn.tag];
    }
}

- (void)clickRightBtn:(UIButton*)btn{
    //关闭
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    [self closeAlert];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



@end
