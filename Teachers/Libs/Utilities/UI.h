//
//  UI.h
//  usedcar
//
//  Created by wei on 12-10-16.
//  Copyright (c) 2012年 vv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UI : NSObject {
	
}

+(void)addImageView:(NSString *)imageName view:(UIView*)view rect:(CGRect)rect tag:(NSInteger)tag;

+(void)addLabel:(NSString *)title view:(UIView *)view rect:(CGRect)rect size:(CGFloat)size align:(UITextAlignment)align tag:(NSInteger)tag;

+(void)showAlert:(NSString *)message title:(NSString *)title;

+(void)addText:(NSString *)placehoder text:(NSString *)text view:(UIView *)view rect:(CGRect)rect align:(UITextAlignment)align delegate:(id<UITextFieldDelegate>)delegate keyboardType:(UIKeyboardType)keyboardType tag:(NSInteger)tag;
@end
