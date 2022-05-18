//
//  LuViewController.m
//  Teachers
//
//  Created by wangyutao on 14-5-19.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "LuViewController.h"
#import "DataEngine.h"
#import "NSDate+Additions.h"
#import "UserData.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "WXShare.h"
#import "AchManager.h"

@interface LuViewController ()
{
    BOOL isUp;
    int coinsCount;
    UILabel *totalCoins;
    CGSize winSize;
    int second;
    UILabel * timeLeft;
    UILabel * result;
}
@end

@implementation LuViewController
@synthesize motionManager;

-(void)dealloc{
    self.motionManager = nil;
//    _dmAdView.delegate = nil;
//    _dmAdView.rootViewController = nil;
//    [_dmAdView release];
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        second = 20;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BgColor_Egg;
    
    winSize = [[UIScreen mainScreen] bounds].size;
    
    UIImageView *bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    bar.image = [UIImage imageNamed:@"TopBar.png"];
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    [bar release];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 17, 60, 21);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFirstVC) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(320 - 40, 8, 42, 40);
    [share setImage:[UIImage imageNamed:@"luShare"] forState:UIControlStateNormal];
    [share setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 14)];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:share];
    
    UILabel * topTitle = [[UILabel alloc]initWithFrame:CGRectMake((320 - 150)/2, 0, 150, 52)];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.backgroundColor = [UIColor clearColor];
    topTitle.font = [UIFont fontWithName:FZFontName size:22];
    [bar addSubview:topTitle];
    [topTitle release];
    topTitle.text = @"撸撸软妹币";
    
    
    result = [[UILabel alloc]initWithFrame:CGRectMake(40, 130, 240, 90)];
    result.textColor = [UIColor redColor];
    result.textAlignment = NSTextAlignmentCenter;
    result.numberOfLines = 3;
    result.backgroundColor = BgColor_Blue;
    result.font = [UIFont fontWithName:FZFontName size:25];
    [self.view addSubview:result];
    [result release];
    result.hidden = YES;

    timeLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 58, 90, 30)];
    timeLeft.textColor = [UIColor redColor];
    timeLeft.textAlignment = NSTextAlignmentCenter;
    timeLeft.backgroundColor = BgColor_Blue;
    timeLeft.font = [UIFont fontWithName:FZFontName size:18];
    [self.view addSubview:timeLeft];
    [timeLeft release];
    
    totalCoins = [[UILabel alloc]initWithFrame:CGRectMake((320 - 200)/2, 80, 200, 50)];
    totalCoins.textColor = [UIColor colorWithRed:195.0/255 green:142.0/255 blue:49.0/255 alpha:1];
    totalCoins.backgroundColor = [UIColor clearColor];
    totalCoins.textAlignment = NSTextAlignmentCenter;
    totalCoins.font = [UIFont fontWithName:FZFontName size:35];
    [self.view addSubview:totalCoins];
    [totalCoins release];
    totalCoins.text = @"0";
    
    motionManager = [[CMMotionManager alloc] init];
    
    
    UIButton *luBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    luBtn.frame = CGRectMake((320 - 150)/2, winSize.height - 50 -50 -100, 150, 50);
    [luBtn setImage:[UIImage imageNamed:@"startLu.png"] forState:UIControlStateNormal];
    [luBtn addTarget:self action:@selector(startLu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:luBtn];

    UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake((320 - 280)/2, winSize.height - 50 - 90, 280, 80)];
    text.textColor = BgColor_Green;
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.numberOfLines = 0;
    text.font = [UIFont fontWithName:FZFontName size:15];
    [self.view addSubview:text];
    [text release];
    
    if ([self canUseLu]) {
        text.text = @"每天可撸一次哦~握紧手机上下方向撸即可有机会获得软妹币，撸的越快软妹币越多哦~点击按钮后开始。";
        timeLeft.text = @"剩余:20秒";
    }
    else{
        text.text = @"今天您已经撸过，为了您的健康，每天只能撸一次哦~";
        timeLeft.hidden = YES;
        luBtn.hidden = YES;
    }
    
    //创建广告条
//    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJzYlIuNGKMq7doK" placementId:@"16TLm_ZoAphTONUEkq9LIhzk"];
//    [_dmAdView setAdSize:DOMOB_AD_SIZE_320x50];
//    _dmAdView.frame = CGRectMake(0, winSize.height - DOMOB_AD_SIZE_320x50.height, DOMOB_AD_SIZE_320x50.width,DOMOB_AD_SIZE_320x50.height);
//    _dmAdView.rootViewController = self;
//    [self.view addSubview:_dmAdView];
//    [_dmAdView loadAd];
}

