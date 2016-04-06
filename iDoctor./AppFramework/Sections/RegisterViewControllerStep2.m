//
//  RegisterViewControllerStep2.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "RegisterViewControllerStep2.h"
#import "RegisterViewControllerStep3.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "RegionViewController.h"
#import "DepartmentsViewController.h"
#import "UIViewController+Util.h"
#import "UIView+Subview.h"
#import "AccountManager.h"
#import "HospitalListViewController.h"
#import "TitleListViewController.h"
#import "RegisterSuccessViewController.h"

@interface RegisterViewControllerStep2 ()
<
RegionViewControllerDelegate,
DepartmentsViewControllerDelegate,
HospitalListViewControllerDelegate,
TitleListViewControllerDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UIScrollView                  *contentScrollView;
@property (nonatomic, strong) UILabel                       *tipLabel;
@property (nonatomic, strong) UIButton                      *regionSelectionButton;
@property (nonatomic, strong) UIButton                      *hospitalNameButton;
@property (nonatomic, strong) UIButton                      *titleButton;
@property (nonatomic, strong) UIButton                      *officeButton;
@property (nonatomic, strong) EXUITextField                 *scheduleTextField;
@property (nonatomic, strong) UIButton                      *briefButton;
@property (nonatomic, strong) UIButton                      *nextButton;
@property (nonatomic, strong) UIButton                      *skipButton;

@property (nonatomic, strong) Account                       *accountCache;

- (void)regionSelectionButtonClicked:(UIButton *)button;
- (void)hospitalNameButtonClicked:(UIButton *)button;
- (void)officeSelectionButtonClicked:(UIButton *)button;
- (void)briefButtonClicked:(UIButton *)button;
- (void)nextButtonClicked:(UIButton *)button;
- (void)skipButtonClicked:(UIButton *)button;
- (void)dismissActionSheet:(UIActionSheet *)actionSheet;
- (void)dismissDatePicker:(UIBarButtonItem *)barButtonItem;
- (void)updateLabel:(UIDatePicker *)datePicker;
- (void)briefChanged:(id)sender;
- (void)cancelPresentedViewController:(id)sender;
- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation RegisterViewControllerStep2

const NSInteger BriefTextViewTag = 1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAccount:(Account *)regAccount
{
    self = [super init];
    if (self) {
        self.accountCache = regAccount;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarWithTitle:@"注册2/2" leftBarButtonItem:nil rightBarButtonItem:nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xeef1f2);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
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

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _tipLabel.textColor = UIColorFromRGB(0x8e8e93);
        _tipLabel.font = [UIFont systemFontOfSize:12.0f];
        [_tipLabel setText:@"请填写正确信息，修改信息须联系客服"];
    }
    return _tipLabel;
}

