//
//  TextAlertView.m
//  Teachers
//
//  Created by wangyutao on 14-5-14.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "TextAlertView.h"

@implementation TextAlertView

-(id)initWithText:(NSString *)text{
    self = [super initCustomAlertViewWithBgFrame:CGRectMake(40, ([[UIScreen mainScreen] bounds].size.height - 150)/2, 240, 150)];
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, bgView.frame.size.width - 20, 80)];
        label.font = [UIFont fontWithName:FZFontName size:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.textColor = [UIColor whiteColor];
        [bgView addSubview:label];
        [label release];
        label.text = text;
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)clickCenterBtn:(UIButton*)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    [self closeAlert];
}

- (void)clickLeftBtn:(UIButton*)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    //取消
    [self closeAlert];
}

- (void)clickRightBtn:(UIButton*)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    //确定
    if (delegate && [delegate respondsToSelector:@selector(alertView:clickIndex:)]) {
        [delegate alertView:self clickIndex:btn.tag];
    }
    [self closeAlert];
}

@end
