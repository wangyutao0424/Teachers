//
//  MapViewController.h
//  Teachers
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CustomAlertView.h"

@interface MapViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,CustomAlertViewDelegate>

{
    UITableView *mainTable;
    NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
    UILabel *topTitle;
    UIButton *backBtn;
    UIButton *coinsBtn;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
