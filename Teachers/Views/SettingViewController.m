//
//  SettingViewController.m
//  Teachers
//
//  Created by Wang Yutao on 14-6-2.
//  Copyright (c) 2014年 Wang Yutao. All rights reserved.
//

#import "SettingViewController.h"
#import "DataEngine.h"
#import "UserData.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    self.view.backgroundColor = BgColor_Blue;
    UIImageView *bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    bar.image = [UIImage imageNamed:@"TopBar.png"];
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    [bar release];
    
    UILabel* topTitle = [[UILabel alloc]initWithFrame:CGRectMake((320 - 150)/2, 0, 150, 52)];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont fontWithName:FZFontName size:22];
    [bar addSubview:topTitle];
    topTitle.text = @"音量设置";
    [topTitle release];
    
    UIButton *  backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 15, 75, 21);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [backBtn setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.scrollEnabled = NO;
    [self.view addSubview:mainTable];
    [mainTable release];
}

- (void)dismissController{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        UISlider *slider;
        slider = [[UISlider alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.bounds.size.width - cell.indentationWidth * 2.0, cell.bounds.size.height)];
        slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        slider.minimumValueImage = [UIImage imageNamed:@"volumedown.png"];
        slider.maximumValueImage = [UIImage imageNamed:@"volumeup.png"];
        
        slider.maximumValue = 1.0;
        slider.minimumValue = 0.0;
        slider.value = 1.0; // in a real app you should read this value from the user defaults
        
        UserData *user = [[DataEngine sharedDataEngine]fetchUserData];
        if(indexPath.section == 0)
        {
            if (user.music.floatValue == -1) {
                slider.value = 0.01;
            }
            else{
                slider.value = user.music.floatValue;
            }
            [slider addTarget:self action:@selector(musicVolume:) forControlEvents:UIControlEventValueChanged];
            [slider addTarget:self action:@selector(musicSave) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            if (user.effect.floatValue == -1) {
                slider.value = 0.1;
            }
            else{
                slider.value = user.effect.floatValue;
            }
            [slider addTarget:self action:@selector(effectsVolume:) forControlEvents:UIControlEventTouchUpInside];
        
        }
        [cell.contentView addSubview:slider];
        [slider release];

    }
    
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
		return @"音乐";
	else if(section == 1)
		return @"音效";
	
	else return nil;
}

- (void)musicVolume:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    UserData *user = [[DataEngine sharedDataEngine]fetchUserData];
    user.music = [NSNumber numberWithFloat:slider.value];
    [[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:slider.value];
}

- (void)musicSave{
    [[DataEngine sharedDataEngine]saveContext];
}

- (void) effectsVolume:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    UISlider *slider = (UISlider *)sender;
    UserData *user = [[DataEngine sharedDataEngine]fetchUserData];
    user.effect = [NSNumber numberWithFloat:slider.value];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:slider.value];
    [[DataEngine sharedDataEngine]saveContext];

}

@end
