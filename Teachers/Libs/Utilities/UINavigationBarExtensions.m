//
//  UINavigationBarExtensions.m
//  AutoShow
//
//  Created by wei on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBarExtensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (shadow)

-(void)drawRect:(CGRect)rect
{
    
    if (self.barStyle == UIBarStyleDefault)
    {
        UIImage *image = [UIImage imageNamed: @"_nav.png"];
        
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  
        self.layer.masksToBounds = NO;
        self.layer.shadowOpacity = 0.4f;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
    }else
    {
        UIImage *image = [UIImage imageNamed: @"_nav.png"];
        
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
    }
    
}

- (void)setShadow
{
//    self.layer.masksToBounds = NO;
//    self.layer.shadowOpacity = 0.7f;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    if (isRetina) {
//        self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
//    }else{
//        self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    }
//    
////    self.layer.shadowRadius =3;
    UIImage * shadowImg = [UIImage imageNamed:@"_nav_shadow.png"];
    UIImageView * shadowView = [[UIImageView alloc] initWithImage:shadowImg];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    shadowView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, shadowImg.size.height);
    [self addSubview:shadowView];
    [shadowView release];
}

@end
