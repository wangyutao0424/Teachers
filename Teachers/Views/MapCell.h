//
//  MapCell.h
//  Teachers
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCell : UITableViewCell{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    NSArray *btnArray;

}

@property (nonatomic,retain) UIButton *btn1;
@property (nonatomic,retain) UIButton *btn2;
@property (nonatomic,retain) UIButton *btn3;
@property (nonatomic,retain) UIButton *btn4;
@property (nonatomic,retain) UIButton *btn5;
@property (nonatomic, retain) NSArray *btnArray;


@end
