//
//  AnswerButton.h
//  Teachers
//
//  Created by Wang Yutao on 14-4-7.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAnimatableLabel.h"

@interface AnswerButton : UIButton
{
    AUIAnimatableLabel *animateLabel;
}

@property (nonatomic ,retain) AUIAnimatableLabel *animateLabel;
@end
