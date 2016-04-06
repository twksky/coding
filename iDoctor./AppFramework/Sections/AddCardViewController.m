//
//  AddCardViewController.m
//  AppFramework
//
//  Created by ABC on 7/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "AddCardViewController.h"
#import "UIView+AutoLayout.h"
#import "SkinManager.h"
#import "EXUILabel.h"
#import "EXUITextField.h"
#import "WithdrawalViewControllerStep3.h"
#import "AccountManager.h"

@interface AddCardViewController ()

@property (nonatomic, strong) EXUILabel     *cardNumberTipLabel;
@property (nonatomic, strong) EXUITextField *cardNumberTextField;
@property (nonatomic, strong) EXUILabel     *nameTipLabel;
@property (nonatomic, strong) EXUITextField *nameTextField;
@property (nonatomic, strong) UIButton      *defaultCardCheckButton;
@property (nonatomic, strong) UIButton      *nextButton;

@property (nonatomic, assign) CGFloat       moneyCache;
@property (nonatomic, assign) CGFloat       actualMoneyCache;

- (void)setupSubviews;
- (void)setupConstraints;

// Selector
- (void)defaultCardButtonChecked:(UIButton *)sender;
- (void)nextButtonClicked:(UIButton *)sender;

@end

@implementation AddCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMoney:(CGFloat)money withActualMoney:(CGFloat)actualMoney
{
    self = [super init];
    if (self) {
        self.moneyCache = money;
        self.actualMoneyCache = actualMoney;
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
    self.title = @"添加银行卡";
    
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
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

- (EXUILabel *)cardNumberTipLabel
{
    if (!_cardNumberTipLabel) {
        _cardNumberTipLabel = [[EXUILabel alloc] init];
        _cardNumberTipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        [_cardNumberTipLabel setText:@"请输入您的卡号："];
    }
    return _cardNumberTipLabel;
}

- (EXUITextField *)cardNumberTextField
{
    if (!_cardNumberTextField) {
        _cardNumberTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardNumberTextField;
}

- (EXUILabel *)nameTipLabel
{
    if (!_nameTipLabel) {
        _nameTipLabel = [[EXUILabel alloc] init];
        _nameTipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        [_nameTipLabel setText:@"请输入账号姓名："];
    }
    return _nameTipLabel;
}

- (EXUITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[SkinManager sharedInstance] createDefaultTextField];
    }
    return _nameTextField;
}

- (UIButton *)defaultCardCheckButton
{
    if (!_defaultCardCheckButton) {
        _defaultCardCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultCardCheckButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_defaultCardCheckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_defaultCardCheckButton setTitle:@"将此卡设为常用银行卡" forState:UIControlStateNormal];
        [_defaultCardCheckButton setImage:[UIImage imageNamed:@"icon_pay_unchecked.png"] forState:UIControlStateNormal];
        [_defaultCardCheckButton setImage:[UIImage imageNamed:@"icon_pay_checked.png"] forState:UIControlStateSelected];
        [_defaultCardCheckButton setSelected:YES];
        [_defaultCardCheckButton addTarget:self action:@selector(defaultCardButtonChecked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultCardCheckButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[SkinManager sharedInstance] createDefaultButton];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [_nextButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.cardNumberTipLabel];
    [self.view addSubview:self.cardNumberTextField];
    [self.view addSubview:self.nameTipLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.defaultCardCheckButton];
    [self.view addSubview:self.nextButton];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraint:[self.cardNumberTipLabel autoSetDimension:ALDimensionHeight toSize:45.0f]];
    [self.view addConstraint:[self.cardNumberTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.cardNumberTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.cardNumberTipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.cardNumberTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.view addConstraint:[self.cardNumberTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.cardNumberTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cardNumberTipLabel withOffset:0.0f]];
    [self.view addConstraint:[self.cardNumberTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.nameTipLabel autoSetDimension:ALDimensionHeight toSize:43.0f]];
    [self.view addConstraint:[self.nameTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.nameTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cardNumberTextField withOffset:0.0f]];
    [self.view addConstraint:[self.nameTipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.nameTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.view addConstraint:[self.nameTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.nameTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameTipLabel withOffset:0.0f]];
    [self.view addConstraint:[self.nameTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraint:[self.nextButton autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.view addConstraint:[self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
    [self.view addConstraint:[self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameTextField withOffset:63.0f]];
    [self.view addConstraint:[self.nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    
    [self.view addConstraints:[self.defaultCardCheckButton autoSetDimensionsToSize:CGSizeMake(200.0f, 25.0f)]];
    [self.view addConstraint:[self.defaultCardCheckButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    [self.view addConstraint:[self.defaultCardCheckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameTextField withOffset:10.0f]];
    
}


#pragma mark - Selector

- (void)defaultCardButtonChecked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)nextButtonClicked:(UIButton *)sender
{
    NSString *bankcardID = [self.cardNumberTextField text];
    NSString *bankcardName = [self.nameTextField text];
    BOOL isDefaultBankcard = (UIControlStateSelected == [self.defaultCardCheckButton state]);
    [[AccountManager sharedInstance] asyncAddBankcard:bankcardID withCardName:bankcardName withCardType:@"" withDefaultCard:isDefaultBankcard withCompletionHandler:^(Bankcard *bankcard) {
        WithdrawalViewControllerStep3 *withdrawalVCStep3 = [[WithdrawalViewControllerStep3 alloc] initWithBankcard:bankcard withMoney:self.moneyCache withActualMoney:self.actualMoneyCache];
        [self.navigationController pushViewController:withdrawalVCStep3 animated:YES];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

@end
