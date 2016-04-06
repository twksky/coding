//
//  ContactSettingViewController.m
//  AppFramework
//
//  Created by ABC on 8/10/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ContactSettingViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "EXUILabel.h"
#import "Patient.h"

@interface ContactSettingViewController ()

@property (nonatomic, strong) UIScrollView  *contentScrollView;
@property (nonatomic, strong) UIView            *remarkView;
@property (nonatomic, strong) EXUILabel             *remarkTipLabel;
@property (nonatomic, strong) EXUILabel             *remarkNameLabel;
@property (nonatomic, strong) UIImageView           *arrowImageView;
@property (nonatomic, strong) UIView            *starContactView;
@property (nonatomic, strong) EXUILabel             *starContactTipLabel;
@property (nonatomic, strong) UISwitch              *starContactSwitch;
@property (nonatomic, strong) UIView            *blackListView;
@property (nonatomic, strong) EXUILabel             *blackListTipLabel;
@property (nonatomic, strong) UISwitch              *blackListSwitch;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation ContactSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"患者设置";
    }
    return self;
}

- (id)initWithPatient:(Patient *)patient
{
    self = [super init];
    if (self) {
        // Custom initialization
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

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

- (UIView *)remarkView
{
    if (!_remarkView) {
        _remarkView = [[UIView alloc] init];
        _remarkView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _remarkView.layer.cornerRadius = 3.0f;
        _remarkView.layer.borderColor = [[SkinManager sharedInstance].defaultBorderColor CGColor];
        _remarkView.layer.borderWidth = 0.5f;
        
        [_remarkView addSubview:self.remarkTipLabel];
        [_remarkView addSubview:self.remarkNameLabel];
        [_remarkView addSubview:self.arrowImageView];
    }
    return _remarkView;
}

- (EXUILabel *)remarkTipLabel
{
    if (!_remarkTipLabel) {
        _remarkTipLabel = [[EXUILabel alloc] init];
        _remarkNameLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _remarkTipLabel.font = [UIFont systemFontOfSize:16.0f];
        [_remarkTipLabel setText:@"设置备注信息"];
    }
    return _remarkTipLabel;
}

- (EXUILabel *)remarkNameLabel
{
    if (!_remarkNameLabel) {
        _remarkNameLabel = [[EXUILabel alloc] init];
        _remarkNameLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _remarkNameLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _remarkNameLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_arrow"]];
    }
    return _arrowImageView;
}

- (UIView *)starContactView
{
    if (!_starContactView) {
        _starContactView = [[UIView alloc] init];
        _starContactView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _starContactView.layer.cornerRadius = 3.0f;
        _starContactView.layer.borderColor = [[SkinManager sharedInstance].defaultBorderColor CGColor];
        _starContactView.layer.borderWidth = 0.5f;
        
        [_starContactView addSubview:self.starContactTipLabel];
        [_starContactView addSubview:self.starContactSwitch];
    }
    return _starContactView;
}

- (EXUILabel *)starContactTipLabel
{
    if (!_starContactTipLabel) {
        _starContactTipLabel = [[EXUILabel alloc] init];
        _starContactTipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _starContactTipLabel.font = [UIFont systemFontOfSize:16.0f];
        [_starContactTipLabel setText:@"设为标星患者"];
    }
    return _starContactTipLabel;
}

- (UISwitch *)starContactSwitch
{
    if (!_starContactSwitch) {
        _starContactSwitch = [[UISwitch alloc] init];
    }
    return _starContactSwitch;
}

- (UIView *)blackListView
{
    if (!_blackListView) {
        _blackListView = [[UIView alloc] init];
        _blackListView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _blackListView.layer.cornerRadius = 3.0f;
        _blackListView.layer.borderColor = [[SkinManager sharedInstance].defaultBorderColor CGColor];
        _blackListView.layer.borderWidth = 0.5f;
        
        [_blackListView addSubview:self.blackListTipLabel];
        [_blackListView addSubview:self.blackListSwitch];
    }
    return _blackListView;
}

- (EXUILabel *)blackListTipLabel
{
    if (!_blackListTipLabel) {
        _blackListTipLabel = [[EXUILabel alloc] init];
        _blackListTipLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _blackListTipLabel.font = [UIFont systemFontOfSize:16.0f];
        [_blackListTipLabel setText:@"加入黑名单"];
    }
    return _blackListTipLabel;
}

- (UISwitch *)blackListSwitch
{
    if (!_blackListSwitch) {
        _blackListSwitch = [[UISwitch alloc] init];
    }
    return _blackListSwitch;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentScrollView];
    
    [self.contentScrollView addSubview:self.remarkView];
    [self.contentScrollView addSubview:self.starContactView];
    [self.contentScrollView addSubview:self.blackListView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    [self.contentScrollView addConstraints:[self.remarkView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    [self.contentScrollView addConstraints:[self.starContactView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    [self.contentScrollView addConstraints:[self.blackListView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    
    [self.contentScrollView addConstraint:[self.remarkView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.remarkView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.remarkView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.starContactView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.blackListView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.blackListView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.starContactView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.starContactView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.remarkView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.blackListView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.starContactView withOffset:10.0f]];
    {
        [self.remarkView addConstraint:[self.remarkTipLabel autoSetDimension:ALDimensionWidth toSize:120.0f]];
        [self.remarkView addConstraint:[self.remarkTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.remarkView withOffset:0.0f]];
        [self.remarkView addConstraint:[self.remarkTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.remarkView withOffset:14.0f]];
        [self.remarkView addConstraint:[self.remarkTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.remarkView withOffset:0.0f]];
        
        [self.remarkView addConstraint:[self.arrowImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.remarkView withOffset:14.0f]];
        [self.remarkView addConstraint:[self.arrowImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.remarkView withOffset:-14.0f]];
        
        [self.remarkView addConstraint:[self.remarkNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.remarkView withOffset:0.0f]];
        [self.remarkView addConstraint:[self.remarkNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.arrowImageView withOffset:0.0f]];
        [self.remarkView addConstraint:[self.remarkNameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.remarkView withOffset:0.0f]];
    }
    {
        [self.starContactView addConstraint:[self.starContactTipLabel autoSetDimension:ALDimensionWidth toSize:120.0f]];
        [self.starContactView addConstraint:[self.starContactTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.starContactView withOffset:0.0f]];
        [self.starContactView addConstraint:[self.starContactTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.starContactView withOffset:14.0f]];
        [self.starContactView addConstraint:[self.starContactTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.starContactView withOffset:0.0f]];
        
        [self.starContactView addConstraint:[self.starContactSwitch autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.starContactView withOffset:8.0f]];
        [self.starContactView addConstraint:[self.starContactSwitch autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.starContactView withOffset:-14.0f]];
    }
    {
        [self.blackListView addConstraint:[self.blackListTipLabel autoSetDimension:ALDimensionWidth toSize:120.0f]];
        [self.blackListView addConstraint:[self.blackListTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.blackListView withOffset:0.0f]];
        [self.blackListView addConstraint:[self.blackListTipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.blackListView withOffset:14.0f]];
        [self.blackListView addConstraint:[self.blackListTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.blackListView withOffset:0.0f]];
        
        [self.blackListView addConstraint:[self.blackListSwitch autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.blackListView withOffset:8.0f]];
        [self.blackListView addConstraint:[self.blackListSwitch autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.blackListView withOffset:-14.0f]];
    }
}

@end
