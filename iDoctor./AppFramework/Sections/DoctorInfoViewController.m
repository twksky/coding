//
//  UserInfoViewController.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "DoctorInfoViewController.h"
#import "UIView+AutoLayout.h"

#import "DoctorInfoHeaderView.h"
#import "DoctorInfoViewPriceCellTableViewCell.h"
#import "DoctorInfoViewItemCell.h"
#import "DoctorMoneyViewController.h"
#import "ChangePasswordViewController.h"
#import "DFDServicePriceViewController.h"
#import "SettingViewController.h"
#import "UserInfoUpdateViewController.h"
#import "CardInfoViewController.h"
#import "SNSShare.h"
#import "Account.h"
#import "AccountManager.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ChatViewController.h"
#import "LoginManager.h"
#import "LocalCacheManager.h"
#import "TemplateSettingViewController.h"
#import "TemplateSettingWithoutCategoriesViewController.h"


@interface DoctorInfoViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
MFMessageComposeViewControllerDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DoctorInfoHeaderView *headerView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemIcons;


@end

@implementation DoctorInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"我";
        
        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultSettingTabBarNormalIcon]; //TODO
        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultSettingTabBarHighlightedIcon];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self.headerView loadDataWithAccount:[AccountManager sharedInstance].account];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.bottomView];
    self.tableView.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    
    [self.headerView addBalanceViewTarget:self action:@selector(toBalanceViewController:)];
    [self.headerView addCreditViewTarget:self action:@selector(toCreditViewController:)];
    [self.headerView addHeaderViewTarget:self action:@selector(toUserInfoViewController:)];
    
    //AutoLayout
    {
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    [self updateHeaderView];
    
    [[AccountManager sharedInstance] asyncUpdateAccountWithCompletionHandler:^(Account *account) {
        
        [AccountManager sharedInstance].account.balance = account.balance;
        [AccountManager sharedInstance].account.score = account.score;
        
        [self updateHeaderView];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - action for balance and credit page

- (void)toBalanceViewController:(id)sender {
    
    [self.navigationController pushViewController:[[DoctorMoneyViewController alloc] initWithSegmentIndex:BALANCE_VIEW_INDEX] animated:YES];
}

- (void)toCreditViewController:(id)sender {
    
    [self.navigationController pushViewController:[[DoctorMoneyViewController alloc] initWithSegmentIndex:CREDIT_VIEW_INDEX] animated:YES];
}

- (void)toUserInfoViewController:(id)sender {
    
    UserInfoUpdateViewController *suc = [[UserInfoUpdateViewController alloc] init];
    [self.navigationController pushViewController:suc animated:YES];
}

- (void)toDFDServicePriceViewController:(id)sender {
    
    NSLog(@"ehehehehehehehheheheh");
    
    DFDServicePriceViewController *dpv = [[DFDServicePriceViewController alloc] init];
    [self.navigationController pushViewController:dpv animated:YES];
}

- (void)toTemplateSettingViewController:(id)sender {
    
    TemplateSettingWithoutCategoriesViewController *tvc = [[TemplateSettingWithoutCategoriesViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)logout:(id)sender {
    
    UIAlertView *quitAlertView = [[UIAlertView alloc] initWithTitle:@"注销" message:@"您确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [quitAlertView show];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        
        return 1;
    }
    else if (1 == section) {
        
        return [self.itemTitles count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (0 == indexPath.section) {
        
        DoctorInfoViewPriceCellTableViewCell *doctorInfoPriceCell = [[DoctorInfoViewPriceCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
        [doctorInfoPriceCell setPriceActionWithTarget:self action:@selector(toDFDServicePriceViewController:)];
        [doctorInfoPriceCell setTemplateActionWithTarget:self action:@selector(toTemplateSettingViewController:)];
        
        //TODO 设置模板的路径
        [doctorInfoPriceCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell = doctorInfoPriceCell;
        
    }
    else if (1 == indexPath.section) {
        
        DoctorInfoViewItemCell *docInfoItemCell = [[DoctorInfoViewItemCell alloc] init];
        [docInfoItemCell.itemIconImageView setImage:[UIImage imageNamed:[self.itemIcons objectAtIndex:indexPath.row]]];
        docInfoItemCell.itemTitleLabel.text = [self.itemTitles objectAtIndex:indexPath.row];
        
        cell = docInfoItemCell;
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        
        return 90.0f;
    }
    else if (1 == indexPath.section) {
        
        return 50.0f;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xedf2f1);
    view.frame = CGRectMake(0, 0, App_Frame_Width, 15);
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if (1 == indexPath.section && 3 == indexPath.row) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发短信给同事", @"发微信给同事", nil];
        [actionSheet showInView:self.view];
        
    }
    else if (1 == indexPath.section && 1 == indexPath.row) {
        
        ChangePasswordViewController *cvc = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
        
    }
    else if (1 == indexPath.section && 2 == indexPath.row) {
     
        SettingViewController *svc = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if (1 == indexPath.section && 4 == indexPath.row) {
        
        NSString *assistantIDString = [NSString stringWithFormat:@"%ld", (long)kDoctorAssistantID];
        ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:assistantIDString withChatterAvatar:[UIImage imageNamed:@"icon_assistant"] withMyAvatar:nil];
        [self.navigationController pushViewController:messageController animated:YES];
    }
    else if (1 == indexPath.section && 5 == indexPath.row) {
        
//        NSString *assistantIDString = [NSString stringWithFormat:@"%ld", (long)kDoctorAssistantID];
//        ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:assistantIDString withChatterAvatar:[UIImage imageNamed:@"icon_assistant"] withMyAvatar:nil];
//        [self.navigationController pushViewController:messageController animated:YES];
    }
    else if (1 == indexPath.section && 0 == indexPath.row) {
        
        CardInfoViewController *cvc = [[CardInfoViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else {
        
        [self.navigationController pushViewController:[[DoctorMoneyViewController alloc] initWithSegmentIndex:BALANCE_VIEW_INDEX] animated:YES];
    }
    
    //TODO 处理点击事件
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (0 == buttonIndex) {
        [self showSMSPicker];   // 短信分享
    } else if (1 == buttonIndex) {
        [[SNSShare sharedInstance] shareToWXFriendWithContent:[self getSharedText]];
    }
}


#pragma mark - private methods

- (NSString *)getSharedText
{
    Account *account = [AccountManager sharedInstance].account;
    NSString *doctorName = nil;
    if (account.realName && ![account.realName isEqual:[NSNull null]] && [account.realName length] > 0) {
        doctorName = account.realName;
    } else {
        doctorName = account.loginName;
    }
    return @"我在使用好医生网站推出的【我爱好医生】移动应用，感觉不错，它作为医患沟通的工具非常高效实用，还能增加医生的阳光收入。推荐你也使用试试。\n下载链接（安卓，iOS）：\nhttp://m.ihaoyisheng.com/app/doctor";
}

-(void)showSMSPicker
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = [self getSharedText];
    picker.body = smsBody;
    [self.navigationController presentViewController:picker animated:YES completion:^{
    }];
}

- (void)updateHeaderView {
    
    [self.headerView loadDataWithAccount:[AccountManager sharedInstance].account];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 注销
        [[AccountManager sharedInstance] asyncLogoutWithCompletionHandler:^(BOOL isSuccess) {
            [[EaseMob sharedInstance].chatManager asyncLogoff];
            [[LocalCacheManager sharedInstance] emptyCache];
            
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
        } withErrorHandler:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }];
    }
}



#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (DoctorInfoHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[DoctorInfoHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, App_Frame_Width, 233);
    }
    
    return _headerView;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 90.0f)];
        _bottomView.backgroundColor = UIColorFromRGB(0xedf2f1);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        btn.backgroundColor = UIColorFromRGB(0xfe5c58);
        btn.layer.cornerRadius = 6.0f;
        [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
        
        [_bottomView addConstraint:[btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
        [_bottomView addConstraint:[btn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
        [_bottomView addConstraint:[btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [_bottomView addConstraint:[btn autoSetDimension:ALDimensionHeight toSize:50.0f]];
    }
    
    return _bottomView;
}


- (NSArray *)itemTitles {
    
    if (!_itemTitles) {
        
        _itemTitles = [[NSArray alloc] initWithObjects:@"免费申请随访卡等资料", @"修改密码", @"设置", @"分享给同事", @"反馈问题", nil];
    }
    
    return _itemTitles;
}

- (NSArray *)itemIcons {
    
    if (!_itemIcons) {
        
        _itemIcons = [[NSArray alloc] initWithObjects:@"icon_suifangka", @"icon_xiugaimima", @"icon_shezhi", @"icon_fenxiang", @"icon_fankuiwenti", nil];
    }
    
    return _itemIcons;
}

@end
