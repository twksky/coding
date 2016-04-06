//
//  CardAddViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "CardAddViewController.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"

@interface CardAddViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *cardNumberTextField;
@property (nonatomic, strong) UITextField *cardOwnerNameTextField;
@property (nonatomic, strong) UIButton *defaultCardCheckButton;

@end

@implementation CardAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarWithTitle:@"添加银行卡" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xeef1f1);
    
    UIView *cardNumberContainer = [[UIView alloc] init];
    [cardNumberContainer setBackgroundColor:[UIColor whiteColor]];
    cardNumberContainer.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    cardNumberContainer.layer.borderWidth = 1.0f;
    cardNumberContainer.layer.cornerRadius = 6.0f;
    
    UILabel *cardNumberLabel = [[UILabel alloc] init];
    cardNumberLabel.textColor = [UIColor blackColor];
    cardNumberLabel.font = [UIFont systemFontOfSize:17.0f];
    cardNumberLabel.text = @"卡号";
    [cardNumberContainer addSubview:cardNumberLabel];
    [cardNumberContainer addSubview:self.cardNumberTextField];
    
    UIView *cardOwnerNameContainer = [[UIView alloc] init];
    [cardOwnerNameContainer setBackgroundColor:[UIColor whiteColor]];
    cardOwnerNameContainer.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    cardOwnerNameContainer.layer.borderWidth = 1.0f;
    cardOwnerNameContainer.layer.cornerRadius = 6.0f;
    
    UILabel *cardOwnerNameLabel = [[UILabel alloc] init];
    cardOwnerNameLabel.textColor = [UIColor blackColor];
    cardOwnerNameLabel.font = [UIFont systemFontOfSize:17.0f];
    cardOwnerNameLabel.text = @"持卡人";
    [cardOwnerNameContainer addSubview:cardOwnerNameLabel];
    [cardOwnerNameContainer addSubview:self.cardOwnerNameTextField];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setBackgroundColor:UIColorFromRGB(0x33d2b4)];
    [nextBtn setTitle:@"添加" forState:UIControlStateNormal];
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:23.0f];
    nextBtn.layer.cornerRadius = 6.0f;
    [nextBtn addTarget:self action:@selector(saveBankCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cardNumberContainer];
    [self.view addSubview:cardOwnerNameContainer];
    [self.view addSubview:self.defaultCardCheckButton];
    [self.view addSubview:nextBtn];
    
    //AutoLayout
    {
        [self.view addConstraint:[cardNumberContainer autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [self.view addConstraint:[cardNumberContainer autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [self.view addConstraint:[cardNumberContainer autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
        [self.view addConstraint:[cardNumberContainer autoSetDimension:ALDimensionHeight toSize:50.0f]];
        
        
        [cardNumberContainer addConstraint:[cardNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [cardNumberContainer addConstraint:[cardNumberLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [cardNumberContainer addConstraint:[cardNumberLabel autoSetDimension:ALDimensionWidth toSize:50]];
        
        
        
        [cardNumberContainer addConstraint:[self.cardNumberTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cardNumberLabel withOffset:10.0f]];
        [cardNumberContainer addConstraint:[self.cardNumberTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [cardNumberContainer addConstraint:[self.cardNumberTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [cardNumberContainer addConstraint:[self.cardNumberTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];

        
        [self.view addConstraint:[cardOwnerNameContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cardNumberContainer withOffset:10.0f]];
        [self.view addConstraint:[cardOwnerNameContainer autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [self.view addConstraint:[cardOwnerNameContainer autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
        [self.view addConstraint:[cardOwnerNameContainer autoSetDimension:ALDimensionHeight toSize:50.0f]];
        
        [cardOwnerNameContainer addConstraint:[cardOwnerNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [cardOwnerNameContainer addConstraint:[cardOwnerNameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [cardOwnerNameContainer addConstraint:[cardOwnerNameLabel autoSetDimension:ALDimensionWidth toSize:55]];
        
        [cardOwnerNameContainer addConstraint:[self.cardOwnerNameTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cardOwnerNameLabel withOffset:10.0f]];
        [cardOwnerNameContainer addConstraint:[self.cardOwnerNameTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [cardOwnerNameContainer addConstraint:[self.cardOwnerNameTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        
        [self.view addConstraint:[self.defaultCardCheckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cardOwnerNameContainer withOffset:10.0f]];
        [self.view addConstraint:[self.defaultCardCheckButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        
        [self.view addConstraint:[nextBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.defaultCardCheckButton withOffset:20.0f]];
        [self.view addConstraint:[nextBtn autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [self.view addConstraint:[nextBtn autoSetDimension:ALDimensionHeight toSize:50.0f]];
        [self.view addConstraint:[nextBtn autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
        
    }
}

#pragma mark - selector

- (void)saveBankCard:(id)sender {
    
    NSString *bankcardID = [self.cardNumberTextField text];
    NSString *bankOwner = [self.cardOwnerNameTextField text];
    BOOL isDefaultBankcard = (UIControlStateSelected == [self.defaultCardCheckButton state]);
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncAddBankcard:bankcardID withCardName:bankOwner withCardType:@"" withDefaultCard:isDefaultBankcard withCompletionHandler:^(Bankcard *bankcard) {
        [self dismissLoading];
        [self showHint:@"添加成功"];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAddCard:)]) {
            
            [self.delegate didAddCard:bankcard];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
}

- (void)defaultCardButtonChecked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.cardNumberTextField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}



#pragma mark - properties

- (UITextField *)cardNumberTextField {
    
    if (!_cardNumberTextField) {
        
        _cardNumberTextField = [[UITextField alloc] init];
        _cardNumberTextField.delegate = self;
        _cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return _cardNumberTextField;
}

- (UITextField *)cardOwnerNameTextField {
    
    if (!_cardOwnerNameTextField) {
        
        _cardOwnerNameTextField = [[UITextField alloc] init];
    }
    
    return _cardOwnerNameTextField;
}

- (UIButton *)defaultCardCheckButton {
    
    if (!_defaultCardCheckButton) {
        
        _defaultCardCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultCardCheckButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_defaultCardCheckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_defaultCardCheckButton setTitle:@"   将此卡设为常用银行卡" forState:UIControlStateNormal];
        [_defaultCardCheckButton setImage:[UIImage imageNamed:@"icon_pay_unchecked.png"] forState:UIControlStateNormal];
        [_defaultCardCheckButton setImage:[UIImage imageNamed:@"icon_card_default_selected"] forState:UIControlStateSelected];
        [_defaultCardCheckButton setSelected:YES];
        [_defaultCardCheckButton addTarget:self action:@selector(defaultCardButtonChecked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _defaultCardCheckButton;
}

@end









