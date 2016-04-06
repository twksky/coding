//
//  CardInfoViewController.m
//  AppFramework
//
//  Created by ABC on 8/3/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "CardInfoViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "UIView+AutoLayout.h"
#import "EXUILabel.h"
#import "AccountManager.h"
#import "QRCodeCardViewController.h"
#import "CardInfoCell.h"

@interface CardInfoViewController ()
<
UIAlertViewDelegate
>

//@property (nonatomic, strong) UIScrollView      *contentScrollView;
//@property (nonatomic, strong) UIView                *recipientsContainerView;
//@property (nonatomic, strong) EXUILabel                 *recipientsLabel;
//@property (nonatomic, strong) UITextView                *recipientsTextField;
//@property (nonatomic, strong) UIView                *mobileContainerView;
//@property (nonatomic, strong) EXUILabel                 *mobileLabel;
//@property (nonatomic, strong) UITextView                *mobileTextField;
//@property (nonatomic, strong) UIView                *postCodeContainerView;
//@property (nonatomic, strong) EXUILabel                 *postCodeLabel;
//@property (nonatomic, strong) UITextView                *postCodeTextField;
//@property (nonatomic, strong) UIView                *addressContainerView;
//@property (nonatomic, strong) EXUILabel                 *addressLabel;
//@property (nonatomic, strong) UITextView                *addressTextField;
//@property (nonatomic, strong) UIButton              *confirmButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic, strong) UITextField *receiverNameTextField;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *locationTextField;
@property (nonatomic, strong) UITextField *desLocationTextField;
@property (nonatomic, strong) UITextField *postCodeTextField;

@property (nonatomic, strong) UIView *bottomView;


//- (void)setupSubviews;
//- (void)setupConstraints;

- (void)confirmButtonClicked:(id)sender;
- (void)cardButtonClicked:(id)sender;
- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation CardInfoViewController

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
    [self setNavigationBarWithTitle:@"收货地址" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [self setupSubviews];
    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"名片" style:UIBarButtonItemStylePlain target:self action:@selector(cardButtonClicked:)];
//    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[SkinManager sharedInstance].defaultWhiteColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.tableView];
    
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 0, 0, 0)]];
    self.tableView.tableFooterView = self.bottomView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
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

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

#pragma mark - UITableView DataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardInfoCell *cell = [[CardInfoCell alloc] initWithTitle:[self.titles objectAtIndex:indexPath.row] uiTextField:[self.textFields objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - Property

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (NSArray *)titles {
    
    if (!_titles) {
        
        _titles = @[@"收件人姓名:", @"手机号码:", @"所在地区:", @"详细地址:", @"邮政编码:"];
    }
    
    return _titles;
}

- (NSArray *)textFields {
    
    if (!_textFields) {
        
        _textFields = @[self.receiverNameTextField, self.phoneNumTextField, self.locationTextField, self.desLocationTextField, self.postCodeTextField];
    }
    
    return _textFields;
}

- (UITextField *)receiverNameTextField {
    
    if (!_receiverNameTextField) {
        
        _receiverNameTextField = [[UITextField alloc] init];
        _receiverNameTextField.placeholder = @"必填";
    }
    
    return _receiverNameTextField;
}

- (UITextField *)phoneNumTextField {
    
    if (!_phoneNumTextField) {
        
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.placeholder = @"必填";
    }
    
    return _phoneNumTextField;
}

- (UITextField *)locationTextField {
    
    if (!_locationTextField) {
        
        _locationTextField = [[UITextField alloc] init];
        _locationTextField.placeholder = @"必填";
    }
    
    return _locationTextField;
}

- (UITextField *)desLocationTextField {
    
    if (!_desLocationTextField) {
        
        _desLocationTextField = [[UITextField alloc] init];
        _desLocationTextField.placeholder = @"必填";
    }
    
    return _desLocationTextField;
}

- (UITextField *)postCodeTextField {
    
    if (!_postCodeTextField) {
        
        _postCodeTextField = [[UITextField alloc] init];
        _postCodeTextField.placeholder = @"必填";
    }
    
    return _postCodeTextField;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 100.0f)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = UIColorFromRGB(0x33d2b4);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 6.0f;
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:21.0f];
        [btn addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:btn];
        
        {
            [_bottomView addConstraint:[btn autoAlignAxisToSuperviewAxis:ALAxisVertical]];
            [_bottomView addConstraint:[btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
            [_bottomView addConstraints:[btn autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 30.0f, 50.0f)]];
        }
    }
    
    return _bottomView;
}

