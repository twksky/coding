//
//  DFDSetPriceViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDSetPriceViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "ImageUtils.h"

@interface DFDSetPriceViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UIView            *contentView;
@property (nonatomic, strong) UIView            *centerView;
@property (nonatomic, strong) NSMutableArray    *selectButtonArray;
@property (nonatomic, strong) UITextField       *amountInputTextField;
@property (nonatomic, strong) UILabel           *yuanLabel;
//@property (nonatomic, strong) UIButton          *confirmButton;

@property (nonatomic, strong) UILabel           *titleLabel;

- (void)setupSubviews;
- (void)setupConstraints;
- (void)confirmButtonClicked:(id)sender;

@end

@implementation DFDSetPriceViewController

const NSInteger TagBase = 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TODO  navagation上的title究竟是"服务价格设置", 还是根据每个服务的名字来设置待定
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
    
    [self setNavigationBarWithTitle:@"服务价格设置" leftBarButtonItem:[self makeMiniLeftReturnBarButtonItem] rightBarButtonItem:saveBarItem];
    
    
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.centerView];
    for (UIButton *selectButton in self.selectButtonArray) {
        [self.contentView addSubview:selectButton];
    }
    
    UIView *priceView = [[UIView alloc] init];
    priceView.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    priceView.layer.borderWidth = 0.5f;
    priceView.backgroundColor = [UIColor whiteColor];
    priceView.layer.cornerRadius = 6.0f;
    
    [priceView addSubview:self.amountInputTextField];
    [priceView addSubview:self.yuanLabel];
    
    [self.contentView addSubview:priceView];
