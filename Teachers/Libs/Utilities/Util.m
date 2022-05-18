//
//  Util.m
//  BrandHome
//
//  Created by  on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#include <sys/sysctl.h>  
#include <mach/mach.h>


#define MAX_BACK_BUTTON_WIDTH 130.0

@implementation Util

+ (float)systemVer{
   
    return [ [[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
    NSString* number = [NSString stringWithString:phoneNumber];
    NSString* number1 = [[[[number stringByReplacingOccurrencesOfString:@" " withString:@""] 
                          stringByReplacingOccurrencesOfString:@"(" withString:@""] 
                         stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return number1;    
}

+(BOOL)isIPadOrIpod{
	NSString *ver=[UIDevice currentDevice].model;
    DebugLog(@"device model is %@", ver);
	return ([ver rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].location!=NSNotFound)||
    ([ver rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location!=NSNotFound);
}

+ (BOOL)isHD{
    NSString *ver=[UIDevice currentDevice].model;
    DebugLog(@"device model is %@", ver);
	return ([ver rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location!=NSNotFound);
}

+ (void) makeCall:(NSString *)phoneNumber
{
    if (![Util isIPadOrIpod]){
        NSString* numberAfterClear = [Util cleanPhoneNumber:phoneNumber];    
        
        NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
        DebugLog(@"make call, URL=%@", phoneNumberURL);
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
        [[UIApplication sharedApplication] openURL:phoneNumberURL];  
//        }
    }

}

+(double)availableMemory{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) 
		return NSNotFound;
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

+(UIButton*)barButtonWith:(UIImage*)buttonImage highlight:(UIImage*)buttonHighlightImage 
             leftCapWidth:(CGFloat)capWidth title:(NSString*)text withInsets:(UIEdgeInsets) insets{

    // Create stretchable images for the normal and highlighted states
    UIImage* stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    UIImage* stretchableButtonHighlightImage = [buttonHighlightImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
//
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:([UIFont smallSystemFontSize]+1)];
    
    button.titleLabel.font = [UIFont systemFontOfSize:(17)];
    button.titleLabel.textColor = Nav_color_orange;
    button.titleLabel.shadowOffset = CGSizeMake(0,0);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = insets;
    
    // Make the button as high as the passed in image
    CGFloat height = nil == buttonImage ? 44.0f:buttonImage.size.height;
    button.frame = CGRectMake(0, 0, 0, height);
    
#define DEALT 18
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:button.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, (textSize.width + DEALT) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH+10 : (textSize.width + (DEALT)+10), button.frame.size.height);
    if (textSize.width > 60) {
//        textSize = CGSizeMake(60, textSize.height);
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, textSize.width , button.frame.size.height);
    }
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:Nav_color_orange forState:UIControlStateNormal];
    [button setTitleColor:Font_color_brown forState:UIControlStateHighlighted];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    [button setBackgroundImage:stretchableButtonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:stretchableButtonHighlightImage forState:UIControlStateSelected];
    
    return button;

    
}


+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

+ (NSString *) platform
{
	
	return [self getSysInfoByName:"hw.machine"];
	
}

+ (NSString*) stringWithUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

+ (void)rankWithAppleId:(NSInteger)appleId {
    NSString * appUrl = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", appleId];
    } else {
        appUrl = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", appleId];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
}

@end