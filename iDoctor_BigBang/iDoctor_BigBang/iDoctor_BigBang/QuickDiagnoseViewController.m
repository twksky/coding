//
//  QuickDiagnoseViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseViewController.h"
#import "QuickDiagnoseSubViewController.h"
#import "MasterDiagnoseApplySubViewController.h"
#import "DiagnoseReplyRecordSubViewController.h"

#import <Masonry.h>

@interface QuickDiagnoseViewController ()

@property (nonatomic, strong) UISegmentedControl *tyepSegmentControl;
@property (nonatomic, strong) UIViewController *quickDiagnoseSubVC;
@property (nonatomic, strong) UIViewController *masterDiagnoseApplyVC;
@property (nonatomic, strong) UIViewController *diagnoseReplyRecordVC;

@end

@implementation QuickDiagnoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

#pragma mark - 
- (void)setupViews {
    
    self.navigationItem.title = @"快速问诊";
    
    UIView *contentView = self.view;
    
    [contentView addSubview:self.tyepSegmentControl];
    [self.tyepSegmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView).with.offset(10.0f);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
        make.height.equalTo(30.0f);
    }];
    
    //TODO 抛弃addChildViewController方法
    [self addChildViewController:self.quickDiagnoseSubVC];
    [contentView addSubview:self.quickDiagnoseSubVC.view];
    [self.quickDiagnoseSubVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(contentView);
        make.top.equalTo(self.tyepSegmentControl.bottom).offset(10.0f);
    }];
    
    [self addChildViewController:self.masterDiagnoseApplyVC];
    [contentView addSubview:self.masterDiagnoseApplyVC.view];
    [self.masterDiagnoseApplyVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(contentView);
        make.top.equalTo(self.tyepSegmentControl.bottom).offset(10.0f);
    }];
    
    [self addChildViewController:self.diagnoseReplyRecordVC];
    [contentView addSubview:self.diagnoseReplyRecordVC.view];
    [self.diagnoseReplyRecordVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(contentView);
        make.top.equalTo(self.tyepSegmentControl.bottom).offset(10.0f);
    }];
    
    self.tyepSegmentControl.selectedSegmentIndex = 0;
    [self.view bringSubviewToFront:self.quickDiagnoseSubVC.view];
}

#pragma mark - Selectors

- (void)segmentControlValueChanged:(id)sender {
    
    NSInteger index = self.tyepSegmentControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.view bringSubviewToFront:self.quickDiagnoseSubVC.view];
            break;
        case 1:
            [self.view bringSubviewToFront:self.masterDiagnoseApplyVC.view];
            break;
        case 2:
            [self.view bringSubviewToFront:self.diagnoseReplyRecordVC.view];
            break;
        default:
            break;
    }
}

#pragma mark - Properties
- (UISegmentedControl *)tyepSegmentControl {
    
	if(_tyepSegmentControl == nil) {
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"快速问诊", @"会诊申请", @"回复记录",nil];
        _tyepSegmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        _tyepSegmentControl.tintColor = [UIColor whiteColor];
        
        NSDictionary *selectedTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,  [UIFont boldSystemFontOfSize:14.0],NSFontAttributeName ,nil];
        
        NSDictionary *normalTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x36cacc),NSForegroundColorAttributeName,  [UIFont boldSystemFontOfSize:14.0],NSFontAttributeName ,nil];
        
        [_tyepSegmentControl setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
        [_tyepSegmentControl setTitleTextAttributes:normalTextAttr forState:UIControlStateNormal];
        _tyepSegmentControl.tintColor = UIColorFromRGB(0x36cacc);
        [_tyepSegmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	}
    
	return _tyepSegmentControl;
}

- (UIViewController *)quickDiagnoseSubVC {
    
	if(_quickDiagnoseSubVC == nil) {
        
		_quickDiagnoseSubVC = [[QuickDiagnoseSubViewController alloc] init];
	}
    
	return _quickDiagnoseSubVC;
}

- (UIViewController *)masterDiagnoseApplyVC {
    
	if(_masterDiagnoseApplyVC == nil) {
        
		_masterDiagnoseApplyVC = [[MasterDiagnoseApplySubViewController alloc] init];
	}
    
	return _masterDiagnoseApplyVC;
}

- (UIViewController *)diagnoseReplyRecordVC {
    
	if(_diagnoseReplyRecordVC == nil) {
        
		_diagnoseReplyRecordVC = [[DiagnoseReplyRecordSubViewController alloc] init];
	}
    
	return _diagnoseReplyRecordVC;
}

@end
