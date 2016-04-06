//
//  WithdrawalViewControllerStep2.m
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "WithdrawalViewControllerStep2.h"
#import "SkinManager.h"
#import "EXUILabel.h"
#import "EXUITextField.h"
#import "UIView+AutoLayout.h"
#import "WithdrawalViewControllerStep3.h"
#import "AddCardViewController.h"
#import "AccountManager.h"
#import "TTTAttributedLabel.h"

@interface WithdrawalViewControllerStep2 ()
<
UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate
>
{
    CGFloat platformRatio;
    CGFloat thirdPlatformRatio;
    CGFloat doctorPlatformRatio;
}

@property (nonatomic, strong) EXUILabel         *balanceLabel;
@property (nonatomic, strong) UIView            *moneyInputView;
@property (nonatomic, strong) EXUITextField              *moneyTextField;
@property (nonatomic, strong) TTTAttributedLabel         *tipLabel;
@property (nonatomic, strong) TTTAttributedLabel         *stipulationLabel;
@property (nonatomic, strong) UITableView       *cardTableView;

@property (nonatomic, strong) NSMutableArray    *bankCardArray;
@property (nonatomic, assign) CGFloat           accountBalance;

- (void)setupSubviews;
- (void)setupConstraints;

- (NSAttributedString *)formatBalanceWithBalance:(CGFloat)balance;
- (NSAttributedString *)formatStipulationWithMoney:(CGFloat)money;
- (NSString *)float2Percentage:(CGFloat)floatValue;
- (CGFloat)calculateSummyMoney:(CGFloat)money;

