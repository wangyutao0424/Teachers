//
//  AchViewController.m
//  Teachers
//
//  Created by wangyutao on 14-5-19.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "AchViewController.h"
#import "DataEngine.h"
#import "Achievement.h"

@interface AchViewController ()

@end

@implementation AchViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

-(void)dealloc{
    self.fetchedResultsController = nil;
    self.managedObjectContext = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    topTitle = [[UILabel alloc]initWithFrame:CGRectMake((320 - 150)/2, 0, 150, 52)];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont fontWithName:FZFontName size:22];
    [bar addSubview:topTitle];
    [topTitle release];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 15, 75, 21);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [backBtn setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, winSize.height - 60) style:UITableViewStylePlain];
//    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    [mainTable release];
    
    [self fetch];
    
}

- (void)dismissController{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        int number = [sectionInfo numberOfObjects];
        return number;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    if (self.fetchedResultsController.fetchedObjects.count > indexPath.row) {
        Achievement *ach = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = ach.title;
        if (ach.complete.boolValue) {
            cell.detailTextLabel.text = ach.text;
            cell.textLabel.textColor = BgColor_Green;
            cell.detailTextLabel.textColor = BgColor_Green;
            cell.imageView.image = [UIImage imageNamed:@"ach"];
        }
        else{
            cell.detailTextLabel.text = ach.needText;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.imageView.image = [UIImage imageNamed:@"ach2"];
        }
    }
    else{

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



#pragma coredata fetch
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
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    NSArray * completeArray = [[sectionInfo objects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"complete == %@",[NSNumber numberWithBool:YES]]];

    NSString *str = [NSString stringWithFormat:@"成就 %d/%d",[completeArray count],[sectionInfo numberOfObjects]];
    topTitle.text = str;
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController != nil)
	{
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    
    
	NSSortDescriptor *sortNumber = [[NSSortDescriptor alloc] initWithKey:@"achId" ascending:YES];
    NSSortDescriptor *sortNumber1 = [[NSSortDescriptor alloc] initWithKey:@"complete" ascending:NO];

	NSArray *sortDescriptors = nil;
    sortDescriptors =[[NSArray alloc] initWithObjects:sortNumber,sortNumber1,  nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil  cacheName:nil];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
    [sortNumber release];
    [sortNumber1 release];
	[sortDescriptors release];
	return fetchedResultsController;
}


@end
