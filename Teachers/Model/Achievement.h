//
//  Achievement.h
//  Teachers
//
//  Created by Wang Yutao on 14-5-18.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * need;
@property (nonatomic, retain) NSNumber * achId;
@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) NSString * needText;
@end