//    [self.contentView addSubview:self.yuanLabel];
//    [self.view addSubview:self.confirmButton];
    
    // Autolayout
    {
        
        [self.view addConstraint:[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f]];
        [self.view addConstraint:[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
        
        [self.view addConstraint:[self.contentView autoSetDimension:ALDimensionHeight toSize:166.0f]];
        [self.view addConstraint:[self.contentView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
        [self.view addConstraint:[self.contentView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:10.0f]];
        [self.view addConstraint:[self.contentView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
        
        [self.contentView addConstraints:[self.centerView autoSetDimensionsToSize:CGSizeMake(0.0f, 0.0f)]];
        [self.contentView addConstraint:[self.centerView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.centerView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:-30.0f]];
        
        UIButton *selectButton = [self.selectButtonArray objectAtIndex:0];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.centerView withOffset:-5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.centerView withOffset:-5.0f]];
        selectButton = [self.selectButtonArray objectAtIndex:1];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.centerView withOffset:5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.centerView withOffset:-5.0f]];
        selectButton = [self.selectButtonArray objectAtIndex:2];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.centerView withOffset:5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.centerView withOffset:-5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:priceView withOffset:-15.0f]];
        selectButton = [self.selectButtonArray objectAtIndex:3];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.centerView withOffset:5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.centerView withOffset:5.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self.contentView addConstraint:[selectButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:priceView withOffset:-15.0f]];
        
        [self.contentView addConstraint:[priceView autoSetDimension:ALDimensionHeight toSize:42.0f]];
        [self.contentView addConstraint:[priceView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[priceView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:- 10.0f]];
        [self.contentView addConstraint:[priceView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        
        [priceView addConstraint:[self.yuanLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [priceView addConstraint:[self.yuanLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [priceView addConstraint:[self.amountInputTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [priceView addConstraint:[self.amountInputTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.yuanLabel withOffset:10.0f]];
        [priceView addConstraint:[self.amountInputTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
//        
//        self.yuanLabel.backgroundColor = [UIColor greenColor];
//        self.amountInputTextField.backgroundColor = [UIColor yellowColor];
        
//        [self.contentView addConstraints:[self.yuanLabel autoSetDimensionsToSize:CGSizeMake(64.0f, 32.0f)]];
//        [self.contentView addConstraint:[self.yuanLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f]];
//        [self.contentView addConstraint:[self.yuanLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        
//        [self.view addConstraint:[self.confirmButton autoSetDimension:ALDimensionHeight toSize:44.0f]];
//        [self.view addConstraint:[self.confirmButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f]];
//        [self.view addConstraint:[self.confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentView withOffset:10.0f]];
//        [self.view addConstraint:[self.confirmButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0f]];
    }
    
    [self selectButtonClicked:[self.selectButtonArray objectAtIndex:0]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Private Method

- (void)setupSubviews
{
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    
}


#pragma mark - Property

- (UIView *)contentView
{
    if (nil == _contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (NSMutableArray *)selectButtonArray
{
    if (!_selectButtonArray) {
        _selectButtonArray = [[NSMutableArray alloc] init];
        
        UIImage *normalImage = [ImageUtils createImageWithColor:[UIColor whiteColor]];
        UIImage *selectedImage = [UIImage imageNamed:@"img_price_selected"];
        for (NSInteger index = 0; index < 4; index++) {
            UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            selectButton.layer.cornerRadius = 6.0f;
            selectButton.layer.masksToBounds = YES;
            selectButton.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
            selectButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [selectButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [selectButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
            [selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSString *titleString = nil;
            if (index == 0) {
                titleString = @"0元";
                selectButton.tag = TagBase + 0;
            } else if (index == 1) {
                titleString = @"10元";
                selectButton.tag = TagBase + 1000;
            } else if (index == 2) {
                titleString = @"20元";
                selectButton.tag = TagBase + 2000;
            } else if (index == 3) {
                titleString = @"30元";
                selectButton.tag = TagBase + 3000;
            }
            [selectButton setTitle:titleString forState:UIControlStateNormal];
            [selectButton setTitle:titleString forState:UIControlStateSelected];
            [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [_selectButtonArray addObject:selectButton];
        }
    }
    return _selectButtonArray;
}

- (UITextField *)amountInputTextField
{
    if (!_amountInputTextField) {
        _amountInputTextField = [[UITextField alloc] init];
        _amountInputTextField.font = [UIFont systemFontOfSize:17.0f];
//        _amountInputTextField.textAlignment = NSTextAlignmentCenter;
        _amountInputTextField.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        [_amountInputTextField setPlaceholder:@"自定义价格"];
        _amountInputTextField.layer.borderColor = [[SkinManager sharedInstance].defaultLightGrayColor CGColor];
//        _amountInputTextField.layer.borderWidth = 0.5f;
//        _amountInputTextField.layer.cornerRadius = 3.0f;
        _amountInputTextField.layer.masksToBounds = YES;
        _amountInputTextField.delegate = self;
        _amountInputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _amountInputTextField;
}

- (UILabel *)yuanLabel
{
    if (!_yuanLabel) {
        _yuanLabel = [[UILabel alloc] init];
        _yuanLabel.font = [UIFont systemFontOfSize:17.0f];
        [_yuanLabel setTextAlignment:NSTextAlignmentCenter];
        [_yuanLabel setText:@"元"];
    }
    return _yuanLabel;
}

//- (UIButton *)confirmButton
//{
//    if (nil == _confirmButton) {
//        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
//        [_confirmButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
//        _confirmButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
//        _confirmButton.layer.cornerRadius = 3.0f;
//        _confirmButton.layer.masksToBounds = YES;
//        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _confirmButton;
//}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请选择定价:";
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    return _titleLabel;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (UIButton *selectButton in self.selectButtonArray) {
        [selectButton setSelected:NO];
        
        selectButton.layer.borderWidth = 0.5f;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.amountInputTextField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.amountInputTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


#pragma mark - Method

- (void)selectButtonClicked:(id)sender
{
    if ([self.amountInputTextField isFirstResponder]) {
        [self.amountInputTextField resignFirstResponder];
    }
    for (UIButton *selectButton in self.selectButtonArray) {
        [selectButton setSelected:(selectButton == sender)];
        
        if (selectButton.isSelected) {
            
            selectButton.layer.borderWidth = 0.0f;
        }
        else {
            
            selectButton.layer.borderWidth = 0.5f;
        }
    }
    [self.amountInputTextField setText:@""];
}


#pragma mark - Selector

- (void)confirmButtonClicked:(id)sender
{
    NSInteger amount = 0;
    NSString *inputAmount = [self.amountInputTextField text];
    if (inputAmount && [inputAmount length] > 0) {
        amount = [inputAmount integerValue] * 100;    // 转换成分
    } else {
        for (UIButton *selectButton in self.selectButtonArray) {
            if ([selectButton isSelected]) {
                amount =  selectButton.tag - TagBase;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(setPriceViewController:didSelectedPrice:)]) {
        [self.delegate setPriceViewController:self didSelectedPrice:amount];
    }
}

@end
