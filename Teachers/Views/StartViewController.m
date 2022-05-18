//
//  StartViewController.m
//  Teachers
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "StartViewController.h"
#import "MapViewController.h"
#import "AUIAnimatableLabel.h"
#import "AchViewController.h"
#import "LuViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

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
    
    self.view.backgroundColor = [UIColor colorWithRed:176.0/255 green:210.0/255 blue:233.0/255 alpha:1];
    
    UIImageView *cai = [[UIImageView alloc]initWithFrame:CGRectMake(100, 50, 50, 50)];
    cai.backgroundColor = [UIColor clearColor];
    cai.image = [UIImage imageNamed:@"cai"];
    [self.view addSubview:cai];
    [cai release];
    
    UIImageView *lao = [[UIImageView alloc]initWithFrame:CGRectMake(110, 140, 50, 50)];
    lao.image = [UIImage imageNamed:@"lao"];
    [self.view addSubview:lao];
    [lao release];
    
    UIImageView *shi = [[UIImageView alloc]initWithFrame:CGRectMake(105, 220, 50, 50)];
    shi.image = [UIImage imageNamed:@"shi"];
    [self.view addSubview:shi];
    [shi release];
    
    UIImageView *girl = [[UIImageView alloc]initWithFrame:CGRectMake(150, 50, 100, 240)];
    girl.image = [UIImage imageNamed:@"girl"];
    [self.view addSubview:girl];
    [girl release];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake((320 - 150)/2, 330, 150, 50);
    [startBtn setBackgroundImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *achBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    achBtn.frame = CGRectMake((320 - 150)/2, 400, 150, 50);
    [achBtn setBackgroundImage:[UIImage imageNamed:@"achBtn"] forState:UIControlStateNormal];
    [achBtn addTarget:self action:@selector(showAch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:achBtn];
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(0 , self.view.bounds.size.height - 50, 50, 50);
    [aboutBtn setBackgroundImage:[UIImage imageNamed:@"aboutBtn"] forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutBtn];
    
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    soundBtn.frame = CGRectMake(self.view.bounds.size.width - 50, self.view.bounds.size.height - 50, 50, 50);
    [soundBtn setBackgroundImage:[UIImage imageNamed:@"soundBtn"] forState:UIControlStateNormal];
    [soundBtn addTarget:self action:@selector(showSound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundBtn];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"tokyohot.mp3"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startGame{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    MapViewController *map = [[MapViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
    [map release];
}

- (void)showAch{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    AchViewController *ach = [[AchViewController alloc]init];
    [self.navigationController presentViewController:ach animated:YES completion:nil];
    [ach release];
}

- (void)showAbout{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    AboutViewController *about = [[AboutViewController alloc]init];
    [self.navigationController presentViewController:about animated:YES completion:nil];
    [about release];
}

-(void)showSound{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    SettingViewController *set = [[SettingViewController alloc]init];
    [self addChildViewController:set];
    [set release];
    CGRect rect = set.view.frame;
    set.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, set.view.frame.size.width, set.view.frame.size.height);
    [self.view addSubview:set.view];
    [UIView animateWithDuration:0.3 animations:^{
        set.view.frame = rect;
    }];
    
}
@end
