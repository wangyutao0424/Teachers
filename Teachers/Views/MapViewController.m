//
//  MapViewController.m
//  Teachers
//
//  Created by Wang Yutao on 14-3-31.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "MapViewController.h"
#import "MapCell.h"
#import "DataEngine.h"
#import "UserData.h"
#import "GameData.h"
#import "GameViewController.h"
#import "UIImage+Additions.h"
#import "GoldAlertView.h"
#import "LuViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCoins" object:nil];
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCoins) name:@"refreshCoins" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:240.0/255 blue:235.0/255 alpha:1];
    self.managedObjectContext = [DataEngine sharedDataEngine].managedObjectContext;

    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    
    
    UIImageView *bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    bar.image = [UIImage imageNamed:@"TopBar.png"];
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    [bar release];
    
    topTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 60, 52)];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont fontWithName:FZFontName size:22];
    [bar addSubview:topTitle];
    [topTitle release];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 15, 75, 21);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [backBtn setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFirstVC) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    coinsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coinsBtn.frame = CGRectMake(220, 7, 100, 40);
    [coinsBtn setImage:[UIImage imageNamed:@"coins"] forState:UIControlStateNormal];
//    [coinsBtn setBackgroundImage:[UIImage imageWithColor:BgColor_Blue] forState:UIControlStateNormal];
    [coinsBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [coinsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [coinsBtn setTitle:[NSString stringWithFormat:@"%@",[[DataEngine sharedDataEngine]fetchUserData].currentGold] forState:UIControlStateNormal];
    [coinsBtn addTarget:self action:@selector(buyCoins) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:coinsBtn];
    
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, winSize.height - 60) style:UITableViewStylePlain];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    [mainTable release];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserData *user = [[DataEngine sharedDataEngine] fetchUserData];
    if (user.currentLv.integerValue > user.totalLevelNumber.integerValue) {
        topTitle.text = @"通关";
    }
    else{
        topTitle.text = [NSString stringWithFormat:@"%d",user.currentLv.intValue];
    }
    [self refreshCoins];
    [self fetch];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backToFirstVC{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [self.navigationController popViewControllerAnimated:YES];
}

//买金币
- (void)buyCoins{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    GoldAlertView *alert = [[GoldAlertView alloc]initGoldAlertView];
    alert.delegate = self;
    [alert show];
    [alert release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[fetchedResultsController sections] count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        int number = ceilf([sectionInfo numberOfObjects]/5.0);
        return number;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    MapCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[MapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIButton *btn in cell.btnArray) {
            [btn addTarget:self action:@selector(chooseGirlToStart:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    int index =  indexPath.row * 5;
    for (int i = 0 ; i<5 ; i++) {
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:index + i inSection:0];
        UIButton *btn = [cell.btnArray objectAtIndex:i];
        
        if (self.fetchedResultsController.fetchedObjects.count > index + i) {
            GameData *game = [self.fetchedResultsController objectAtIndexPath:myIndexPath];
            [btn setImage:[UIImage imageNamed:game.imageName] forState:UIControlStateNormal];
            btn.tag = [game.number intValue];
            btn.hidden = NO;
        }
        else{
            [btn setImage:nil forState:UIControlStateNormal];
            btn.hidden = YES;
        }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)chooseGirlToStart:(UIButton *)button{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    GameViewController *gameViewController = [[GameViewController alloc]initWithGameNumber:button.tag];
    [self.navigationController pushViewController:gameViewController animated:YES];
    [gameViewController release];
    
}

- (void)fetch
{
    self.fetchedResultsController = nil;
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error])
    {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error -----------------------%@, %@", error, [error userInfo]);
		//exit(-1);  // Fail
    }
    
    [mainTable reloadData];
    
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController != nil)
	{
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameData" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    
    NSPredicate * predicate = nil;
    
    UserData *userdata = [[DataEngine sharedDataEngine] fetchUserData];
    predicate = [NSPredicate predicateWithFormat: @"number <= %d", userdata.currentLv.intValue];
    
	[fetchRequest setPredicate: predicate];
	
	NSSortDescriptor *sortNumber = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    
	NSArray *sortDescriptors = nil;
    sortDescriptors =[[NSArray alloc] initWithObjects: sortNumber, nil];

    
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
	
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil  cacheName:nil];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
    [sortNumber release];
	[sortDescriptors release];
	return fetchedResultsController;
}


- (void)refreshCoins{
    [coinsBtn setTitle:[NSString stringWithFormat:@"%@",[[DataEngine sharedDataEngine] fetchUserData].currentGold] forState:UIControlStateNormal];
}

-(void)alertView:(CustomAlertView *)alertView clickIndex:(int)index{

    if (index == kTagLuBtn) {
        LuViewController *ach = [[LuViewController alloc]init];
        [self.navigationController presentViewController:ach animated:YES completion:nil];
        [ach release];        }
    else if (index == kTagWallBtn){
        //积分墙
//        MyDMofferWallManager *wall = [MyDMofferWallManager sharedMyDMofferWallManager];
//        [wall presentOfferWallWithType:eDMOfferWallTypeList];
    }

}



@end