- (UIButton *)regionSelectionButton
{
    if (!_regionSelectionButton) {
        _regionSelectionButton = [[SkinManager sharedInstance] createDefaultButton];
        [_regionSelectionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_regionSelectionButton setTitle:@"所在地区" forState:UIControlStateNormal];
        [_regionSelectionButton setTitleColor:UIColorFromRGB(0xbfbfbf) forState:UIControlStateNormal];
        [_regionSelectionButton addTarget:self action:@selector(regionSelectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regionSelectionButton;
}

- (UIButton *)hospitalNameButton
{
    if (!_hospitalNameButton) {
        _hospitalNameButton = [[SkinManager sharedInstance] createDefaultButton];
        [_hospitalNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_hospitalNameButton setTitleColor:UIColorFromRGB(0xbfbfbf) forState:UIControlStateNormal];
        [_hospitalNameButton setTitle:@"医院名称" forState:UIControlStateNormal];
        [_hospitalNameButton addTarget:self action:@selector(hospitalNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hospitalNameButton;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [[SkinManager sharedInstance] createDefaultButton];
        [_titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_titleButton setTitleColor:UIColorFromRGB(0xbfbfbf) forState:UIControlStateNormal];
        [_titleButton setTitle:@"职称" forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIButton *)officeButton
{
    if (!_officeButton) {
        _officeButton = [[SkinManager sharedInstance] createDefaultButton];
        [_officeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_officeButton setTitleColor:UIColorFromRGB(0xbfbfbf) forState:UIControlStateNormal];
        [_officeButton setTitle:@"擅长科室 (列表, 可多选)" forState:UIControlStateNormal];
        [_officeButton addTarget:self action:@selector(officeSelectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _officeButton;
}

- (EXUITextField *)scheduleTextField
{
    if (!_scheduleTextField) {
        _scheduleTextField = [[EXUITextField alloc] init];
        _scheduleTextField.backgroundColor = [UIColor whiteColor];
        _scheduleTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _scheduleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _scheduleTextField.delegate = self;
        [_scheduleTextField setPlaceholder:@"时间表 (自填)"];
        _scheduleTextField.textColor = UIColorFromRGB(0xbfbfbf);
    }
    return _scheduleTextField;
}

- (UIButton *)briefButton
{
    if (!_briefButton) {
        _briefButton = [[SkinManager sharedInstance] createDefaultButton];
        [_briefButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_briefButton setTitleColor:UIColorFromRGB(0xbfbfbf) forState:UIControlStateNormal];
        [_briefButton setTitle:@"简介 (自填)" forState:UIControlStateNormal];
        [_briefButton addTarget:self action:@selector(briefButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _briefButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        _nextButton.layer.cornerRadius = 6.0f;
        _nextButton.backgroundColor = UIColorFromRGB(0x34d2b4);
        [_nextButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_nextButton setTitle:@"还有一步完成注册" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = [[SkinManager sharedInstance] createDefaultButton];
        _skipButton.backgroundColor = [SkinManager sharedInstance].defaultGrayColor;//UIColorFromRGB(0x9d9d9d);
        [_skipButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_skipButton setTitle:@"跳过，以后添加" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_skipButton setHidden:YES];    // 隐藏，必须完成注册
    }
    return _skipButton;
}

-(Account *)accountCache
{
    if (!_accountCache) {
        _accountCache = [[Account alloc] init];
    }
    return _accountCache;
}


#pragma mark - Selector

- (void)regionSelectionButtonClicked:(UIButton *)button
{
    RegionViewController *regionViewController = [[RegionViewController alloc] initWithRegionCode:0];
    regionViewController.delegate = self;
    [self.navigationController pushViewController:regionViewController animated:YES];
}

- (void)hospitalNameButtonClicked:(UIButton *)button
{
    HospitalListViewController *hospitalListViewController = [[HospitalListViewController alloc] initWithRegionCode:self.accountCache.region.code];
    hospitalListViewController.delegate = self;
    [self.navigationController pushViewController:hospitalListViewController animated:YES];
}

- (void)titleButtonClicked:(UIButton *)button
{
    TitleListViewController *titleListViewController = [[TitleListViewController alloc] init];
    titleListViewController.delegate = self;
    [self.navigationController pushViewController:titleListViewController animated:YES];
}

- (void)officeSelectionButtonClicked:(UIButton *)button
{
    DepartmentsViewController *departmentViewController = [[DepartmentsViewController alloc] init];
    departmentViewController.delegate = self;
    [self.navigationController pushViewController:departmentViewController animated:YES];
}

- (void)briefButtonClicked:(UIButton *)button
{
    //居然用这种方法我也是醉了
    UIViewController *briefVC = [[UIViewController alloc] init];
    briefVC.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    __block UITextView *briefTextView = [[UITextView alloc] init];
    briefTextView.font = [UIFont systemFontOfSize:15.0f];
    briefTextView.tag = BriefTextViewTag;
    [briefVC.view addSubview:briefTextView];
    {
        [briefVC.view addConstraints:[briefTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    }
//    UINavigationController *briefNavigationController = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:briefVC];
    UINavigationController *briefNavigationController = [[UINavigationController alloc] initWithRootViewController:briefVC];
    briefNavigationController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    briefNavigationController.navigationBar.translucent = NO;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    briefNavigationController.navigationBar.titleTextAttributes = dict;
    briefVC.title = @"简介";
    briefVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPresentedViewController:)];
    briefVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(briefChanged:)];
    [self.navigationController presentViewController:briefNavigationController animated:YES completion:^{
        [briefTextView setText:self.accountCache.brief];
        [briefTextView becomeFirstResponder];
    }];
}

- (void)nextButtonClicked:(UIButton *)button
{
    //TODO验证 数据是否已填
    
    if (!self.accountCache.region) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必须选择所在地区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.accountCache.hospital) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必须选择医院" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.accountCache.title) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必须选择职称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.accountCache.department) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必须选择科室" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (self.scheduleTextField.text.length != 0) {
        
        self.accountCache.schedule = self.scheduleTextField.text;
    }
    
    [[AccountManager sharedInstance] asyncUploadAccount:self.accountCache withCompletionHandler:^(Account *account) {
        self.accountCache = account;
        
        RegisterSuccessViewController *rsv = [[RegisterSuccessViewController alloc] initWithAccountCache:self.accountCache];
        [self.navigationController pushViewController:rsv animated:YES];
        
        
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
    
    
//    self.accountCache.schedule = [self.scheduleTextField text];
//    RegisterViewControllerStep3 *registerViewControllerStep3 = [[RegisterViewControllerStep3 alloc] initWithAccount:self.accountCache];
//    [self.navigationController pushViewController:registerViewControllerStep3 animated:YES];
}

- (void)skipButtonClicked:(UIButton *)button
{
    self.accountCache.schedule = [self.scheduleTextField text];
    RegisterViewControllerStep3 *registerViewControllerStep3 = [[RegisterViewControllerStep3 alloc] init];
    [self.navigationController pushViewController:registerViewControllerStep3 animated:YES];
}

- (void)dismissActionSheet:(UIActionSheet *)actionSheet
{
    
}

- (void)dismissDatePicker:(UIBarButtonItem *)barButtonItem
{
    
}

- (void)updateLabel:(UIDatePicker *)datePicker
{
    
}

- (void)briefChanged:(id)sender
{
    UINavigationController *presentedNavigationController = (UINavigationController *)self.navigationController.presentedViewController;
    UIViewController *briefVC = presentedNavigationController.topViewController;
    UITextView *briefTextView = (UITextView *)[briefVC.view subviewWithTag:BriefTextViewTag];
    self.accountCache.brief = briefTextView.text;
    if ([briefTextView.text length] > 0) {
        [self.briefButton setTitle:[NSString stringWithFormat:@"简介：%@", briefTextView.text] forState:UIControlStateNormal];
    } else {
        [self.briefButton setTitle:[NSString stringWithFormat:@"简介"] forState:UIControlStateNormal];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)cancelPresentedViewController:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}

#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentScrollView];
    
    UIView *line1 = [self generateLineView];
    UIView *line2 = [self generateLineView];
    UIView *line3 = [self generateLineView];
    UIView *line4 = [self generateLineView];
    UIView *line5 = [self generateLineView];
    UIView *line6 = [self generateLineView];
    UIView *line7 = [self generateLineView];
    
    [self.contentScrollView addSubview:self.tipLabel];
    [self.contentScrollView addSubview:self.regionSelectionButton];
    [self.contentScrollView addSubview:self.hospitalNameButton];
    [self.contentScrollView addSubview:self.titleButton];
    [self.contentScrollView addSubview:self.officeButton];
    [self.contentScrollView addSubview:self.scheduleTextField];
    [self.contentScrollView addSubview:self.briefButton];
    [self.contentScrollView addSubview:self.nextButton];
    [self.contentScrollView addSubview:self.skipButton];
    
    [self.contentScrollView addSubview:line1];
    [self.contentScrollView addSubview:line2];
    [self.contentScrollView addSubview:line3];
    [self.contentScrollView addSubview:line4];
    [self.contentScrollView addSubview:line5];
    [self.contentScrollView addSubview:line6];
    [self.contentScrollView addSubview:line7];
    
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    [self.contentScrollView addConstraints:[self.regionSelectionButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.hospitalNameButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.titleButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.officeButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.scheduleTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.briefButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.nextButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 30.0f, 50.0f)]];
    [self.contentScrollView addConstraints:[self.skipButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
    
    [self.contentScrollView addConstraints:[line1 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line2 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95, 0.7f)]];
    [self.contentScrollView addConstraints:[line3 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95, 0.7f)]];
    [self.contentScrollView addConstraints:[line4 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95, 0.7f)]];
    [self.contentScrollView addConstraints:[line5 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95, 0.7f)]];
    [self.contentScrollView addConstraints:[line6 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95, 0.7f)]];
    [self.contentScrollView addConstraints:[line7 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    
    [self.contentScrollView addConstraint:[self.tipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.tipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.regionSelectionButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.regionSelectionButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.regionSelectionButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.hospitalNameButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.titleButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.officeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.scheduleTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.briefButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-15.0f]];
    [self.contentScrollView addConstraint:[self.skipButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.skipButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.briefButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.scheduleTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.officeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.titleButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.hospitalNameButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.regionSelectionButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    
    [self.contentScrollView addConstraint:[self.hospitalNameButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.regionSelectionButton]];
    [self.contentScrollView addConstraint:[self.titleButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hospitalNameButton]];
    [self.contentScrollView addConstraint:[self.officeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleButton]];
    [self.contentScrollView addConstraint:[self.scheduleTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.officeButton]];
    [self.contentScrollView addConstraint:[self.briefButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scheduleTextField]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.briefButton withOffset:20.0f]];
    [self.contentScrollView addConstraint:[self.skipButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nextButton withOffset:9.0f]];
    [self.contentScrollView addConstraint:[self.skipButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentScrollView withOffset:-9.0f]];
    
    [self.contentScrollView addConstraint:[line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.regionSelectionButton]];
    [self.contentScrollView addConstraint:[line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.hospitalNameButton]];
    [self.contentScrollView addConstraint:[line2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.hospitalNameButton]];
    [self.contentScrollView addConstraint:[line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.titleButton]];
    [self.contentScrollView addConstraint:[line3 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.titleButton]];
    [self.contentScrollView addConstraint:[line4 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.officeButton]];
    [self.contentScrollView addConstraint:[line4 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.officeButton]];
    [self.contentScrollView addConstraint:[line5 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scheduleTextField]];
    [self.contentScrollView addConstraint:[line5 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.scheduleTextField]];
    [self.contentScrollView addConstraint:[line6 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.briefButton]];
    [self.contentScrollView addConstraint:[line6 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.briefButton]];
    [self.contentScrollView addConstraint:[line7 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.briefButton]];
}


- (UIView *)generateLineView {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    return line;
}


#pragma mark - RegionViewControllerDelegate

- (void)regionViewController:(RegionViewController *)viewController didSelectedRegionItem:(RegionItem *)regionItem
{
    self.accountCache.region = regionItem;
    [self.navigationController popToViewController:self animated:YES];
    [self.regionSelectionButton setTitle:[NSString stringWithFormat:@"%@：%@", @"所在地区", regionItem.name] forState:UIControlStateNormal];
}


#pragma mark - DepartmentsViewControllerDelegate

- (void)departmentsViewController:(DepartmentsViewController *)controller didSelectedDepartments:(NSArray *)departmentsArray
{
    [self.navigationController popToViewController:self animated:YES];
    
    NSString *departmentsName = [[NSString alloc] init];
    for (NSInteger index = 0; index < [departmentsArray count]; index++) {
        Department *theDepartment = [departmentsArray objectAtIndex:index];
        if (index == 0) {
            departmentsName = theDepartment.name;
        } else {
            departmentsName = [NSString stringWithFormat:@"%@,%@", departmentsName, theDepartment.name];
        }
    }
    self.accountCache.department = departmentsName;
    [self.officeButton setTitle:[NSString stringWithFormat:@"擅长科室：%@", departmentsName] forState:UIControlStateNormal];
}


#pragma mark - HospitalListViewControllerDelegate

- (void)hospitalListViewController:(HospitalListViewController *)viewController didSelectedHospitalItem:(HospitalItem *)hospitalItem
{
    [self.navigationController popToViewController:self animated:YES];
    
    self.accountCache.hospital = hospitalItem;
    [self.hospitalNameButton setTitle:[NSString stringWithFormat:@"医院名称：%@", hospitalItem.name] forState:UIControlStateNormal];
}


#pragma mark - TitleListViewControllerDelegate

- (void)titleListViewController:(TitleListViewController *)viewController didSelectedTitle:(NSString *)title
{
    [self.navigationController popToViewController:self animated:YES];
    
    self.accountCache.title = title;
    [self.titleButton setTitle:[NSString stringWithFormat:@"职称：%@", title] forState:UIControlStateNormal];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.scheduleTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

@end
