//
//  UserInfoViewController.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "LoginManager.h"
#import "UserInfoUpdateViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CardInfoViewController.h"
#import "SNSShare.h"
#import "Account.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "ChangePasswordViewController.h"
#import "QRCodeCardViewController.h"
#import "DFDServicePriceViewController.h"
#import "LocalCacheManager.h"

@interface UserInfoViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
//MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UITableView   *contentTableView;
@property (nonatomic, strong) UIButton      *qrCodeNameCardButton;
@property (nonatomic, strong) UIButton      *nameCardButton;
@property (nonatomic, strong) UIButton      *logoutButton;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)showSMSPicker;
- (void)displaySMSComposerSheet;
- (NSString *)getSharedText;

// Selector
- (void)logoutButtonClicked:(UIButton *)button;
- (void)qrCodeNameCardButtonClicked:(UIButton *)button;
- (void)nameCardButtonClicked:(UIButton *)button;
- (void)accountInfoChanged:(NSNotification *)notification;

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"账户管理";
        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultSettingTabBarNormalIcon];
        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultSettingTabBarHighlightedIcon];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountInfoChanged:) name:kAccountInfoChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.contentTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
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
        
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [versionLabel setText:[NSString stringWithFormat:@"【我爱好医生】医生版 %@版", versionString]];
        [versionLabel setFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 45.0f)];
        versionLabel.textAlignment = NSTextAlignmentCenter;
        versionLabel.font = [UIFont systemFontOfSize:14.0f];
        versionLabel.textColor = [UIColor lightGrayColor];
        _contentTableView.tableFooterView = versionLabel;
    }
    return _contentTableView;
}

