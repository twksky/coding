//
//  DoctorBalanceViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorMoneyViewController.h"
#import "DoctorBalanceViewController.h"
#import "DoctorCreditViewController.h"
#import "UIView+AutoLayout.h"

@interface DoctorMoneyViewController ()

@property (nonatomic, strong) UIView *navigationTitleView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UIViewController *balanceViewController;
@property (nonatomic, strong) UIViewController *creditViewController;

@end

@implementation DoctorMoneyViewController

- (instancetype)initWithSegmentIndex:(NSInteger)segmentIndex {
    
    self = [super init];
    if (self) {
        
        self.navigationItem.titleView = self.navigationTitleView;
        [self setHidesBottomBarWhenPushed:YES];
        
        self.segmentedControl.selectedSegmentIndex = segmentIndex;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self makeLeftReturnBarButtonItem];
    [self.view addSubview:self.balanceViewController.view];
    [self addChildViewController:self.balanceViewController];
    
    [self.view addSubview:self.creditViewController.view];
    [self addChildViewController:self.creditViewController];
    
    [self.view bringSubviewToFront:self.balanceViewController.view];
    
    //AutoLayout
    {
        [self.view addConstraints:[self.balanceViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
        
        [self.view addConstraints:[self.creditViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    }
    
    [self segmentControlValueChanged:self.segmentedControl];
}

#pragma mark - segmentedControl click target

- (void) segmentControlValueChanged:(id)sender {
    
    UISegmentedControl *segmentControl = sender;
    
    if (BALANCE_VIEW_INDEX == segmentControl.selectedSegmentIndex) {
        
        [self.view bringSubviewToFront:self.balanceViewController.view];
    }
    else if (CREDIT_VIEW_INDEX == segmentControl.selectedSegmentIndex) {
        
        [self.view bringSubviewToFront:self.creditViewController.view];
    }
}


#pragma mark - properties

- (UIView *)navigationTitleView {
    
    if (!_navigationTitleView) {
        
        _navigationTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 141.0f, 30.0f)];
        [_navigationTitleView addSubview:self.segmentedControl];
        
    }
    
    return _navigationTitleView;
}

- (UISegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"余额",@"积分",nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        _segmentedControl.frame = CGRectMake(0, 0, 141, 30.0);
        _segmentedControl.tintColor = [UIColor whiteColor];
        
        NSDictionary *selectedTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x40b49c),UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:17.0],UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
        NSDictionary *normalTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:17.0],UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
        
        
        [_segmentedControl setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
        [_segmentedControl setTitleTextAttributes:normalTextAttr forState:UIControlStateNormal];
        [_segmentedControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentedControl;
}

- (UIViewController *)balanceViewController {
    
    if (!_balanceViewController) {
        
        _balanceViewController = [[DoctorBalanceViewController alloc] init];
    }
    
    return _balanceViewController;
}

- (UIViewController *)creditViewController {
    
    if (!_creditViewController) {
        
        _creditViewController = [[DoctorCreditViewController alloc] init];
    }
    
    return _creditViewController;
}

@end
