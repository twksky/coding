//
//  SettingViewController.m
//  AppFramework
//
//  Created by ABC on 8/10/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "SettingViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "UIView+AutoLayout.h"
#import "LocalCacheManager.h"

@interface SettingViewController ()
<
UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) UITableView   *contentTableView;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)settingSwitchChanged:(id)sender;

@end

@implementation SettingViewController

static NSInteger MessageSwitchControlTag = 1;
static NSInteger SoundSwitchControlTag = 2;
static NSInteger VibrationSwitchControlTag = 3;
static NSInteger SpeakerSwitchControlTag = 4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithTitle:@"设置" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    self.contentTableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Property

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        
        return 1;
    }
    else if (1 == section) {
        
        return 2;
    }
    else if (2 == section) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"reusableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *settingSwitch = [[UISwitch alloc] init];
        cell.accessoryView = settingSwitch;
        [settingSwitch addTarget:self action:@selector(settingSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    if (0 == [indexPath section]) {
        if (0 == [indexPath row]) {
            [cell.textLabel setText:@"接收新消息通知"];
            cell.accessoryView.tag = MessageSwitchControlTag;
            UISwitch *settingSwitch = (UISwitch *)cell.accessoryView;
            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
            [settingSwitch setOn:!options.noDisturbing animated:YES];
        }
    }
    else if (1 == [indexPath section]) {
        
        if (0 == [indexPath row]) {
            [cell.textLabel setText:@"声音"];
            cell.accessoryView.tag = SoundSwitchControlTag;
            UISwitch *settingSwitch = (UISwitch *)cell.accessoryView;
            [settingSwitch setOn:![LocalCacheManager sharedInstance].isPlayVibration animated:YES];
        }
        else if (1 == [indexPath row]) {
            [cell.textLabel setText:@"震动"];
            cell.accessoryView.tag = VibrationSwitchControlTag;
            UISwitch *settingSwitch = (UISwitch *)cell.accessoryView;
            [settingSwitch setOn:[LocalCacheManager sharedInstance].isPlayVibration animated:YES];
        }
    }
    else if (2 == [indexPath section]) {
        if (0 == [indexPath row]) {
            [cell.textLabel setText:@"使用扬声器播放声音"];
            cell.accessoryView.tag = SpeakerSwitchControlTag;
            UISwitch *settingSwitch = (UISwitch *)cell.accessoryView;
            [settingSwitch setOn:[LocalCacheManager sharedInstance].isPlayFromSpeaker animated:YES];
        }
    }
    //[EaseMob sharedInstance].deviceManager
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return @"新消息提醒";
    }
    else if (1 == section) {
        return @"请在iPhone \"设置\" - \"通知\" 中进行修改";
    }
    else if (2 == section) {
        return @"聊天设置";
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}


#pragma mark - Selector

- (void)settingSwitchChanged:(id)sender
{
    UISwitch *settingSwitchControl = (UISwitch *)sender;
    
    if (settingSwitchControl.tag == MessageSwitchControlTag) {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.noDisturbing = !settingSwitchControl.isOn;
    } else if (settingSwitchControl.tag == SoundSwitchControlTag) {
        [[LocalCacheManager sharedInstance] setPlayVibration:!settingSwitchControl.isOn];
        UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UISwitch *settingSwitch = (UISwitch *)cell.accessoryView;
        [settingSwitch setOn:!settingSwitchControl.isOn animated:YES];
    } else if (settingSwitchControl.tag == VibrationSwitchControlTag) {
        [[LocalCacheManager sharedInstance] setPlayVibration:settingSwitchControl.isOn];
        UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UISwitch *settingSwitch = (UISwitch *)cell.accessoryView;
        [settingSwitch setOn:!settingSwitchControl.isOn animated:YES];
    } else if (settingSwitchControl.tag == SpeakerSwitchControlTag) {
        [[LocalCacheManager sharedInstance] setPlayFromSpeaker:settingSwitchControl.isOn];
    }
}

@end