//- (UIScrollView *)contentScrollView
//{
//    if (!_contentScrollView) {
//        _contentScrollView = [[UIScrollView alloc] init];
//    }
//    return _contentScrollView;
//}
//
//- (UIView *)recipientsContainerView
//{
//    if (!_recipientsContainerView) {
//        _recipientsContainerView = [[UIView alloc] init];
//        _recipientsContainerView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
//        _recipientsContainerView.layer.cornerRadius = 3.0f;
//        _recipientsContainerView.layer.masksToBounds = YES;
//    }
//    return _recipientsContainerView;
//}
//
//- (EXUILabel *)recipientsLabel
//{
//    if (!_recipientsLabel) {
//        _recipientsLabel = [[EXUILabel alloc] init];
//        _recipientsLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        _recipientsLabel.font = [UIFont systemFontOfSize:14.0f];
//        [_recipientsLabel setText:@"收件人"];
//    }
//    return _recipientsLabel;
//}
//
//- (UITextView *)recipientsTextField
//{
//    if (!_recipientsTextField) {
//        _recipientsTextField = [[UITextView alloc] init];
//        _recipientsTextField.layer.borderColor = [[SkinManager sharedInstance].defaultLightGrayColor CGColor];
//        _recipientsTextField.layer.borderWidth = 0.5f;
//    }
//    return _recipientsTextField;
//}
//
//- (UIView *)mobileContainerView
//{
//    if (!_mobileContainerView) {
//        _mobileContainerView = [[UIView alloc] init];
//        _mobileContainerView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
//        _mobileContainerView.layer.cornerRadius = 3.0f;
//        _mobileContainerView.layer.masksToBounds = YES;
//    }
//    return _mobileContainerView;
//}
//
//- (EXUILabel *)mobileLabel
//{
//    if (!_mobileLabel) {
//        _mobileLabel = [[EXUILabel alloc] init];
//        _mobileLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        _mobileLabel.font = [UIFont systemFontOfSize:14.0f];
//        [_mobileLabel setText:@"联系电话"];
//    }
//    return _mobileLabel;
//}
//
//- (UITextView *)mobileTextField
//{
//    if (!_mobileTextField) {
//        _mobileTextField = [[UITextView alloc] init];
//        _mobileTextField.layer.borderColor = [[SkinManager sharedInstance].defaultLightGrayColor CGColor];
//        _mobileTextField.layer.borderWidth = 0.5f;
//        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
//    }
//    return _mobileTextField;
//}
//
//- (UIView *)postCodeContainerView
//{
//    if (!_postCodeContainerView) {
//        _postCodeContainerView = [[UIView alloc] init];
//        _postCodeContainerView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
//        _postCodeContainerView.layer.cornerRadius = 3.0f;
//        _postCodeContainerView.layer.masksToBounds = YES;
//    }
//    return _postCodeContainerView;
//}
//
//- (EXUILabel *)postCodeLabel
//{
//    if (!_postCodeLabel) {
//        _postCodeLabel = [[EXUILabel alloc] init];
//        _postCodeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        _postCodeLabel.font = [UIFont systemFontOfSize:14.0f];
//        [_postCodeLabel setText:@"邮编"];
//    }
//    return _postCodeLabel;
//}
//
//- (UITextView *)postCodeTextField
//{
//    if (!_postCodeTextField) {
//        _postCodeTextField = [[UITextView alloc] init];
//        _postCodeTextField.layer.borderColor = [[SkinManager sharedInstance].defaultLightGrayColor CGColor];
//        _postCodeTextField.layer.borderWidth = 0.5f;
//        _postCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
//    }
//    return _postCodeTextField;
//}
//
//- (UIView *)addressContainerView
//{
//    if (!_addressContainerView) {
//        _addressContainerView = [[UIView alloc] init];
//        _addressContainerView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
//        _addressContainerView.layer.cornerRadius = 3.0f;
//        _addressContainerView.layer.masksToBounds = YES;
//    }
//    return _addressContainerView;
//}
//
//- (EXUILabel *)addressLabel
//{
//    if (!_addressLabel) {
//        _addressLabel = [[EXUILabel alloc] init];
//        _addressLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        _addressLabel.font = [UIFont systemFontOfSize:14.0f];
//        [_addressLabel setText:@"收件人地址"];
//    }
//    return _addressLabel;
//}
//
//- (UITextView *)addressTextField
//{
//    if (!_addressTextField) {
//        _addressTextField = [[UITextView alloc] init];
//        _addressTextField.layer.borderColor = [[SkinManager sharedInstance].defaultLightGrayColor CGColor];
//        _addressTextField.layer.borderWidth = 0.5f;
//    }
//    return _addressTextField;
//}
//
//- (UIButton *)confirmButton
//{
//    if (!_confirmButton) {
//        _confirmButton = [[SkinManager sharedInstance] createDefaultButton];
//        _confirmButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
//        [_confirmButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
//        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
//        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _confirmButton;
//}
//

#pragma mark - Private Method

