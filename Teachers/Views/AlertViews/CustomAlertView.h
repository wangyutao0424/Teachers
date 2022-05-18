//
//  CustomAlertView.h
//  Teachers
//
//  Created by wangyutao on 14-5-13.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertQueue.h"

typedef enum {
    kTagLeftBtn,
    kTagRightBtn,
    kTagLuBtn,
    kTagWallBtn,
}kAlertBtnTag;

@class CustomAlertView;

@protocol CustomAlertViewDelegate <NSObject>

- (void)alertView:(CustomAlertView*)alertView clickIndex:(int)index;

@end

@interface CustomAlertView : UIView{
    UIView *bgView;
    UIButton *leftBtn;
    UIButton *rightBtn;
    id<CustomAlertViewDelegate> delegate;
}
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;
@property (nonatomic, assign) id<CustomAlertViewDelegate> delegate;
@property (nonatomic) BOOL isFree;

-(id)initCustomAlertViewWithBgFrame:(CGRect)frame;

- (void)initLeftButtonWithTitle:(NSString *)title;
- (void)initRightButtonWithTitle:(NSString *)title;
- (void)initCenterButtonWithTitle:(NSString *)title;

- (void)show;
- (void)closeAlert;

@end
