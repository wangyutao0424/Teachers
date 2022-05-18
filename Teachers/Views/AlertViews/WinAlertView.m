//
//  WinAlertView.m
//  Teachers
//
//  Created by wangyutao on 14-5-13.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "WinAlertView.h"

@implementation WinAlertView
@synthesize gameData;

-(void)dealloc{
    self.gameData = nil;
    [super dealloc];
}

-(id)initWithGameData:(GameData *)data isAddRMB:(BOOL)isAdd{
    self = [super initCustomAlertViewWithBgFrame:CGRectMake(40, ([[UIScreen mainScreen] bounds].size.height - 360)/2, 240, 360)];
    if (self) {
        self.gameData = data;
        
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
        picView.image = [UIImage imageNamed:gameData.imageName];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, bgView.frame.size.width, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:FZFontName size:15];
        name.textColor = [UIColor whiteColor];
        name.textAlignment = NSTextAlignmentCenter;
        name.text = [NSString stringWithFormat:@"%@老师",gameData.answer];
        [bgView addSubview:name];
        [name release];
        
        UILabel *jiangli = [[UILabel alloc] initWithFrame:CGRectMake(50, 265, 45, 20)];
        jiangli.backgroundColor = [UIColor clearColor];
        jiangli.font = [UIFont fontWithName:FZFontName size:15];
        jiangli.textColor = [UIColor whiteColor];
        jiangli.textAlignment = NSTextAlignmentCenter;
        jiangli.text = @"奖励：";
        [bgView addSubview:jiangli];
        [jiangli release];
        
        UILabel *rmb = [[UILabel alloc] initWithFrame:CGRectMake(85, 258, 60, 30)];
        rmb.backgroundColor = [UIColor clearColor];
        rmb.font = [UIFont fontWithName:FZFontName size:25];
        rmb.textColor = [UIColor yellowColor];
        rmb.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:rmb];
        [rmb release];
        
        UILabel *ruanmeibi = [[UILabel alloc] initWithFrame:CGRectMake(140, 265, 55, 20)];
        ruanmeibi.backgroundColor = [UIColor clearColor];
        ruanmeibi.font = [UIFont fontWithName:FZFontName size:15];
        ruanmeibi.textColor = [UIColor whiteColor];
        ruanmeibi.textAlignment = NSTextAlignmentCenter;
        ruanmeibi.text = @"软妹币";
        [bgView addSubview:ruanmeibi];
        [ruanmeibi release];
        
        [self initLeftButtonWithTitle:@"分享"];
        [self initRightButtonWithTitle:@"下一关"];
        
        if (isAdd) {
            title.text = @"正确";
            rmb.text = @"10";
        }
        else{
            title.text = @"正确<温故而知新>";
            rmb.text = @"1";
        }
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"answer_right.mp3"];
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
    //下一关
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    if (delegate && [delegate respondsToSelector:@selector(alertView:clickIndex:)]) {
        [delegate alertView:self clickIndex:btn.tag];
    }
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
