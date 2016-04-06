//
//  ContactViewController.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ContactViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "AccountManager.h"
#import "ChatViewController.h"
#import "EXUILabel.h"
#import "ContactInfoViewController.h"
#import "ContactManager.h"
#import "ContactTableViewCell.h"

@interface ContactViewController ()
<
UITableViewDataSource, UITableViewDelegate,
IChatManagerDelegate,
ContactTableViewCellDelegate
>

@property (nonatomic, strong) EXUILabel     *totalFansCountLabel;
@property (nonatomic, strong) UITableView   *contactTableView;
//@property (nonatomic, strong) UIView        *doctorAssistantView;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)contactAvatarImageClicked:(UIGestureRecognizer *)gestureRecognizer;
- (void)doctorAssistantClicked:(UIGestureRecognizer *)gestureRecognizer;

- (void)contactChangedNotification:(NSNotification *)notification;

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"通讯录";
        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultContactTabBarNormalIcon];
        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultContactTabBarHighlightedIcon];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarWithTitle:@"通讯录" leftBarButtonItem:nil rightBarButtonItem:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    // Add Notification Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactChangedNotification:) name:kContactChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //[self.view setFrame:CGRectMake(0.0f, App_Frame_Y + self.navigationBarHeight, App_Frame_Width, App_Frame_Height - self.navigationBarHeight - kTabBarHeight)];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}


#pragma mark - Property

- (EXUILabel *)totalFansCountLabel
{
    if (!_totalFansCountLabel) {
        _totalFansCountLabel = [[EXUILabel alloc] init];
        _totalFansCountLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _totalFansCountLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalFansCountLabel.backgroundColor = UIColorFromRGB(0xedf2f1);
        _totalFansCountLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
        [_totalFansCountLabel setFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 25.0f)];
    }
    return _totalFansCountLabel;
}

- (UITableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] init];
        _contactTableView.dataSource = self;
        _contactTableView.delegate = self;
        _contactTableView.sectionIndexColor = [UIColor blackColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            
            _contactTableView.sectionIndexBackgroundColor = [UIColor whiteColor];
            
        }
        
        _contactTableView.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
        _contactTableView.tableHeaderView = self.totalFansCountLabel;
    }
    return _contactTableView;
}
/*
- (UIView *)doctorAssistantView
{
    if (!_doctorAssistantView) {
        _doctorAssistantView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 86.0f)];
        _doctorAssistantView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        
        _doctorAssistantView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doctorAssistantClicked:)];
        [_doctorAssistantView addGestureRecognizer:tapGestureRecognizer];
        
        [_doctorAssistantView addSubview:self.totalFansCountLabel];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_assistant"]];
        [_doctorAssistantView addSubview:avatarImageView];
        
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.font = [UIFont systemFontOfSize:14.0f];
        [nicknameLabel setText:@"医生助手（官方客服）"];
        [_doctorAssistantView addSubview:nicknameLabel];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [SkinManager sharedInstance].defaultLightGrayColor;
        [_doctorAssistantView addSubview:bottomLine];
        
        {
            // Autolayout
            [_doctorAssistantView addConstraint:[self.totalFansCountLabel autoSetDimension:ALDimensionHeight toSize:30.0f]];
            [_doctorAssistantView addConstraint:[self.totalFansCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_doctorAssistantView withOffset:0.0f]];
            [_doctorAssistantView addConstraint:[self.totalFansCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_doctorAssistantView withOffset:0.0f]];
            [_doctorAssistantView addConstraint:[self.totalFansCountLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_doctorAssistantView withOffset:0.0f]];
            
            [_doctorAssistantView addConstraint:[avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_doctorAssistantView withOffset:16.0f]];
            [_doctorAssistantView addConstraint:[avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.totalFansCountLabel withOffset:10.0f]];
            [_doctorAssistantView addConstraint:[nicknameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImageView withOffset:10.0f]];
            [_doctorAssistantView addConstraint:[nicknameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:avatarImageView withOffset:10.0f]];
        
            [_doctorAssistantView addConstraint:[bottomLine autoSetDimension:ALDimensionHeight toSize:0.5f]];
            [_doctorAssistantView addConstraint:[bottomLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_doctorAssistantView withOffset:0.0f]];
            [_doctorAssistantView addConstraint:[bottomLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_doctorAssistantView withOffset:0.0f]];
            [_doctorAssistantView addConstraint:[bottomLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_doctorAssistantView withOffset:0.0f]];
        }
    }
    return _doctorAssistantView;
}
*/


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[ContactManager sharedInstance] getIndexKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ContactManager sharedInstance] getContactCountWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sReusableCellWithIdentifier = @"514F3E9E-6C48-458E-AE91-C4F66E7EC265";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sReusableCellWithIdentifier];
    if (!cell) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sReusableCellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    /*
     // 不用环信的好友列表
    EMBuddy *buddy = [self.contactArray objectAtIndex:[indexPath row]];
    [cell.textLabel setText:buddy.username];
     */
    Patient *patient = [[ContactManager sharedInstance] getContactWithSection:[indexPath section] withRow:[indexPath row]];
    [cell setContact:patient];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.0f;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [[ContactManager sharedInstance] getIndexKeyWithSection:section];
    if ([key isEqualToString:kDoctorAssistantKey]) {
        key = @"医生助手";
    } else if ([key isEqualToString:kStarContactKey]) {
        key = @"星级用户";
    } else if ([key isEqualToString:kBlockContactKey]) {
        key = @"黑名单";
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = UIColorFromRGB(0xd4d4d4);
    [headerView addSubview:topLine];
    [headerView addConstraint:[topLine autoSetDimension:ALDimensionHeight toSize:0.5f]];
    [headerView addConstraint:[topLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:0.0f]];
    [headerView addConstraint:[topLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0.0f]];
    [headerView addConstraint:[topLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView withOffset:0.0f]];
    
    UILabel *keyLabel = [[UILabel alloc] init];
    keyLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
    keyLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    keyLabel.textColor = [UIColor blackColor];
    [headerView addSubview:keyLabel];
    [headerView addConstraints:[keyLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.5f, 10.0f, 0.5f, 0.0f)]];
    [keyLabel setText:key];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor clearColor];
    [headerView addSubview:bottomLine];
    [headerView addConstraint:[bottomLine autoSetDimension:ALDimensionHeight toSize:0.5f]];
    [headerView addConstraint:[bottomLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:0.0f]];
    [headerView addConstraint:[bottomLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headerView withOffset:0.0f]];
    [headerView addConstraint:[bottomLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView withOffset:0.0f]];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Patient *patient = [[ContactManager sharedInstance] getContactWithSection:[indexPath section] withRow:[indexPath row]];
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *chatter = [NSString stringWithFormat:@"%ld", (long)patient.userID];
    ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:chatter withChatterAvatar:cell.avatarImageView.image withMyAvatar:nil];
    messageController.title = [patient getDisplayName];
    [self.navigationController pushViewController:messageController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [[ContactManager sharedInstance] getIndexKeyWithSection:section];
    if ([key isEqualToString:kDoctorAssistantKey]) {
        key = @"医生助手";
    } else if ([key isEqualToString:kStarContactKey]) {
        key = @"星级用户";
    } else if ([key isEqualToString:kBlockContactKey]) {
        key = @"黑名单";
    }
    return key;
}

