//
//  GameViewController.m
//  Teachers
//
//  Created by Wang Yutao on 14-4-1.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "GameViewController.h"
#import "GameData.h"
#import "UserData.h"
#import "AnswerButton.h"
#import "UIActionSheet+MKBlockAdditions.h"
//#import "WXApi.h"
#import "UserTools.h"
#import "UIImage+Additions.h"
#import "TextAlertView.h"
#import "NSDate+Additions.h"
#import "ShowTrue.h"
#import "WXShare.h"
#import "GoldAlertView.h"
#import "LuViewController.h"

#define WinAlertTag 999
#define TextAlertTag 998
#define GoldAlertTag 997

@interface GameViewController (){
    BOOL isRedWord;
    int colorChangeNumber;
    CGSize winSize;
}

@end

@implementation GameViewController
@synthesize managedObjectContext;
@synthesize game;

-(void)dealloc{
//    _dmAdView.delegate = nil;
//    _dmAdView.rootViewController = nil;
//    [_dmAdView release];
//
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCoins" object:nil];
    [super dealloc];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (id)initWithGameNumber:(int)number{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        gameNumber = number;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCoins) name:@"refreshCoins" object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BgColor_Egg;
    winSize = [[UIScreen mainScreen] bounds].size;
    dataEngine = [DataEngine sharedDataEngine];
    self.managedObjectContext = dataEngine.managedObjectContext;
    chooseArray=[[NSMutableArray alloc]initWithCapacity:0];
    optionArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    //创建广告条
//    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJzYlIuNGKMq7doK" placementId:@"16TLm_ZoAphTONUEkq9LIhzk"];
//    [_dmAdView setAdSize:DOMOB_AD_SIZE_320x50];
//    _dmAdView.frame = CGRectMake(0, winSize.height - DOMOB_AD_SIZE_320x50.height, DOMOB_AD_SIZE_320x50.width,DOMOB_AD_SIZE_320x50.height);
//    _dmAdView.delegate = self;
//    _dmAdView.rootViewController = self;
//    [self.view addSubview:_dmAdView];
//    [_dmAdView loadAd];
    
    //顶部bar背景
    UIImageView *bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    bar.image = [UIImage imageNamed:@"TopBar.png"];
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    [bar release];
    
    //关数显示
    topTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 60, 52)];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont fontWithName:FZFontName size:22];
    [bar addSubview:topTitle];
    [topTitle release];
    
    //返回按钮
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 15, 75, 21);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [backBtn setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFirstVC) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    //金币按钮
    coinsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coinsBtn.frame = CGRectMake(220, 7, 100, 40);
    [coinsBtn setImage:[UIImage imageNamed:@"coins"] forState:UIControlStateNormal];
    //    [coinsBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Blue] forState:UIControlStateNormal];
    [coinsBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [coinsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [coinsBtn addTarget:self action:@selector(buyCoins) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:coinsBtn];
    
    //显示正确答案按钮
    showTrueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showTrueBtn.frame = CGRectMake(270, 100, 50, 50);
    if ([self canUseFreeShowTrue]) {
        [showTrueBtn setBackgroundImage:[UIImage imageNamed:@"showtrue1"] forState:UIControlStateNormal];
    }
    else{
        [showTrueBtn setBackgroundImage:[UIImage imageNamed:@"showtrue2"] forState:UIControlStateNormal];
    }
    [showTrueBtn addTarget:self action:@selector(clickShowTrueButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showTrueBtn];
    
    //分享按钮
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(270, 180 , 50, 50);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    //猜图图片
    gamePic = [[UIImageView alloc]initWithFrame:CGRectMake((320 - 170)/2, 80, 170, 170)];
    [self.view addSubview:gamePic];
    [gamePic release];
    
    //获取当前关数据
    self.game = [self fetchGameData];
    
    
    [self refreshUI];

    // Do any additional setup after loading the view.
}

-(void)refreshUI{
    self.game = [self fetchGameData];
        
    topTitle.text = [NSString stringWithFormat:@"%d",gameNumber];
    [coinsBtn setTitle:[NSString stringWithFormat:@"%@",[dataEngine fetchUserData].currentGold] forState:UIControlStateNormal];
    gamePic.image = [UIImage imageNamed:game.imageName];
    

    
    if (chooseArray && [chooseArray count]) {
        for (AnswerButton *btn in chooseArray) {
            [btn removeFromSuperview];
        }
        [chooseArray removeAllObjects];
    }
    
    if (optionArray && [optionArray count]) {
        for (UIButton *btn in optionArray) {
            [btn removeFromSuperview];
        }
        [optionArray removeAllObjects];
    }
    
    NSUInteger answerCount= game.answer.length;
    
    NSUInteger x= 160 - answerCount * 21;
    
    for (int i=0; i<[game.answer length]; i++) {
        AnswerButton *btn = [AnswerButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"input.png"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, winSize.height * 0.55, 40, 40);
        [btn addTarget:self action:@selector(clickAnswer:) forControlEvents:UIControlEventTouchUpInside];
        btn.animateLabel.textColor = BgColor_Green;
        btn.animateLabel.font = [UIFont fontWithName:FZFontName size:22];
        btn.tag = -1;
        [chooseArray addObject:btn];
        [self.view addSubview:btn];
        x+=42.5;
    }
    
    
    NSMutableString *opStr=[[NSMutableString alloc]initWithString:game.options];
    
    int row=2,number=0;
    for (int i=0; i<24; i++) {
        if (number>=8) {
            number=0;
            row--;
        }
        
        NSUInteger count=opStr.length;
        int n = (arc4random() % count) ;
        NSString *itemStr=[opStr substringWithRange:NSMakeRange(n, 1)];
        [opStr deleteCharactersInRange:NSMakeRange(n, 1)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"optionBg.png"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(5+number * 39, winSize.height * 0.65 + row * 39, 36, 36);
        [btn setTitle:itemStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FZFontName size:22];
        [btn addTarget:self action:@selector(clickOption:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        [optionArray addObject:btn];
        
        [self.view addSubview:btn];
        number++;
        
    }
    
    
    //处理之前使用过的showTure
    if (game.showtrues && game.showtrues.count) {
        for (ShowTrue *showtrue in game.showtrues) {
            [self freshShowTrueButtonWithIndex:showtrue.index.integerValue];
        }
    }


}

- (void)refreshCoins{
    [coinsBtn setTitle:[NSString stringWithFormat:@"%@",[dataEngine fetchUserData].currentGold] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshCoins];
}

-(GameData*)fetchGameData{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameData" inManagedObjectContext:self.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"number == %d", gameNumber];
    
    [fetchRequest setPredicate:predicate];
    [predicate release];
    [fetchRequest setEntity:entity];
    NSArray *objecs = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    GameData *data = [objecs objectAtIndex:0];
    return data;
}

#pragma mark - actions
//买金币
- (void)buyCoins{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    GoldAlertView *alert = [[GoldAlertView alloc]initGoldAlertView];
    alert.tag = GoldAlertTag;
    alert.delegate = self;
    [alert show];
    [alert release];
}

//点击选中的答案
- (void)clickAnswer:(AnswerButton *)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    if ([self checkIsAllChoose]) {
        [self changeChooseCollorToWhite];
    }
    
    if (btn.tag==-1) {
        return;
    }else{
        btn.animateLabel.text = nil;
        UIButton *option=[optionArray objectAtIndex:btn.tag];
        option.hidden=NO;
        btn.tag=-1;
    }
}
//点击下面的选项
- (void)clickOption:(UIButton *)btn{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    for (int i=0; i<[chooseArray count]; i++) {
        AnswerButton *chooseBtn=[chooseArray objectAtIndex:i];
        if (chooseBtn.tag == -1 && chooseBtn.enabled) {
            chooseBtn.animateLabel.text = btn.titleLabel.text;
            chooseBtn.tag=btn.tag;
            btn.hidden = YES    ;

            if ([self checkIsAllChoose]) {
                [self chechResult];
            }
            return;
        }
    }
}

- (void)clickShowTrueButton{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    NSString *text = nil;
    BOOL free = NO;
    if ([self canUseFreeShowTrue]) {
        text = @"免费使用";
        free = YES;
    }
    else{
        text = @"使用100软妹币显示一个正确答案";
    }
    
    TextAlertView *alert = [[TextAlertView alloc]initWithText:text];
    [alert initLeftButtonWithTitle:@"取消"];
    [alert initRightButtonWithTitle:@"确定"];
    alert.delegate = self;
    alert.tag = TextAlertTag;
    alert.isFree = free;
    [alert show];
    [alert release];
}



-(void)showARightAnswerWithSave:(BOOL)isSave index:(int)index{
    
    //都被选了得情况，一般不可能出现
    if (index==-1) {
        return;
    }
    
    if (isSave) {
        //创建，并保存当前关使用showTrue的index,
        ShowTrue *showTure = [NSEntityDescription insertNewObjectForEntityForName:@"ShowTrue" inManagedObjectContext: self.managedObjectContext];
        showTure.index = [NSNumber numberWithInt:index];
        showTure.gameId = game.gameId;
        showTure.gameData = game;
        [game addShowtruesObject:showTure];
        [dataEngine addShowTure];
        [dataEngine saveContext];
    }
    
    AnswerButton *btn=[chooseArray objectAtIndex:index];//获取可用答案栏
    
    //如果有内容，则还原第一个栏
    if (btn.tag!=-1) {
        [self clickAnswer:btn];
    }
    
    //检查答案栏中的已选答案是否有跟第一个答案栏标准答案一样的，如果是，则还原
    NSString *trueStr=[game.answer substringWithRange:NSMakeRange(index, 1)];
    for (AnswerButton *item in chooseArray) {
        if ([item.animateLabel.text isEqualToString:trueStr] && item.enabled) {
            [self clickAnswer:item];
            break;
        }
    }
    
    [self freshShowTrueButtonWithIndex:index];
    
    if ([self checkIsAllChoose]) {
        [self chechResult];
    }
}

//刷新使用showTure的index的按钮，选项和答案里的都刷新
- (void)freshShowTrueButtonWithIndex:(int)index{
    NSString *trueStr=[game.answer substringWithRange:NSMakeRange(index, 1)];
    AnswerButton *btn=[chooseArray objectAtIndex:index];//获取可用答案栏

    //把这个正确答案位置文字设成不可按的正确答案
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    btn.animateLabel.text = trueStr;
    btn.enabled = NO;
    
    //查找这个正确答案的选项中的文字，给他隐藏了
    for (UIButton *item in optionArray) {
        if ([item.titleLabel.text isEqualToString:trueStr] && !item.hidden) {
            item.hidden = YES;
            btn.tag=item.tag;
            break;
        }
    }
}


- (void)shareGame{
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



//检查所有答案栏是否都有文字
-(BOOL)checkIsAllChoose{
    for (UIButton *button in chooseArray) {
        if (button.tag==-1) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 检查正确答案
-(void)chechResult{
    if ([self checkIsTrueResult]) {
        [self win];
        return;
    }
    //不正确
    [self answerWrongAndShowRed];
}

-(BOOL)checkIsTrueResult{

    for (int i=0; i<[chooseArray count];i++) {
        AnswerButton *button=[chooseArray objectAtIndex:i];
        NSString *str=[game.answer substringWithRange:NSMakeRange(i, 1)];
        if (![button.animateLabel.text isEqualToString:str]) {
            return NO;
        }
    }
    return YES;
}

//答案错误后闪烁红字
- (void)answerWrongAndShowRed{
    if (self.colorTimer == nil) {
        self.colorTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    }
    [[DataEngine sharedDataEngine] addWrongNumber];
    [[DataEngine sharedDataEngine] saveContext];
}

- (void)changeColor{
    
    if (colorChangeNumber >= 3) {
        [self removeColorTimerAndReset];
        return;
    }
    
    for (AnswerButton *btn in chooseArray) {
        if (isRedWord) {
            btn.animateLabel.textColor = BgColor_Green;
        }
        else{
            btn.animateLabel.textColor = [UIColor redColor];
        }
    }
    colorChangeNumber ++;
    isRedWord = !isRedWord;
}

- (void)changeChooseCollorToWhite{
    if (self.colorTimer) {
        [self removeColorTimerAndReset];
    }
    for (AnswerButton *btn in chooseArray) {
        btn.animateLabel.textColor = BgColor_Green;
    }
}

- (void)removeColorTimerAndReset{
    [self.colorTimer invalidate];
    self.colorTimer = nil;
    colorChangeNumber = 0;
    isRedWord = NO;
}

//过关的处理
- (void)win{
    UserData *userData = [dataEngine fetchUserData];
    BOOL firstWin = NO;
    //处理关数，金钱等数据
    if ([userData.currentLv integerValue] == gameNumber) {
        firstWin = YES;
        [dataEngine addGameLevelCounts:1];
        [dataEngine addGameCoins:10];
    }
    else{
        [dataEngine addGameCoins:1];
    }
    //删除showTrue记录
    [game removeShowtrues:game.showtrues];
    [dataEngine saveContext];
    gameNumber += 1;
    
    WinAlertView *alert = [[WinAlertView alloc]initWithGameData:game isAddRMB:firstWin];
    alert.delegate = self;
    alert.tag = WinAlertTag;
    [alert show];
    [alert release];
}





- (void)backToFirstVC{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 使用显示正确答案
//获得一个可用的答案栏的索引
-(NSInteger)getOneEnableSpriteIndex{
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<[chooseArray count]; i++) {
        UIButton *btm=[chooseArray objectAtIndex:i];
        if (btm.enabled) {
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
    NSUInteger count=[array count];
    if (count==0){
        return -1;
    }
    
    NSUInteger index=[[array objectAtIndex:arc4random()%count]integerValue];
    
    return index;
}


- (BOOL)canUseFreeShowTrue{
    UserData *user = [dataEngine fetchUserData];
    NSInteger firstDate = [[user.showTrueTime stringWithFormat:@"yyyyMMdd"] integerValue];
    NSInteger today = [[[NSDate date] stringWithFormat:@"yyyyMMdd"] integerValue];
    return today > firstDate ? YES: NO;
}

#pragma mark - share
- (void)shareToWX {
    [WXShare shareToWXWithView:self.view];
}

- (void)shareToSina{
    [WXShare shareToWeiboWithView:self.view];
}

#pragma alertdelegate

-(void)alertView:(CustomAlertView *)alertView clickIndex:(int)index{
    if (alertView.tag == WinAlertTag) {
        if (index == kTagLeftBtn) {
            //分享
            [self shareGame];
        }
        else if (index == kTagRightBtn){
            //下一关
            UserData *user = [dataEngine fetchUserData];
            if (user.totalLevelNumber.integerValue < gameNumber) {
                TextAlertView *alert = [[TextAlertView alloc]initWithText:@"恭喜！您已经完成所有关卡！待东京下次热起来的时候，我们再见！"];
                [alert initCenterButtonWithTitle:@"确定"];
                [alert show];
                [alert release];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            [self nextGame];
        }
    }
    else if (alertView.tag == TextAlertTag){
        if (index == kTagRightBtn){
            //使用showtrue
            BOOL isFree = alertView.isFree;
            
            UserData *userData = [dataEngine fetchUserData];
            
            if (isFree) {//免费
                //记时间
                userData.showTrueTime = [NSDate date];
                [dataEngine saveContext];
                
                //改变showTure按钮图片
                if ([self canUseFreeShowTrue]) {
                    [showTrueBtn setBackgroundImage:[UIImage imageNamed:@"showtrue1"] forState:UIControlStateNormal];
                }
                else{
                    [showTrueBtn setBackgroundImage:[UIImage imageNamed:@"showtrue2"] forState:UIControlStateNormal];
                }
                
                //获取第一个可用的答案栏索引
                NSInteger index=[self getOneEnableSpriteIndex];
                
                [self showARightAnswerWithSave:YES index:index];
                
            }
            else{//花100
                
                //检查是否够100
                if ([userData.currentGold integerValue] >= 100) {
                    
                    [dataEngine addGameCoins:-100];
                    [dataEngine saveContext];
                    [self refreshCoins];
                    
                    NSInteger index=[self getOneEnableSpriteIndex];
                    
                    [self showARightAnswerWithSave:YES index:index];
                }
                else{
                //钱不够提示
                    
                    TextAlertView *alert = [[TextAlertView alloc]initWithText:@"抱歉，您的软妹币不足哦~\n您可以去每日一撸或者积分墙赚取软妹币~"];
                    [alert initCenterButtonWithTitle:@"确定"];
                    [alert show];
                    [alert release];
                }
            }
        }
    }
    else if (alertView.tag == GoldAlertTag){
        if (index == kTagLuBtn) {
            LuViewController *ach = [[LuViewController alloc]init];
            [self.navigationController presentViewController:ach animated:YES completion:nil];
            [ach release];        }
        else if (index == kTagWallBtn){
            //积分墙
//            MyDMofferWallManager *wall = [MyDMofferWallManager sharedMyDMofferWallManager];
//            [wall presentOfferWallWithType:eDMOfferWallTypeList];
        }
    }
}


- (void)nextGame{
    [self refreshUI];
}




@end
