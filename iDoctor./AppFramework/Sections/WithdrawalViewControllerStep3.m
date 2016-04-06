//
//  WithdrawalViewControllerStep3.m
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "WithdrawalViewControllerStep3.h"
#import "UIView+AutoLayout.h"
#import "SkinManager.h"
#import "EXUILabel.h"
#import "TTTAttributedLabel.h"
#import "AccountManager.h"

@interface WithdrawalViewControllerStep3 ()
<
UIAlertViewDelegate
>

@property (nonatomic, strong) TTTAttributedLabel *previewLabel;
@property (nonatomic, strong) EXUILabel *tipLabel;

@property (nonatomic, strong) UILabel *cardNumberTitle;
@property (nonatomic, strong) UILabel *cardNumberValueLabel;
@property (nonatomic, strong) UILabel *cardOwnerTitle;
@property (nonatomic, strong) UILabel *cardOwnerNameLabel;;
@property (nonatomic, strong) UILabel *moneyTitle;
@property (nonatomic, strong) UILabel *moneyValueLabel;


@property (nonatomic, strong) UIButton  *confirmButton;
@property (nonatomic, strong) UIButton  *reviseButton;

@property (nonatomic, strong) Bankcard  *bankcardCache;
@property (nonatomic, assign) CGFloat   moneyCache;

- (void)setupSubviews;
- (void)setupConstraints;

- (NSAttributedString *)formatPreviewAttributedStringWithBank:(NSString *)bankName withCardType:(NSInteger)cardType withCardID:(NSString *)cardID withName:(NSString *)name withWithMoney:(CGFloat)money;

// Selector
- (void)confirmButtonClicked:(UIButton *)sender;
- (void)reviseButtonClicked:(UIButton *)sender;

@end

@implementation WithdrawalViewControllerStep3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBankcard:(Bankcard *)bankcard withMoney:(CGFloat)money withActualMoney:(CGFloat)actualMoney
{
    self = [super init];
    if (self) {
        self.bankcardCache = bankcard;
        self.moneyCache = money;
//        NSAttributedString *previewAttributedString = [self formatPreviewAttributedStringWithBank:bankcard.cardName withCardType:0 withCardID:bankcard.cardID withName:bankcard.cardName withWithMoney:actualMoney];
//        [self.previewLabel setAttributedText:previewAttributedString];
        self.moneyValueLabel.text = [NSString stringWithFormat:@"%.02f元", actualMoney];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    [self setNavigationBarWithTitle:@"银行卡信息" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
//    self.title = @"提现";
    
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

- (TTTAttributedLabel *)previewLabel
{
    if (!_previewLabel) {
        _previewLabel = [[TTTAttributedLabel alloc] init];
        //_previewLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
        _previewLabel.textInsets = UIEdgeInsetsMake(8.0f, 10.0f, 8.0f, 10.0f);
        _previewLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _previewLabel.numberOfLines = 0;
        _previewLabel.layer.cornerRadius = 3.0f;
        _previewLabel.layer.backgroundColor = [[SkinManager sharedInstance].defaultWhiteColor CGColor];
    }
    return _previewLabel;
}

- (EXUILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[EXUILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0x8f8e94);
        _tipLabel.font = [UIFont systemFontOfSize:12.0f];
//        NSString *tipString = @"*此次提现金额将在三个工作日内到账";
//        NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
//        NSMutableAttributedString *tipAttributedString = [[NSMutableAttributedString alloc] initWithString:tipString attributes:attributedDic];
//        [tipAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
//        [_tipLabel setAttributedText:tipAttributedString];
        _tipLabel.text = @"我们将在3-5个工作日内给您打款, 请您耐心等待";
    }
    return _tipLabel;
}

- (UILabel *)cardNumberTitle {
    
    if (!_cardNumberTitle) {
        
        _cardNumberTitle = [self titleLabel];
        _cardNumberTitle.text = @"卡号";
    }
    
    return _cardNumberTitle;
}

- (UILabel *)cardNumberValueLabel {
    
    if (!_cardNumberValueLabel) {
        
        _cardNumberValueLabel = [self valueLabel];
        _cardNumberValueLabel.text = self.bankcardCache.cardID;
    }
    
    return _cardNumberValueLabel;
}

- (UILabel *)cardOwnerTitle {
    
    if (!_cardOwnerTitle) {
        
        _cardOwnerTitle = [self titleLabel];
        _cardOwnerTitle.text = @"持卡人";
    }
    
    return _cardOwnerTitle;
}

- (UILabel *)cardOwnerNameLabel {
    
    if (!_cardOwnerNameLabel) {
        
        _cardOwnerNameLabel = [self valueLabel];
        _cardOwnerNameLabel.text = self.bankcardCache.cardName;
    }
    
    return _cardOwnerNameLabel;
}

- (UILabel *)moneyTitle {
    
    if (!_moneyTitle) {
        
        _moneyTitle = [self titleLabel];
        _moneyTitle.text = @"实际提现金额";
    }
    
    return _moneyTitle;
}

- (UILabel *)moneyValueLabel {
    
    if (!_moneyValueLabel) {
        
        _moneyValueLabel = [self valueLabel];
    }
    
    return _moneyValueLabel;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[SkinManager sharedInstance] createDefaultV3GreenButton];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)reviseButton
{
    if (!_reviseButton) {
        _reviseButton = [[SkinManager sharedInstance] createDefaultV3GreenButton];
        _reviseButton.backgroundColor = UIColorFromRGB(0xff6866);
        [_reviseButton setTitle:@"取消" forState:UIControlStateNormal];
        [_reviseButton addTarget:self action:@selector(reviseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reviseButton;
}


#pragma mark - Private Method

- (UILabel *)titleLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x8f8e94);
    label.font = [UIFont systemFontOfSize:19.0f];
    
    return label;
}

- (UILabel *)valueLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:19.0f];
    
    return label;
}

