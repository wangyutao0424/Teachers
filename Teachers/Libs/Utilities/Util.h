//
//  Util.h
//  BrandHome
//
//  Created by  on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}
+ (float)systemVer;

+ (NSString*) cleanPhoneNumber:(NSString*)phoneNumber;
+ (void )makeCall:(NSString *)phoneNumber;
+ (BOOL)isIPadOrIpod;
+ (BOOL)isHD;
+(double)availableMemory;


+(UIButton*)barButtonWith:(UIImage*)buttonImage highlight:(UIImage*)buttonHighlightImage 
             leftCapWidth:(CGFloat)capWidth title:(NSString*)text withInsets:(UIEdgeInsets) insets;
+ (NSString *) platform;
+ (NSString*) stringWithUUID;

//给app打分
+ (void)rankWithAppleId:(NSInteger)appleId;

@end