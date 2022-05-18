//
//  AnswerButton.m
//  Teachers
//
//  Created by Wang Yutao on 14-4-7.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "AnswerButton.h"

@implementation AnswerButton
@synthesize animateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)buttonType{
    
    AnswerButton* btn = [super buttonWithType:buttonType];
    [btn initAnswerButton];
    return btn;
}

- (void)initAnswerButton{
    animateLabel = [[AUIAnimatableLabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    animateLabel.textAlignment = NSTextAlignmentCenter;
    animateLabel.textColor = [UIColor whiteColor];
    [self addSubview:animateLabel];
    [animateLabel release];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    animateLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
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