- (void)setupSubviews
{
//    [self.view addSubview:self.previewLabel];
//    [self.view addSubview:self.tipLabel];
//    [self.view addSubview:self.confirmButton];
//    [self.view addSubview:self.reviseButton];
//    
//    [self setupConstraints];
    UIView *contentView = self.view;
    
    UIView *cardNumberOwnerContainer = [[UIView alloc] init];
    cardNumberOwnerContainer.backgroundColor = [UIColor whiteColor];
    cardNumberOwnerContainer.layer.cornerRadius = 6.0f;
    cardNumberOwnerContainer.layer.borderWidth = 0.7f;
    cardNumberOwnerContainer.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    
    [contentView addSubview:cardNumberOwnerContainer];
    {
        [contentView addConstraint:[cardNumberOwnerContainer autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [contentView addConstraint:[cardNumberOwnerContainer autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraint:[cardNumberOwnerContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [contentView addConstraint:[cardNumberOwnerContainer autoSetDimension:ALDimensionHeight toSize:120.0f]];
    }
    
    UIImageView *hLine = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    [cardNumberOwnerContainer addSubview:hLine];
    {
        [cardNumberOwnerContainer addConstraint:[hLine autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [cardNumberOwnerContainer addConstraint:[hLine autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [cardNumberOwnerContainer addConstraints:[hLine autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 0.7f)]];
    }
    
    [cardNumberOwnerContainer addSubview:self.cardNumberTitle];
    {
        [cardNumberOwnerContainer addConstraint:[self.cardNumberTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [cardNumberOwnerContainer addConstraint:[self.cardNumberTitle autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3.0f]];
        [cardNumberOwnerContainer addConstraint:[self.cardNumberTitle autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:hLine withOffset:-3.0f]];
    }
    
    [cardNumberOwnerContainer addSubview:self.cardNumberValueLabel];
    {
        [cardNumberOwnerContainer addConstraint:[self.cardNumberValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.cardNumberTitle]];
        [cardNumberOwnerContainer addConstraint:[self.cardNumberValueLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.cardNumberTitle withOffset:30.0f]];
    }
    
    [cardNumberOwnerContainer addSubview:self.cardOwnerTitle];
    {
        [cardNumberOwnerContainer addConstraint:[self.cardOwnerTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:hLine withOffset:3.0f]];
        [cardNumberOwnerContainer addConstraint:[self.cardOwnerTitle autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:3.0f]];
        [cardNumberOwnerContainer addConstraint:[self.cardOwnerTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [cardNumberOwnerContainer addSubview:self.cardOwnerNameLabel];
    {
        [cardNumberOwnerContainer addConstraint:[self.cardOwnerNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.cardOwnerTitle]];
        [cardNumberOwnerContainer addConstraint:[self.cardOwnerNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.cardNumberValueLabel]];
    }
    
    UIView *moneyContainerView = [[UIView alloc] init];
    moneyContainerView.backgroundColor = [UIColor whiteColor];
    moneyContainerView.layer.cornerRadius = 6.0f;
    moneyContainerView.layer.borderWidth = 0.7f;
    moneyContainerView.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    
    [contentView addSubview:moneyContainerView];
    {
        [contentView addConstraint:[moneyContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cardNumberOwnerContainer withOffset:10.0f]];
        [contentView addConstraint:[moneyContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraint:[moneyContainerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [contentView addConstraint:[moneyContainerView autoSetDimension:ALDimensionHeight toSize:60.0f]];
    }
    
    [moneyContainerView addSubview:self.moneyTitle];
    {
        [moneyContainerView addConstraint:[self.moneyTitle autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [moneyContainerView addConstraint:[self.moneyTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [moneyContainerView addSubview:self.moneyValueLabel];
    {
        [moneyContainerView addConstraint:[self.moneyValueLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.moneyTitle withOffset:30.0f]];
        [moneyContainerView addConstraint:[self.moneyValueLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    
    [contentView addSubview:self.tipLabel];
    {
        [contentView addConstraint:[self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraint:[self.tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:moneyContainerView withOffset:10.0f]];
    }
    
    [contentView addSubview:self.confirmButton];
    {
        [contentView addConstraint:[self.confirmButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
        [contentView addConstraint:[self.confirmButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
        [contentView addConstraint:[self.confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:20.0f]];
        [contentView addConstraint:[self.confirmButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    }
    
    [contentView addSubview:self.reviseButton];
    {
        [contentView addConstraint:[self.reviseButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
        [contentView addConstraint:[self.reviseButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
        [contentView addConstraint:[self.reviseButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmButton withOffset:15.0f]];
        [contentView addConstraint:[self.reviseButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    }
}

- (void)setupConstraints
{
    //[self.view addConstraint:[self.previewLabel autoSetDimension:ALDimensionHeight toSize:221.0f]];
    [self.view addConstraint:[self.previewLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.previewLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.previewLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.previewLabel withOffset:10.0f]];
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.confirmButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
    [self.view addConstraint:[self.confirmButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:11.0f]];
    [self.view addConstraint:[self.confirmButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.reviseButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
    [self.view addConstraint:[self.reviseButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.reviseButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmButton withOffset:15.0f]];
    [self.view addConstraint:[self.reviseButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
}

- (NSAttributedString *)formatPreviewAttributedStringWithBank:(NSString *)bankName withCardType:(NSInteger)cardType withCardID:(NSString *)cardID withName:(NSString *)name withWithMoney:(CGFloat)money
{
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *cardTypeAttributedString =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"卡类型：\n%@ 储蓄卡\n\n", bankName] attributes:attributedDic];
    [cardTypeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 4)];
    
    NSMutableAttributedString *cardIDAttributedString =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"卡号：\n%@\n\n", cardID] attributes:attributedDic];
    [cardIDAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 3)];
    
    NSMutableAttributedString *nameAttributedString =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"姓名：\n%@\n\n", name] attributes:attributedDic];
    [nameAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 3)];
    
    money = money / 100.0f; // 换算成元
    NSMutableAttributedString *moneyAttributedString =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"此次实际提现金额：\n%.02f元", money] attributes:attributedDic];
    [moneyAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 9)];
    
    NSMutableAttributedString *prviewAttributedString = [[NSMutableAttributedString alloc] init];
    [prviewAttributedString appendAttributedString:cardTypeAttributedString];
    [prviewAttributedString appendAttributedString:cardIDAttributedString];
    [prviewAttributedString appendAttributedString:nameAttributedString];
    [prviewAttributedString appendAttributedString:moneyAttributedString];
    return prviewAttributedString;
}


#pragma mark - Selector

- (void)confirmButtonClicked:(UIButton *)sender
{
    
    CGFloat money = self.moneyCache * 100.0f;
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncWithdrawal:money withBankAccount:self.bankcardCache.cardID withCompletionHandler:^(long balance) {
        [self dismissLoading];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提现成功" message:[NSString stringWithFormat:@"提现金额将在3-5个工作日内到账"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
        [alertView show];
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)reviseButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
