//
//  UI.m
//  usedcar
//
//  Created by wei on 12-10-16.
//  Copyright (c) 2012年 vv. All rights reserved.
//

#import "UI.h"

@implementation UI

//添加图片
+(void)addImageView:(NSString *)imageName view:(UIView*)view rect:(CGRect)rect tag:(NSInteger)tag
{
	if (imageName == nil) {
		return;
	}
	
	UIImage *image;
	if ([imageName isAbsolutePath] && [[NSFileManager defaultManager] fileExistsAtPath:imageName]) {
		image = [UIImage imageWithContentsOfFile:imageName];
	}
	else
		image = [UIImage imageNamed:imageName];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = rect;
	imageView.tag = tag;
	[view addSubview:imageView];
	//[image release];
	[imageView release];
}

//添加文字
+(void)addLabel:(NSString *)title view:(UIView *)view rect:(CGRect)rect size:(CGFloat)size align:(UITextAlignment)align tag:(NSInteger)tag
{
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = title;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:size];
	label.textAlignment = align;
	label.tag = tag;
	[view addSubview:label];
	[label release];
}

+(void)addText:(NSString *)placehoder text:(NSString *)text view:(UIView *)view rect:(CGRect)rect align:(UITextAlignment)align delegate:(id<UITextFieldDelegate>)delegate keyboardType:(UIKeyboardType)keyboardType tag:(NSInteger)tag
{
	UITextField *tianTF = [[UITextField alloc] initWithFrame: rect];
	tianTF.tag = tag;
	tianTF.font = [UIFont systemFontOfSize:14];
	tianTF.adjustsFontSizeToFitWidth = YES;
	tianTF.text = text;
	tianTF.delegate = delegate;
	tianTF.keyboardType = keyboardType;
	tianTF.textAlignment = align;
	tianTF.borderStyle = UITextBorderStyleNone;
	tianTF.placeholder = placehoder;
	[view addSubview:tianTF];
}

+(void)showAlert:(NSString *)message title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: message
                                                   delegate: nil
                                          cancelButtonTitle: @"确定"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


@end