- (BOOL)canUseLu{
    UserData *user = [[DataEngine sharedDataEngine] fetchUserData];
    NSInteger firstDate = [[user.useLuTime stringWithFormat:@"yyyyMMdd"] integerValue];
    NSInteger today = [[[NSDate date] stringWithFormat:@"yyyyMMdd"] integerValue];
    return today > firstDate ? YES: NO;
}

-(void)startLu:(UIButton *)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    if (![self canUseLu]) {
        return;
    }
    btn.hidden = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    
    if ([motionManager isAccelerometerAvailable]){
        
        NSOperationQueue *queue = [NSOperationQueue currentQueue];
        
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

            if (isUp) {
                if (accelerometerData.acceleration.y < - 0.1) {
                    isUp = NO;
                    [self randomCoins];
                }
            }
            else{
                if (accelerometerData.acceleration.y > 0.1) {
                    isUp = YES;
//                    [self randomCoins];
                }
            }
        }];
    }
}

- (void)changeTime{
    second -- ;
    timeLeft.text = [NSString stringWithFormat:@"剩余:%d秒",second];
    if (second == 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self isFinishedLu];
    }
    
}

-(void)isFinishedLu{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //停止
    [motionManager stopAccelerometerUpdates];
    
    //今天撸完记时间
    UserData *user = [[DataEngine sharedDataEngine] fetchUserData];
    user.useLuTime = [NSDate date];
    
    //加钱,加撸
    
    [[DataEngine sharedDataEngine] addGameCoins:coinsCount];
    [[DataEngine sharedDataEngine] addLu];
    [[DataEngine sharedDataEngine] saveContext];
    
    if (coinsCount) {
        result.text = [NSString stringWithFormat:@"恭喜您！\n撸到%d枚软妹币\n快去炫耀一下吧！",coinsCount];
    }
    else{
        result.text = [NSString stringWithFormat:@"真遗憾…\n您没有撸到软妹币\n再接再厉哦!"];
    }
    result.hidden = NO;
}

-(void)randomCoins{
    int n = [self randomNumber];
    int fontSize = [self fetchFontSizeWithCoins:n];
    
    if (n == 0) {
        return;
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"marriocoins.mp3"];
    
    coinsCount += n;
    totalCoins.text = [NSString stringWithFormat:@"%d",coinsCount];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    label.text = [NSString stringWithFormat:@"+ %d",n];
    label.textColor = [UIColor colorWithRed:195.0/255 green:142.0/255 blue:49.0/255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:FZFontName size:fontSize];
    [self addCoinsLabel:label];
    
}

- (int)randomNumber{
    int n = arc4random() % 150;
    if (n == 100) {
        return 100;
    }
    else if (n == 99 || n == 98){
        return 50;
    }
    else if (n <= 97 && n >= 94){
        return 10;
    }
    else if (n <= 93 && n >= 89){
        return 5;
    }
    else if (n <= 88 && n >= 78){
        return 1;
    }
    return 0;
}

- (int)fetchFontSizeWithCoins:(int)coin{
    if (coin ==100) {
        return 28;
    }
    else if (coin == 50){
        return 25;
    }
    else if (coin == 10){
        return 22;
    }
    else if (coin == 5){
        return 19;
    }
    else{
        return 16;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addCoinsLabel:(UILabel *)label{
    int x = arc4random()%100 - 50;
    int y = arc4random()%80 - 40;
    label.frame = CGRectMake((320 - label.frame.size.width)/2 + x, winSize.height * 0.42 + y, label.frame.size.width, label.frame.size.height);
    [self.view addSubview:label];
    [UIView animateWithDuration:2.5 animations:^{
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y - 60, label.frame.size.width, label.frame.size.height);
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [label release];
    }];
}

- (void)backToFirstVC{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - share
- (void)shareToWX {
    [WXShare shareToWXWithView:self.view];
}

- (void)shareToSina{
    [WXShare shareToWeiboWithView:self.view];
}

-(void)share{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    NSArray *btns = [NSArray arrayWithObjects:@"分享到微信", @"分享到新浪微博", nil];
    
    [UIActionSheet actionSheetWithTitle:@"每日第一次分享可奖励20软妹币呦~" message:nil buttons:btns showInView:self.view onDismiss:^(int buttonIndex){
        
        
        if (buttonIndex == 0) {
            [self shareToWX];
        } else if (buttonIndex == 1) {
            [self shareToSina];
        }
        
    } onCancel:^{
        
    }];
    

}


@end
