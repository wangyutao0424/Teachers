//
//  AboutViewController.m
//  Teachers
//
//  Created by wangyutao on 14-6-4.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "AboutViewController.h"
//#import "UMFeedback.h"
#import "UIImage+Additions.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BgColor_Blue;
    UIImageView *bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    bar.image = [UIImage imageNamed:@"TopBar.png"];
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    [bar release];
    
    UILabel* topTitle = [[UILabel alloc]initWithFrame:CGRectMake((320 - 150)/2, 0, 150, 52)];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont fontWithName:FZFontName size:22];
    [bar addSubview:topTitle];
    topTitle.text = @"关于";
    [topTitle release];
    
    UIButton *  backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 15, 75, 21);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [backBtn setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(130, 80, 60, 60)];
    icon.image = [UIImage imageNamed:@"icon60"];
    [self.view addSubview:icon];
    [icon release];
    
    UILabel *ver = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 18)];
    ver.text = [NSString stringWithFormat:@"猜老师 %@",APP_VERSION];
    [self.view addSubview:ver];
    [ver release];
    ver.textColor = [UIColor whiteColor];
    ver.textAlignment = NSTextAlignmentCenter;
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame = CGRectMake(40, 260, 240, 40);
    [comment setBackgroundImage:[UIImage imageWithColor:BgColor_Green] forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [comment setTitle:@"求好评" forState:UIControlStateNormal];
    [comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:comment];
    
    UIButton *feedBack = [UIButton buttonWithType:UIButtonTypeCustom];
    feedBack.frame = CGRectMake(40, 320, 240, 40);
    [feedBack setBackgroundImage:[UIImage imageWithColor:BgColor_Green] forState:UIControlStateNormal];
    [feedBack addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
    [feedBack setTitle:@"意见反馈" forState:UIControlStateNormal];
    [feedBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:feedBack];
}

- (void)dismissController{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)feedBack{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
//    [UMFeedback showFeedback:self withAppkey:UMAppKey];
}

-(void)comment{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    NSString * str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",APP_APPLE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

@end
