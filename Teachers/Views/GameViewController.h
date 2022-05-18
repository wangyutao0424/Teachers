//
//  GameViewController.h
//  Teachers
//
//  Created by Wang Yutao on 14-4-1.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"
#import <CoreData/CoreData.h>
#import "WinAlertView.h"
#import "DataEngine.h"
//#import "DMAdView.h"
#import "CustomAlertView.h"
#import "MyDMofferWallManager.h"

@interface GameViewController : UIViewController<CustomAlertViewDelegate>{
    UILabel *topTitle;
    UIButton *backBtn;
    UIButton *coinsBtn;
    UIButton *shareBtn;
    UIButton *showTrueBtn;
    
    int gameNumber;
    NSManagedObjectContext *managedObjectContext;
    UIImageView *gamePic;
    
    NSMutableArray *chooseArray;
    NSMutableArray *optionArray;
    GameData *game;
    DataEngine *dataEngine;
    
//    DMAdView *_dmAdView;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSTimer *colorTimer;
@property (nonatomic, retain) GameData *game;

- (id)initWithGameNumber:(int)number;

@end
