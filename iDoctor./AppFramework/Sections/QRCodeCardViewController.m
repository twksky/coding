//
//  QRCodeCardViewController.m
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "QRCodeCardViewController.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "SkinManager.h"
#import "AccountManager.h"
#import "QRCodeGenerator.h"
#import "TTTAttributedLabel.h"

@interface QRCodeCardViewController ()

@property (nonatomic, strong) UIScrollView *containerView;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)doneButtonClicked:(UIButton *)button;

@end

@implementation QRCodeCardViewController

static NSString *App4DoctorDownloadURLString = @"http://m.ihaoyisheng.com/app/doctor";
static NSString *App4PatientDownloadURLString = @"http://m.ihaoyisheng.com/app/patient";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的二维码名片";
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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
    
    [self.containerView setFrame:self.view.bounds];
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

#pragma mark - Private Method

- (void)setupSubviews
{
    CGRect containerViewRect = CGRectMake(0.0f, 0.0f, App_Frame_Width, 0.0f);
    
    Account *account = [AccountManager sharedInstance].account;
    NSString *qrcodeString = [NSString stringWithFormat:@"%ld", account.accountID];
    UIImage *qrcodeImage = [QRCodeGenerator qrImageForString:qrcodeString imageSize:(App_Frame_Width / 2)];
    //put the image into the view
    UIImageView* qrcodeImageView = [[UIImageView alloc] initWithImage:qrcodeImage];
    CGRect qrcodeImageViewFrameRect = qrcodeImageView.frame;
    [self.containerView addSubview:qrcodeImageView];
    [qrcodeImageView setFrame:CGRectMake((App_Frame_Width - CGRectGetWidth(qrcodeImageViewFrameRect)) / 2, 0.0f, CGRectGetWidth(qrcodeImageViewFrameRect), CGRectGetHeight(qrcodeImageViewFrameRect))];
    containerViewRect.size.height += CGRectGetHeight(qrcodeImageView.frame);
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(containerViewRect), App_Frame_Width, 40.0f)];
    accountLabel.backgroundColor = [SkinManager sharedInstance].defaultGrayColor;
    accountLabel.textColor = [SkinManager sharedInstance].defaultWhiteColor;
    accountLabel.textAlignment = NSTextAlignmentCenter;
    [accountLabel setText:[NSString stringWithFormat:@"账号：%ld", account.accountID]];
    [self.containerView addSubview:accountLabel];
    containerViewRect.size.height += CGRectGetHeight(accountLabel.frame);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(containerViewRect), App_Frame_Width, 40.0f)];
    nameLabel.backgroundColor = [SkinManager sharedInstance].defaultGrayColor;
    nameLabel.textColor = [SkinManager sharedInstance].defaultWhiteColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setText:[account getDisplayName]];
    [self.containerView addSubview:nameLabel];
    containerViewRect.size.height += CGRectGetHeight(nameLabel.frame);
    
    if (account.hospital.name && ![account.hospital.name isEqual:[NSNull null]]) {
        UILabel *hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(containerViewRect), App_Frame_Width, 40.0f)];
        hospitalLabel.backgroundColor = [SkinManager sharedInstance].defaultGrayColor;
        hospitalLabel.textColor = [SkinManager sharedInstance].defaultWhiteColor;
        hospitalLabel.textAlignment = NSTextAlignmentCenter;
        [hospitalLabel setText:account.hospital.name];
        [self.containerView addSubview:hospitalLabel];
        containerViewRect.size.height += CGRectGetHeight(hospitalLabel.frame);
    }
    
    // 大众版二维码
    containerViewRect.size.height += 40.0f;
    TTTAttributedLabel *tipLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(containerViewRect), App_Frame_Width, 40.0f)];
    tipLabel.numberOfLines = 0;
    tipLabel.textInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    tipLabel.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    tipLabel.textColor = [SkinManager sharedInstance].defaultWhiteColor;
    tipLabel.font = [UIFont systemFontOfSize:10.0f];
    [tipLabel setText:@"先让患者扫描下面患者版App二维码，在安装完大众版应用后注册并打开应用，扫描上面医生账号二维码来关联医生。"];
    [self.containerView addSubview:tipLabel];
    containerViewRect.size.height += CGRectGetHeight(tipLabel.frame);
    
    UILabel *apkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(containerViewRect), App_Frame_Width, 40.0f)];
    apkLabel.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    apkLabel.textColor = [SkinManager sharedInstance].defaultWhiteColor;
    apkLabel.textAlignment = NSTextAlignmentCenter;
    [apkLabel setText:@"我爱好医生App患者版二维码"];
    [self.containerView addSubview:apkLabel];
    containerViewRect.size.height += CGRectGetHeight(apkLabel.frame);
    
    NSString *apkDownloadURLPath = App4PatientDownloadURLString;
    UIImage *apkQRCodeImage = [QRCodeGenerator qrImageForString:apkDownloadURLPath imageSize:(App_Frame_Width / 2)];
    //put the image into the view
    UIImageView* apkQRCodeImageView = [[UIImageView alloc] initWithImage:apkQRCodeImage];
    [self.containerView addSubview:apkQRCodeImageView];
    [apkQRCodeImageView setFrame:CGRectMake((App_Frame_Width - CGRectGetWidth(apkQRCodeImageView.frame)) / 2, CGRectGetMaxY(containerViewRect), CGRectGetWidth(apkQRCodeImageView.frame), CGRectGetHeight(apkQRCodeImageView.frame))];
    containerViewRect.size.height += CGRectGetHeight(apkQRCodeImageView.frame);
    /*
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon-Small" ofType:@"png"];
    UIImage *appIconImage = [UIImage imageNamed:@"icon_Small.png"];//[UIImage imageWithContentsOfFile:imagePath];
    UIImageView* appIconImageView = [[UIImageView alloc] initWithImage:appIconImage];
    [apkQRCodeImageView addSubview:appIconImageView];
    appIconImageView.center = apkQRCodeImageView.center;
    */
    [self.containerView setFrame:containerViewRect];
    self.containerView.contentSize = containerViewRect.size;
    
    [self.view addSubview:self.containerView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    
}


#pragma mark - Property

- (UIScrollView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] init];
    }
    return _containerView;
}


#pragma mark - Selector

- (void)doneButtonClicked:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
