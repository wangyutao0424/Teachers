//
//  GoldAlertView.m
//  Teachers
//
//  Created by wangyutao on 14-5-20.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "GoldAlertView.h"
#import "UIImage+Additions.h"
//#import "MobClick.h"

@implementation GoldAlertView

-(id)initGoldAlertView{
    self = [super initCustomAlertViewWithBgFrame:CGRectMake(40, ([[UIScreen mainScreen] bounds].size.height - 240)/2, 240, 240)];
    if (self) {
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bgView.frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont fontWithName:FZFontName size:20];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"获取软妹币";
        [bgView addSubview:title];
        [title release];
        
        UIButton *luBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        luBtn.frame = CGRectMake((bgView.frame.size.width - 70)/2, bgView.frame.size.height * 0.3, 70, 30);
        [luBtn setTitle:@"撸一撸" forState:UIControlStateNormal];
        [luBtn setTitleColor:BgColor_Green forState:UIControlStateNormal];
        luBtn.titleLabel.font = [UIFont fontWithName:FZFontName size:15];
        [luBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Egg] forState:UIControlStateNormal];
        [luBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        luBtn.tag = kTagLuBtn;
        [bgView addSubview:luBtn];
        
//        BOOL isCloseWall = NO;
//        isCloseWall = [[MobClick getConfigParams:@"isCloseWall"]boolValue];
//        if (!isCloseWall) {
//            UIButton *wallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            wallBtn.frame = CGRectMake((bgView.frame.size.width - 70)/2, bgView.frame.size.height *0.5, 70, 30);
//            [wallBtn setTitle:@"撸一墙" forState:UIControlStateNormal];
//            [wallBtn setTitleColor:BgColor_Green forState:UIControlStateNormal];
//            wallBtn.titleLabel.font = [UIFont fontWithName:FZFontName size:15];
//            [wallBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Egg] forState:UIControlStateNormal];
//            [wallBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//            wallBtn.tag = kTagWallBtn;
//            [bgView addSubview:wallBtn];
//        }
     
        [self initCenterButtonWithTitle:@"取消"];
        
    }
    return self;
}

-(void)clickBtn:(UIButton*)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    if (delegate && [delegate respondsToSelector:@selector(alertView:clickIndex:)]) {
        [delegate alertView:self clickIndex:btn.tag];
    }
    [self closeAlert];
}

-(void)clickCenterBtn:(UIButton*)btn{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
