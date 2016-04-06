//
//  UserInfoUpdateViewController.m
//  AppFramework
//
//  Created by ABC on 7/26/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "UserInfoUpdateViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "TitleListViewController.h"
#import "HospitalListViewController.h"
#import "DepartmentsViewController.h"
#import "RegionViewController.h"
#import "AppUtil.h"
#import "ReviseUserInfoViewController.h"
#import "UIImagePickerController+Util.h"
#import "LocalCacheManager.h"
#import "EXUILabel.h"
#import "MBProgressHUD.h"

@interface UserInfoUpdateViewController ()
<
UITableViewDataSource, UITableViewDelegate,
UINavigationControllerDelegate,
RegionViewControllerDelegate,
TitleListViewControllerDelegate,
HospitalListViewControllerDelegate,
DepartmentsViewControllerDelegate,
ReviseUserInfoViewControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate
>

@property (nonatomic, strong) UILabel       *topInfoLabel;
@property (nonatomic, strong) UITableView   *contentTableView;
@property (nonatomic, strong) UIImageView   *avatarImageView;

@end

@implementation UserInfoUpdateViewController

const NSInteger AvatarSection = 0;
enum Avatar {
    AvatarRow = 0
};

const NSInteger OtherInfoSection = 1;
enum OtherInfoRow {
    RealNameRow = 0,
    MobileRow,
    RegionRow,
    HospitalRow,
    DepartmentRow,
    TitleRow,
    ScheduleRow,
    BriefRow,
    OfficePhoneRow
};

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
    
    
    [self setNavigationBarWithTitle:@"个人信息" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    self.contentTableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.contentTableView];
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
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

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chat_default_avatar"]];
        _avatarImageView.layer.cornerRadius = 3.0f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        
        //UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewTapGestureRecognizerFired:)];
        //[avatarImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return _avatarImageView;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (AvatarSection == section) {
        return 1;
    } else if (OtherInfoSection == section) {
        return 9;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = nil;
    Account *account = [AccountManager sharedInstance].account;
    if (AvatarSection == [indexPath section]) {
        static NSString *reusableCellIdentifier = @"816C828A-8CF1-4C58-8F56-7FE401849693";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusableCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.textLabel setText:@"头像"];
        [cell.contentView addSubview:self.avatarImageView];
        {
            [cell.contentView addConstraints:[self.avatarImageView autoSetDimensionsToSize:CGSizeMake(60.0f, 60.0f)]];
            [cell.contentView addConstraint:[self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
            [cell.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.contentView withOffset:0.0f]];
        }
        
        NSString *avatarImagePath = [AccountManager sharedInstance].account.avatarImageURLString;
        [[AccountManager sharedInstance] asyncDownloadImageWithURLString:avatarImagePath withCompletionHandler:^(UIImage *image) {
            [self.avatarImageView setImage:image];
        } withErrorHandler:^(NSError *error) {
            
        }];
        theCell = cell;
    } else if (OtherInfoSection == [indexPath section]) {
        static NSString *reusableCellIdentifier = @"5710DDEB-F41D-4861-BC33-D011E68D7451";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusableCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (MobileRow == [indexPath row]) {
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            [cell.textLabel setText:@"手机号码"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.mobile]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (RealNameRow == [indexPath row]) {
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            [cell.textLabel setText:@"真实姓名"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.realName]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (RegionRow == [indexPath row]) {
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            [cell.textLabel setText:@"地区"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.region.name]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (HospitalRow == [indexPath row]) {
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            [cell.textLabel setText:@"医院"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.hospital.name]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (DepartmentRow == [indexPath row]) {
            [cell.textLabel setText:@"科室"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.department]];
        } else if (TitleRow == [indexPath row]) {
            [cell.textLabel setText:@"职称"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.title]];
        } else if (ScheduleRow == [indexPath row]) {
            [cell.textLabel setText:@"门诊时间"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.schedule]];
        } else if (BriefRow == [indexPath row]) {
            [cell.textLabel setText:@"简介"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.brief]];
        } else if (OfficePhoneRow == [indexPath row]) {
            [cell.textLabel setText:@"办公电话"];
            [cell.detailTextLabel setText:[AppUtil parseString:account.officePhone]];
        }
        theCell = cell;
    }
    
    return theCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (AvatarSection == section) {
        return 15.0f;
    } else if (OtherInfoSection == section) {
        return 0.1f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (AvatarSection == [indexPath section]) {
        return 80.0f;
    } else if (OtherInfoSection == [indexPath section]) {
        return 44.0f;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (AvatarSection == section) {
        return 37.5f;
    } else if (OtherInfoSection == section) {
        return 15.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (AvatarSection == [indexPath section]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
        [actionSheet showInView:self.view];
    } else if (OtherInfoSection == [indexPath section]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (MobileRow == [indexPath row]) {
            // 手机号不可以修改
        } else if (RealNameRow == [indexPath row]) {
            // 真实姓名不可以修改
        } else if (RegionRow == [indexPath row]) {
            // 地区不可以修改
        } else if (HospitalRow == [indexPath row]) {
            // 医院不可以修改
            
        } else if (DepartmentRow == [indexPath row]) { // 科室
           
            DepartmentsViewController *viewController = [[DepartmentsViewController alloc] init];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if (TitleRow == [indexPath row]) { // 职称
            
            TitleListViewController *viewController = [[TitleListViewController alloc] init];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if (ScheduleRow == [indexPath row]) { // 门诊时间
            
            Account *account = [AccountManager sharedInstance].account;
            ReviseUserInfoViewController *viewController = [[ReviseUserInfoViewController alloc] initWithUserInfoType:UIT_Schedule withAccount:account];
            viewController.delegate = self;
            viewController.title = [cell.textLabel text];
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if (BriefRow == [indexPath row]) { // 简介
            
            Account *account = [AccountManager sharedInstance].account;
            ReviseUserInfoViewController *viewController = [[ReviseUserInfoViewController alloc] initWithUserInfoType:UIT_Brief withAccount:account];
            viewController.delegate = self;
            viewController.title = [cell.textLabel text];
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if (OfficePhoneRow == [indexPath row]) { // 办公电话
            
            Account *account = [AccountManager sharedInstance].account;
            ReviseUserInfoViewController *viewController = [[ReviseUserInfoViewController alloc] initWithUserInfoType:UIT_OfficePhone withAccount:account];
            viewController.delegate = self;
            viewController.title = [cell.textLabel text];
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        EXUILabel *tipLabel = [[EXUILabel alloc] init];
        tipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        tipLabel.font = [UIFont systemFontOfSize:11.0f];
        tipLabel.textColor = UIColorFromRGB(0x919191);
        tipLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
        tipLabel.numberOfLines = 0;
        tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [tipLabel setText:@"（请上传正面照片，方便患者确认您的身份）\n如需修改灰色字体部分，请通过医生助手联系客服。"];
        return tipLabel;
    }
    return [[UIView alloc] init];
}


#pragma mark - RegionViewControllerDelegate

- (void)regionViewController:(RegionViewController *)viewController didSelectedRegionItem:(RegionItem *)regionItem
{
    Account *account = [[Account alloc] init];
    account.region = regionItem;
    [[AccountManager sharedInstance] asyncUploadAccount:account withCompletionHandler:^(Account *account) {
        [self.contentTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    [self.navigationController popToViewController:self animated:YES];
}


#pragma mark - TitleListViewControllerDelegate

- (void)titleListViewController:(TitleListViewController *)viewController didSelectedTitle:(NSString *)title
{
    Account *account = [[Account alloc] init];
    account.title = title;
    [[AccountManager sharedInstance] asyncUploadAccount:account withCompletionHandler:^(Account *account) {
        [self.contentTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    [self.navigationController popToViewController:self animated:YES];
}


#pragma mark - HospitalListViewControllerDelegate

- (void)hospitalListViewController:(HospitalListViewController *)viewController didSelectedHospitalItem:(HospitalItem *)hospitalItem;
{
    Account *account = [[Account alloc] init];
    account.hospital = hospitalItem;
    [[AccountManager sharedInstance] asyncUploadAccount:account withCompletionHandler:^(Account *account) {
        [self.contentTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    [self.navigationController popToViewController:self animated:YES];
}


#pragma mark - DepartmentsViewControllerDelegate

- (void)departmentsViewController:(DepartmentsViewController *)controller didSelectedDepartments:(NSArray *)departmentsArray
{
    NSString *departmentsName = [[NSString alloc] init];
    for (NSInteger index = 0; index < [departmentsArray count]; index++) {
        Department *theDepartment = [departmentsArray objectAtIndex:index];
        if (index == 0) {
            departmentsName = theDepartment.name;
        } else {
            departmentsName = [NSString stringWithFormat:@"%@,%@", departmentsName, theDepartment.name];
        }
    }
    
    Account *account = [[Account alloc] init];
    account.department = departmentsName;
    [[AccountManager sharedInstance] asyncUploadAccount:account withCompletionHandler:^(Account *account) {
        [self.contentTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    [self.navigationController popToViewController:self animated:YES];
}


#pragma mark - ReviseUserInfoViewControllerDelegate

- (void)reviseUserInfoViewController:(ReviseUserInfoViewController *)viewController didChangeType:(NSInteger)type withText:(NSString *)text
{
    [self.navigationController popViewControllerAnimated:YES];
    
    Account *tmpAccount = [[Account alloc] init];
    if (type == UIT_Mobile) {
        tmpAccount.mobile = text;
    } else if (type == UIT_Realname) {
        tmpAccount.realName = text;
    } else if (type == UIT_OfficePhone) {
        tmpAccount.officePhone = text;
    } else if (type == UIT_Brief) {
        tmpAccount.brief = text;
    } else if (type == UIT_Schedule) {
        tmpAccount.schedule = text;
    }
    [[AccountManager sharedInstance] asyncUploadAccount:tmpAccount withCompletionHandler:^(Account *account) {
        [self.contentTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 1) {
        return ;
    }
    
    if ([UIImagePickerController isCameraAvailable] && [UIImagePickerController doesCameraSupportTakingPhotos]){
        // 初始化图片选择控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if (0 == buttonIndex) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else if (1 == buttonIndex) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
           // imagePickerController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        }
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType, nil];
        [imagePickerController setMediaTypes:arrMediaTypes];
        [imagePickerController setAllowsEditing:YES];           // 设置是否可以管理已经存在的图片或者视频
        [imagePickerController setDelegate:self];              // 设置代理
        imagePickerController.navigationController.delegate = self;
//        [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
//            
//        }];
        

        [self presentViewController:imagePickerController animated:YES completion:^{
            
            
        }];
        
        
    } else {
        DLog(@"Camera is not available.");
    }
}


#pragma mark - UIImagePickerControllerDelegate

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"Picker returned successfully.");
    DLog(@"%@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        // 缓存
        __unused NSString *imagePath = [[LocalCacheManager sharedInstance] saveAvatarImage:theImage];
        //上传
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] init];
        progressHUD.labelText = @"请稍候...";
        [progressHUD show:YES];
        [[AccountManager sharedInstance] asyncUploadAvatarImage:theImage withCompletionHandler:^(Account *account) {
            progressHUD.labelText = @"更新成功";
            [progressHUD hide:YES afterDelay:0.5];
            [self.contentTableView reloadData];
        } withErrorHandler:^(NSError *error) {
            [progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        
    }];
}

// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(void) {}];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        navigationController.navigationBar.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        // 创建一个UIView
        UIView *statusB = [[UIView alloc] init];
        statusB.frame = CGRectMake(0, -20, App_Frame_Width, 20);
        statusB.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
        [viewController.navigationController.navigationBar addSubview:statusB];
        
    }
}
@end
