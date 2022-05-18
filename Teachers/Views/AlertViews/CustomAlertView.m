//
//  CustomAlertView.m
//  Teachers
//
//  Created by wangyutao on 14-5-13.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIImage+Additions.h"

@implementation CustomAlertView
@synthesize bgView,leftBtn,rightBtn;
@synthesize delegate;

-(id)initCustomAlertViewWithBgFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        bgView = [[UIView alloc]initWithFrame:frame];
        bgView.backgroundColor = BgColor_Green;
        [self addSubview:bgView];
        [bgView release];
    }
    return self;
}

-(void)initLeftButtonWithTitle:(NSString *)title{
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(35, bgView.frame.size.height - 50, 70, 30);
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:BgColor_Green forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont fontWithName:FZFontName size:15];
    [leftBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Egg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = kTagLeftBtn;
    [bgView addSubview:leftBtn];
}

-(void)initRightButtonWithTitle:(NSString *)title{
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(135, bgView.frame.size.height - 50, 70, 30);
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:BgColor_Green forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:FZFontName size:15];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Egg] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = kTagRightBtn;
    [bgView addSubview:rightBtn];
}

-(void)initCenterButtonWithTitle:(NSString *)title{
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.frame = CGRectMake((bgView.frame.size.width - 70)/2, bgView.frame.size.height - 50, 70, 30);
    [centerBtn setTitle:title forState:UIControlStateNormal];
    [centerBtn setTitleColor:BgColor_Green forState:UIControlStateNormal];
    centerBtn.titleLabel.font = [UIFont fontWithName:FZFontName size:15];
    [centerBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Egg] forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(clickCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    centerBtn.tag = kTagRightBtn;
    [bgView addSubview:centerBtn];
}

- (void)clickLeftBtn:(UIButton*)btn{
    
}

- (void)clickRightBtn:(UIButton*)btn{
    
}

-(void)clickCenterBtn:(UIButton*)btn{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)show{
    [[AlertQueue sharedAlertQueue] addAlertQueque:self];
}

-(void)closeAlert{
    [[AlertQueue sharedAlertQueue] removeAlert:self];
}

-(void)removeFromSuperview{
    NSLog(@"remove");
    [super removeFromSuperview];
}


@end
