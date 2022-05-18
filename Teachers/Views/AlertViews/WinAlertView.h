//
//  WinAlertView.h
//  Teachers
//
//  Created by wangyutao on 14-5-13.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "CustomAlertView.h"
#import "GameData.h"

@interface WinAlertView : CustomAlertView{
    UIImageView *picView;
}

@property (nonatomic, retain) GameData *gameData;

- (id)initWithGameData:(GameData *)data isAddRMB:(BOOL)isAdd;

@end
