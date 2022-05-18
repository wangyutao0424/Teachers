//
//  MapCell.m
//  Teachers
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "MapCell.h"

@implementation MapCell
@synthesize btn1,btn2,btn3,btn4,btn5;
@synthesize btnArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(15, 10, 50, 50);
        [self addSubview:btn1];
        
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(75, 10, 50, 50);
        [self addSubview:btn2];
        
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(135, 10, 50, 50);
        [self addSubview:btn3];
        
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(195, 10, 50, 50);
        [self addSubview:btn4];
        
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.frame = CGRectMake(255, 10, 50, 50);
        [self addSubview:btn5];
        
        btnArray = [[NSArray alloc]initWithObjects:btn1,btn2,btn3,btn4,btn5, nil];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [super dealloc];
    [btnArray release];
}

@end