//- (void)setupSubviews
//{
//    [self.view addSubview:self.contentScrollView];
//    
//    [self.contentScrollView addSubview:self.recipientsContainerView];
//        [self.recipientsContainerView addSubview:self.recipientsLabel];
//        [self.recipientsContainerView addSubview:self.recipientsTextField];
//    [self.contentScrollView addSubview:self.mobileContainerView];
//        [self.mobileContainerView addSubview:self.mobileLabel];
//        [self.mobileContainerView addSubview:self.mobileTextField];
//    [self.contentScrollView addSubview:self.postCodeContainerView];
//        [self.postCodeContainerView addSubview:self.postCodeLabel];
//        [self.postCodeContainerView addSubview:self.postCodeTextField];
//    [self.contentScrollView addSubview:self.addressContainerView];
//        [self.addressContainerView addSubview:self.addressLabel];
//        [self.addressContainerView addSubview:self.addressTextField];
//    [self.contentScrollView addSubview:self.confirmButton];
//    
//    [self setupConstraints];
//}
//
//- (void)setupConstraints
//{
//    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
//    
//    [self.contentScrollView addConstraints:[self.recipientsContainerView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
//    [self.contentScrollView addConstraints:[self.mobileContainerView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
//    [self.contentScrollView addConstraints:[self.postCodeContainerView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
//    [self.contentScrollView addConstraints:[self.addressContainerView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 138.0f)]];
//    [self.contentScrollView addConstraints:[self.confirmButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
//    
//    [self.contentScrollView addConstraint:[self.recipientsContainerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.recipientsContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.recipientsContainerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
//    {
//        [self.recipientsContainerView addConstraint:[self.recipientsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.recipientsContainerView withOffset:10.0f]];
//        [self.recipientsContainerView addConstraint:[self.recipientsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.recipientsContainerView withOffset:10.0f]];
//        [self.recipientsContainerView addConstraints:[self.recipientsTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 100.0f, 10.0f, 10.0f)]];
//    }
//    [self.contentScrollView addConstraint:[self.mobileContainerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.mobileContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.recipientsContainerView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.mobileContainerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
//    {
//        [self.mobileContainerView addConstraint:[self.mobileLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.mobileContainerView withOffset:10.0f]];
//        [self.mobileContainerView addConstraint:[self.mobileLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.mobileContainerView withOffset:10.0f]];
//        [self.mobileContainerView addConstraints:[self.mobileTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 100.0f, 10.0f, 10.0f)]];
//    }
//    [self.contentScrollView addConstraint:[self.postCodeContainerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.postCodeContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileContainerView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.postCodeContainerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
//    {
//        [self.postCodeContainerView addConstraint:[self.postCodeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.postCodeContainerView withOffset:10.0f]];
//        [self.postCodeContainerView addConstraint:[self.postCodeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.postCodeContainerView withOffset:10.0f]];
//        [self.postCodeContainerView addConstraints:[self.postCodeTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 100.0f, 10.0f, 10.0f)]];
//    }
//    [self.contentScrollView addConstraint:[self.addressContainerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.addressContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.postCodeContainerView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.addressContainerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
//    {
//        [self.addressContainerView addConstraint:[self.addressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.addressContainerView withOffset:10.0f]];
//        [self.addressContainerView addConstraint:[self.addressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.addressContainerView withOffset:10.0f]];
//        [self.addressContainerView addConstraints:[self.addressTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 100.0f, 10.0f, 10.0f)]];
//    }
//    [self.contentScrollView addConstraint:[self.confirmButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addressContainerView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.confirmButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
//}


#pragma mark - Selector

- (void)confirmButtonClicked:(id)sender
{
//    @property (nonatomic, strong) UITextField *receiverNameTextField;
//    @property (nonatomic, strong) UITextField *phoneNumTextField;
//    @property (nonatomic, strong) UITextField *locationTextField;
//    @property (nonatomic, strong) UITextField *desLocationTextField;
//    @property (nonatomic, strong) UITextField *postCodeTextField;
    
    UIAlertView *alertView;
    if (!self.receiverNameTextField.text || [self.receiverNameTextField.text length] == 0) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收件人姓名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.phoneNumTextField.text || [self.phoneNumTextField.text length] == 0) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.locationTextField.text || [self.locationTextField.text length] == 0) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"所在地区不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.desLocationTextField.text || [self.desLocationTextField.text length] == 0) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"详细地址不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.postCodeTextField.text || [self.postCodeTextField.text length] == 0) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮政编码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    
    
    NSString *receiver = [self.receiverNameTextField text];
    NSString *mobile = [self.phoneNumTextField text];
    NSString *postcode = [self.postCodeTextField text];
    NSString *address = [NSString stringWithFormat:@"%@%@", self.locationTextField.text, self.desLocationTextField];
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncApplyNameCardWithReceiver:receiver withPhone:mobile withPostcode:postcode withAddress:address withCompletionHandler:^(BOOL isSuccess) {
        [self dismissLoading];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
        [alertView show];
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)cardButtonClicked:(id)sender
{
    QRCodeCardViewController *qrCodeCardVC = [[QRCodeCardViewController alloc] init];
    UINavigationController *nav = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:qrCodeCardVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