// 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *content = [[ContactManager sharedInstance] getIndexKeys];
    NSMutableArray *newSectionIndexTitles = [[NSMutableArray alloc] init];
    for (NSString *title in content) {
        
        [newSectionIndexTitles addObject:[NSString stringWithFormat:@"  %@  ", title]];
    }
    return newSectionIndexTitles;
}


#pragma mark - Private

- (void)setupSubviews
{
    [self.view addSubview:self.contactTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraint:[self.contactTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
    if (IOS_VERSION >= 7.0) {
        [self.view addConstraint:[self.contactTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-kTabBarHeight]];
    } else {
        [self.view addConstraint:[self.contactTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.0f]];
    }
    [self.view addConstraint:[self.contactTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.contactTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
}

- (void)reloadContacts
{
    /*
     // 不用环信的好友列表
    [self.contactArray removeAllObjects];
    NSArray *array = [[EaseMob sharedInstance].chatManager buddyList];
    
    for (EMBuddy *buddy in array) {
        if (buddy.isPendingApproval) {
            [self.contactArray addObject:buddy];
        }
    }
    [_totalFansCountLabel setText:[NSString stringWithFormat:@"共%d名患者关注了您", [self.contactArray count]]];
    [self.contactTableView reloadData];
     */
    
    [[ContactManager sharedInstance] asyncReloadContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
        // 在通知处重新加载列表
    } withErrorHandler:^(NSError *error) {
        
    }];
}


#pragma mark - Selector

- (void)doctorAssistantClicked:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *assistantIDString = [NSString stringWithFormat:@"%ld", (long)kDoctorAssistantID];
    ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:assistantIDString withChatterAvatar:[UIImage imageNamed:@"icon_assistant"] withMyAvatar:nil];
    [self.tabBarController.navigationController pushViewController:messageController animated:YES];
}


#pragma mark - Notification

- (void)contactChangedNotification:(NSNotification *)notification
{
    //[self reloadContacts];
    NSInteger contactCount = [[ContactManager sharedInstance] getContactCount];
    [_totalFansCountLabel setText:[NSString stringWithFormat:@"共%ld名患者关联了您", (long)(contactCount - 1)]]; // 不算助手
    [self.contactTableView reloadData];
}


#pragma mark - ContactTableViewCellDelegate

- (void)contactTableViewCellDidClickedAvatarImage:(ContactTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.contactTableView indexPathForCell:cell];
    Patient *patient = [[ContactManager sharedInstance] getContactWithSection:[indexPath section] withRow:[indexPath row]];
    if (patient.userID != kDoctorAssistantID) {
        ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
}

@end