// Selector
- (void)addCardButtonClicked:(UIButton *)sender;
- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation WithdrawalViewControllerStep2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        platformRatio = 0.0f;
        thirdPlatformRatio = 0.0f;
        doctorPlatformRatio = 0.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    self.title = @"提现";
 
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 获取提现参数
    [[AccountManager sharedInstance] asyncGetWithdrawalParamWithCompletionHandler:^(WithdrawalParam *withdrawalParam) {
        platformRatio = withdrawalParam.platformRate / 100.0f;
        thirdPlatformRatio = withdrawalParam.bankRate / 100.0f;
        doctorPlatformRatio = (withdrawalParam.platformRate - withdrawalParam.bankRate) / 100.0f;
        [self.stipulationLabel setAttributedText:[self formatStipulationWithMoney:0.0f]];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
    // 获取余额
    [[AccountManager sharedInstance] asyncGetBalanceWithCompletionHandler:^(long balance) {
        self.accountBalance = balance;  // 缓存起来做检测用
        [self.balanceLabel setAttributedText:[self formatBalanceWithBalance:balance]];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
    // 获取银行卡列表
    [[AccountManager sharedInstance] asyncGetBankcardListWithCompletionHandler:^(NSArray *bankcardArray) {
        [self.bankCardArray removeAllObjects];
        [self.bankCardArray addObjectsFromArray:bankcardArray];
        [self.cardTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
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

- (EXUILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[EXUILabel alloc] init];
        _balanceLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
    }
    return _balanceLabel;
}

- (UIView *)moneyInputView
{
    if (!_moneyInputView) {
        _moneyInputView = [[UIView alloc] init];
        
        EXUILabel *inputTipLabel = [[EXUILabel alloc] init];
        inputTipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        [inputTipLabel setText:@"您要提现："];
        [_moneyInputView addSubview:inputTipLabel];
        
        [_moneyInputView addSubview:self.moneyTextField];
        
        EXUILabel *moneyTipLabel = [[EXUILabel alloc] init];
        moneyTipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        [moneyTipLabel setText:@"元"];
        [_moneyInputView addSubview:moneyTipLabel];
        
        {
            // AutoLayout
            [_moneyInputView addConstraint:[inputTipLabel autoSetDimension:ALDimensionWidth toSize:90.0f]];
            [_moneyInputView addConstraint:[moneyTipLabel autoSetDimension:ALDimensionWidth toSize:25.0f]];
            [_moneyInputView addConstraint:[inputTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[inputTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[self.moneyTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[moneyTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[moneyTipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[moneyTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[self.moneyTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[inputTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_moneyInputView withOffset:0.0f]];
            [_moneyInputView addConstraint:[inputTipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.moneyTextField withOffset:0.0f]];
            [_moneyInputView addConstraint:[self.moneyTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:moneyTipLabel withOffset:0.0f]];
        }
    }
    return _moneyInputView;
}

- (EXUITextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _moneyTextField.delegate = self;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _moneyTextField;
}

- (TTTAttributedLabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[TTTAttributedLabel alloc] init];
        _tipLabel.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _tipLabel.textColor = [SkinManager sharedInstance].defaultGrayColor;
        _tipLabel.font = [UIFont systemFontOfSize:10.0f];
        _tipLabel.textInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
        [_tipLabel setText:@"为减少相关手续费用，建议使用本人的交通银行卡来提现。"];
    }
    return _tipLabel;
}

- (TTTAttributedLabel *)stipulationLabel
{
    if (!_stipulationLabel) {
        _stipulationLabel = [[TTTAttributedLabel alloc] init];
        _stipulationLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _stipulationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _stipulationLabel.numberOfLines = 0;
        [_stipulationLabel setAttributedText:[self formatStipulationWithMoney:0.0f]];
    }
    return _stipulationLabel;
}

- (UITableView *)cardTableView
{
    if (!_cardTableView) {
        _cardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _cardTableView.dataSource = self;
        _cardTableView.delegate = self;
        if (IOS_VERSION >= 7.0) {
            _cardTableView.contentInset = UIEdgeInsetsMake(-35.0f, 0.0f, 0.0f, 0.0f);
        }
        _cardTableView.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
    }
    return _cardTableView;
}

- (NSMutableArray *)bankCardArray
{
    if (!_bankCardArray) {
        _bankCardArray = [[NSMutableArray alloc] init];
    }
    return _bankCardArray;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.moneyInputView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.stipulationLabel];
    [self.view addSubview:self.cardTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraint:[self.balanceLabel autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.view addConstraint:[self.balanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.balanceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.balanceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.moneyInputView autoSetDimension:ALDimensionHeight toSize:32.0f]];
    [self.view addConstraint:[self.moneyInputView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.moneyInputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.balanceLabel withOffset:4.0f]];
    [self.view addConstraint:[self.moneyInputView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.tipLabel autoSetDimension:ALDimensionHeight toSize:20.0f]];
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.moneyInputView withOffset:10.0f]];
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
    
    [self.view addConstraint:[self.stipulationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.stipulationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:10.0f]];
    [self.view addConstraint:[self.stipulationLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.cardTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.cardTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stipulationLabel withOffset:0.0f]];
    [self.view addConstraint:[self.cardTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.cardTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.0f]];
}

- (NSAttributedString *)formatBalanceWithBalance:(CGFloat)balance
{
    // balance的单位是分
    NSString *balanceString = [NSString stringWithFormat:@"您的账户余额%.02f元", balance / 100.0f];
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:balanceString attributes:attributedDic];
    [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];
    [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[balanceString rangeOfString:@"元"]];
    return balanceAttributedString;
}

- (NSAttributedString *)formatStipulationWithMoney:(CGFloat)money
{
    CGFloat summyMoney = [self calculateSummyMoney:money];
    
    NSString *textFormat = @"*此次您申请提现%@元，我们将收取%@作为平台管理费用，其中，支付提现第三方平台%@，我爱好医生平台%@。";
    NSString *moneyText = [NSString stringWithFormat:@"%.02f", money];
    NSString *platformRatioString = [self float2Percentage:platformRatio];
    NSString *thirdPlatformRatioString = [self float2Percentage:thirdPlatformRatio];
    NSString *doctorPlatformRatioString = [self float2Percentage:doctorPlatformRatio];
    NSString *summyText = [NSString stringWithFormat:textFormat, moneyText, platformRatioString, thirdPlatformRatioString, doctorPlatformRatioString];
    NSString *summyMoneyString = [NSString stringWithFormat:@"%.02f", summyMoney];
    NSString *summyMoneyText = [NSString stringWithFormat:@"\n所以您此次最终可提现实际金额为%@元。", summyMoneyString];
    
    NSDictionary *textAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,
                                       [UIFont systemFontOfSize:15.0f], NSFontAttributeName, nil];
    NSDictionary *highlightAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:[SkinManager sharedInstance].defaultHighlightBackgroundColor, NSForegroundColorAttributeName,
                                            [UIFont systemFontOfSize:22.0f], NSFontAttributeName, nil];
    NSMutableAttributedString *summyAttributedString = [[NSMutableAttributedString alloc] initWithString:summyText attributes:textAttributesDic];
    [summyAttributedString addAttributes:highlightAttributesDic range:[summyText rangeOfString:moneyText]];
    [summyAttributedString addAttributes:highlightAttributesDic range:[summyText rangeOfString:platformRatioString]];
    [summyAttributedString addAttributes:highlightAttributesDic range:[summyText rangeOfString:thirdPlatformRatioString]];
    [summyAttributedString addAttributes:highlightAttributesDic range:[summyText rangeOfString:doctorPlatformRatioString]];
    NSMutableAttributedString *summyMoneyAttributedString = [[NSMutableAttributedString alloc] initWithString:summyMoneyText attributes:textAttributesDic];
    [summyMoneyAttributedString addAttributes:highlightAttributesDic range:[summyMoneyText rangeOfString:summyMoneyString]];
    
    [summyAttributedString appendAttributedString:summyMoneyAttributedString];
    return summyAttributedString;
}

- (NSString *)float2Percentage:(CGFloat)floatValue
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    // Set to the current locale
    [numberFormatter setLocale:[NSLocale currentLocale]];
    
    // Get percentage of system space that is available
    CGFloat percent = floatValue;
    NSNumber *num = [NSNumber numberWithFloat:percent];
    return [numberFormatter stringFromNumber:num];
}

- (CGFloat)calculateSummyMoney:(CGFloat)money
{
    CGFloat summyMoney = money - money * platformRatio;
    return summyMoney;
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bankCardArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"1905906A-9E58-4B9C-963F-A43A0CEF80D2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
        cell.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
        [cell.imageView setImage:[UIImage imageNamed:@"icon_bankcard.png"]];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];//去掉选中cell时的蓝色背景
    }
    Bankcard *bankCardItem = [self.bankCardArray objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@(%@)", bankCardItem.cardName, bankCardItem.cardID]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *reusableFooterIdentifier = @"72C049BF-EBEC-4566-9BAE-0AC363656EC7";
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableFooterIdentifier];
    if (!footerView) {
        UIView *containerView = [[UIView alloc] init];
        UIButton *addCardButton = [[SkinManager sharedInstance] createDefaultButton];
        addCardButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [addCardButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [addCardButton addTarget:self action:@selector(addCardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addCardButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [containerView addSubview:addCardButton];
        {
            // Autolayout
            [containerView addConstraint:[addCardButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:containerView withOffset:10.0f]];
            [containerView addConstraint:[addCardButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:containerView withOffset:15.0f]];
            [containerView addConstraint:[addCardButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:containerView withOffset:-10.0f]];
            [containerView addConstraint:[addCardButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:containerView withOffset:0.0f]];
        }
        footerView = containerView;
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Bankcard *bankCardItem = [self.bankCardArray objectAtIndex:[indexPath row]];
    CGFloat money = [[self.moneyTextField text] floatValue];
    money = money * 100.0f; // 换算成分
    CGFloat summyMoney = [self calculateSummyMoney:money];
    if (money <= self.accountBalance) {
        WithdrawalViewControllerStep3 *withdrawalVCStep3 = [[WithdrawalViewControllerStep3 alloc] initWithBankcard:bankCardItem withMoney:money withActualMoney:summyMoney];
        [self.navigationController pushViewController:withdrawalVCStep3 animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的金额超过账户余额，请重新输入。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


#pragma mark - Selector

- (void)addCardButtonClicked:(UIButton *)sender
{
    CGFloat money = [[self.moneyTextField text] floatValue];
    money = money * 100.0f; // 换算成分
    CGFloat summyMoney = [self calculateSummyMoney:money];
    if (money <= self.accountBalance) {
        AddCardViewController *addCardViewController = [[AddCardViewController alloc] initWithMoney:money withActualMoney:summyMoney];
        [self.navigationController pushViewController:addCardViewController animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的金额超过账户余额，请重新输入。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.moneyTextField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (basic) {
            NSString *moneyText = nil;
            // Handling 'delete'
            if (range.length == 1 && [string isEqualToString:@""]) {
                moneyText = self.moneyTextField.text;
                moneyText = [moneyText substringToIndex:([moneyText length] - 1)];
            } else {
                moneyText = [self.moneyTextField.text stringByAppendingString:string];
            }
            CGFloat money = [moneyText floatValue];
            money = money * 100.0f; // 换算成分
            basic = money <= self.accountBalance;
            if (basic) {
                [self.stipulationLabel setAttributedText:[self formatStipulationWithMoney:[moneyText floatValue]]];
            }
        }
        return basic;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.moneyTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    //NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

@end