- (UIButton *)qrCodeNameCardButton
{
    if (!_qrCodeNameCardButton) {
        _qrCodeNameCardButton = [[SkinManager sharedInstance] createDefaultButton];
        _qrCodeNameCardButton.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        _qrCodeNameCardButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_qrCodeNameCardButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_qrCodeNameCardButton setTitle:@"我的二维码名片" forState:UIControlStateNormal];
        [_qrCodeNameCardButton addTarget:self action:@selector(qrCodeNameCardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeNameCardButton;
}

- (UIButton *)nameCardButton
{
    if (!_nameCardButton) {
        _nameCardButton = [[SkinManager sharedInstance] createDefaultButton];
        _nameCardButton.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        _nameCardButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_nameCardButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_nameCardButton setTitle:@"推荐给同事" forState:UIControlStateNormal];
        [_nameCardButton addTarget:self action:@selector(nameCardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameCardButton;
}

- (UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [[SkinManager sharedInstance] createDefaultButton];
        _logoutButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_logoutButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_logoutButton setTitle:@"注销登录" forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}


#pragma mark - Selector

- (void)logoutButtonClicked:(UIButton *)button
{
    UIAlertView *quitAlertView = [[UIAlertView alloc] initWithTitle:@"注销" message:@"您确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [quitAlertView show];
}

- (void)qrCodeNameCardButtonClicked:(UIButton *)button
{
    /*
    int qrcodeImageDimension = 250;
    //the string can be very long
    NSString *aVeryLongURL = @"Infomation";
    
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    //DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:aVeryLongURL];
    
    //then render the matrix
    //UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    
    ZXEncodeHints* hints = [ZXEncodeHints hints];
    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];//容错性设成最高，二维码里添加图片
    hints.encoding =  NSUTF8StringEncoding;// 加上这两句，可以用中文了
    
    ZXBitMatrix* result = [writer encode:@"information" format:kBarcodeFormatQRCode width:800 height:800 hints:hints error:&error];
    
    CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
    UIImage *image1 =   [UIImage imageWithCGImage:image];//二维码原图
    */
    
    QRCodeCardViewController *qrCodeCardVC = [[QRCodeCardViewController alloc] init];
    UINavigationController *nav = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:qrCodeCardVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)nameCardButtonClicked:(UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享给同事" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"短信", @"微信", nil];
    [actionSheet showInView:self.view];
}

- (void)accountInfoChanged:(NSNotification *)notification
{
    [self.contentTableView reloadData];
}

#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraint:[self.contentTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.contentTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.contentTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
    if (IOS_VERSION >= 7.0) {
        [self.view addConstraint:[self.contentTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-kTabBarHeight]];
    } else {
        [self.view addConstraint:[self.contentTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.0f]];
    }
}

//短信
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


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;   // 医生信息
    } else if (1 == section) {
        return 5;   // 5行功能
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *reusableHeaderViewIdentifier = @"EB8D6DEA-B920-496E-B6C5-BE2F9B92F5C0";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[UIView alloc] init];
    }
    if (1 == section) {
        UILabel *contactIDLabel = [[UILabel alloc] init];
        [contactIDLabel setText:[NSString stringWithFormat:@"我的帐号:%ld", (long)[AccountManager sharedInstance].account.accountID]];
        contactIDLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:contactIDLabel];
        [headerView addSubview:self.qrCodeNameCardButton];
        [headerView addSubview:self.nameCardButton];
        {
            [headerView addConstraints:[self.qrCodeNameCardButton autoSetDimensionsToSize:CGSizeMake(145.0f, 38.0f)]];
            [headerView addConstraints:[self.nameCardButton autoSetDimensionsToSize:CGSizeMake(145.0f, 38.0f)]];
            [headerView addConstraint:[contactIDLabel autoSetDimension:ALDimensionHeight toSize:44.0f]];
            [headerView addConstraint:[contactIDLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:0.0f]];
            [headerView addConstraint:[contactIDLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0.0f]];
            [headerView addConstraint:[contactIDLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView withOffset:0.0f]];
            [headerView addConstraint:[self.qrCodeNameCardButton autoAlignAxis:ALAxisVertical toSameAxisOfView:headerView withOffset:-80.0f]];
            [headerView addConstraint:[self.nameCardButton autoAlignAxis:ALAxisVertical toSameAxisOfView:headerView withOffset:80.0f]];
            [headerView addConstraint:[self.qrCodeNameCardButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contactIDLabel withOffset:5.0f]];
            [headerView addConstraint:[self.nameCardButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contactIDLabel withOffset:5.0f]];
        }
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath section]) {
        // 医生信息
        static NSInteger UserInfoAvatarImageViewTag = 1;
        static NSInteger UserInfoNameLabelTag = 2;
        static NSInteger UserInfoVipTag = 3;
        static NSInteger UserInfoBalanceLabelTag = 4;
        static NSString *reusableCellIdentifier = @"EB8D6DEA-B920-496E-B6C5-BE2F9B92F5C0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            {
                // Subview and autolayout
                UIImageView *avatarImageView = [[UIImageView alloc] init];
                avatarImageView.layer.cornerRadius = 3.0f;
                avatarImageView.layer.masksToBounds = YES;
                [cell.contentView addSubview:avatarImageView];
                avatarImageView.tag =UserInfoAvatarImageViewTag;
                
                UILabel *nameLabel = [[UILabel alloc] init];
                nameLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
                nameLabel.font = [UIFont systemFontOfSize:14.0f];
                [cell.contentView addSubview:nameLabel];
                nameLabel.tag = UserInfoNameLabelTag;
                
                UIImageView *vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_vip"]];
                [cell.contentView addSubview:vipImageView];
                vipImageView.tag = UserInfoVipTag;
                
                UILabel *balanceLabel = [[UILabel alloc] init];
                balanceLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
                balanceLabel.font = [UIFont systemFontOfSize:14.0f];
                [cell.contentView addSubview:balanceLabel];
                balanceLabel.tag = UserInfoBalanceLabelTag;
                
                {
                    [cell.contentView addConstraints:[avatarImageView autoSetDimensionsToSize:CGSizeMake(60.0f, 60.0f)]];
                    [cell.contentView addConstraint:[avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.contentView withOffset:15.0f]];
                    [cell.contentView addConstraint:[avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.contentView withOffset:9.0f]];
                    
                    [cell.contentView addConstraint:[nameLabel autoSetDimension:ALDimensionHeight toSize:15.0f]];
                    [cell.contentView addConstraint:[nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImageView withOffset:20.0f]];
                    [cell.contentView addConstraint:[nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:avatarImageView withOffset:5.0f]];
                    
                    [cell.contentView addConstraint:[vipImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:nameLabel withOffset:2.0f]];
                    [cell.contentView addConstraint:[vipImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:nameLabel withOffset:0.0f]];
                    
                    [cell.contentView addConstraint:[balanceLabel autoSetDimension:ALDimensionHeight toSize:15.0f]];
                    [cell.contentView addConstraint:[balanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImageView withOffset:20.0f]];
                    [cell.contentView addConstraint:[balanceLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:avatarImageView withOffset:-5.0f]];
                }
            }
        }
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:UserInfoNameLabelTag];
        Account *account = [AccountManager sharedInstance].account;
        [nameLabel setText:[account getDisplayName]];
        
        UILabel *balanceLabel = (UILabel *)[cell viewWithTag:UserInfoBalanceLabelTag];
        [[AccountManager sharedInstance] asyncGetBalanceWithCompletionHandler:^(long balance) {
            [balanceLabel setText:[NSString stringWithFormat:@"您的账户余额%.02f元", (CGFloat)(account.balance / 100.0f)]];
        } withErrorHandler:^(NSError *error) {
            [balanceLabel setText:[NSString stringWithFormat:@"您的账户余额%.02f元", (CGFloat)(account.balance / 100.0f)]];
        }];
        
        UIImageView *avatarImageView = (UIImageView *)[cell.contentView viewWithTag:UserInfoAvatarImageViewTag];
        NSString *avatarImagePath = [AccountManager sharedInstance].account.avatarImageURLString;
        [[AccountManager sharedInstance] asyncDownloadImageWithURLString:avatarImagePath withCompletionHandler:^(UIImage *image) {
            [avatarImageView setImage:image];
        } withErrorHandler:^(NSError *error) {
            [avatarImageView setImage:[UIImage imageNamed:@"icon_chat_default_avatar"]];
        }];
        return cell;
    } else if (1 == [indexPath section]) {
        // 5行功能
        static NSString *reusableCellIdentifier = @"D001F8D9-0733-4F72-A4A5-D98AA0B18C45";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ([indexPath row] == 0) {
            [cell.imageView setImage:[SkinManager sharedInstance].defaultNameCardIcon];
            [cell.textLabel setText:@"免费申请快递随访卡等物料"];
        } else if ([indexPath row] == 1) {
            [cell.imageView setImage:[SkinManager sharedInstance].defaultSettingIcon];
            [cell.textLabel setText:@"设置登录密码"];
        } else if ([indexPath row] == 2) {
            [cell.imageView setImage:[UIImage imageNamed:@"icon_service_price"]];
            [cell.textLabel setText:@"服务价格设置"];
        } else if ([indexPath row] == 3) {
            [cell.imageView setImage:[SkinManager sharedInstance].defaultSettingIcon];
            [cell.textLabel setText:@"设置"];
        } else if ([indexPath row] == 4) {
            [cell.imageView setImage:[SkinManager sharedInstance].defaultFeedbackIcon];
            [cell.textLabel setText:@"反馈问题"];
        }
        return cell;
    }
    return nil;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *reusableFooterViewIdentifier = @"FD820749-4F36-4A3E-81B5-1CBF95D99358";
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableFooterViewIdentifier];
    if (!footerView) {
        footerView = [[UIView alloc] init];
    }
    if (1 == section) {
        [footerView addSubview:self.logoutButton];
        {
            [footerView addConstraint:[self.logoutButton autoSetDimension:ALDimensionHeight toSize:38.0f]];
            [footerView addConstraint:[self.logoutButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView withOffset:20.0f]];
            [footerView addConstraint:[self.logoutButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:footerView withOffset:17.0f]];
            [footerView addConstraint:[self.logoutButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView withOffset:-20.0f]];
        }
    }
    return footerView;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 15.0f;
    } else if (1 == section) {
        return 54.0f + 44.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath section]) {
        return 76.0f;
    } else if (1 == [indexPath section]) {
        return 44.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 6.0f;
    } else if (1 == section) {
        return 58.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == [indexPath section]) {
        UserInfoUpdateViewController *updateViewController = [[UserInfoUpdateViewController alloc] init];
        [self.navigationController pushViewController:updateViewController animated:YES];
    } else if (1 == [indexPath section]) {
        if (0 == [indexPath row]) {
            // 申请快递我的名片
            CardInfoViewController *cardInfoVC = [[CardInfoViewController alloc] init];
            [self.navigationController pushViewController:cardInfoVC animated:YES];
        } else if (1 == [indexPath row]) {
            // 设置登录密码
            ChangePasswordViewController *changePasswordViewController = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:changePasswordViewController animated:YES];
        } else if (2 == [indexPath row]) {
            // 服务价格设置
            DFDServicePriceViewController *servicePriceViewCongtroller = [[DFDServicePriceViewController alloc] init];
            [self.navigationController pushViewController:servicePriceViewCongtroller animated:YES];
        } else if (3 == [indexPath row]) {
            // 设置
            SettingViewController *settingViewController = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingViewController animated:YES];
        } else if (4 == [indexPath row]) {
            NSString *assistantIDString = [NSString stringWithFormat:@"%ld", (long)kDoctorAssistantID];
            ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:assistantIDString withChatterAvatar:[UIImage imageNamed:@"icon_assistant"] withMyAvatar:nil];
            [self.tabBarController.navigationController pushViewController:messageController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [self showSMSPicker];   // 短信分享
    } else if (1 == buttonIndex) {
        [[SNSShare sharedInstance] shareToWXFriendWithContent:[self getSharedText]];
    }
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
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
            
            [[LocalCacheManager sharedInstance] emptyCache];
        } withErrorHandler:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }];
    }
}

@end
