//
//  MasterDiagnoseItViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/28.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MasterDiagnoseItViewController.h"
#import <UITextView+Placeholder.h>

@interface MasterDiagnoseItViewController ()

@property (nonatomic, strong) UITextView *diagnoseTextView;

@end

@implementation MasterDiagnoseItViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark -
- (void)setupView {
    
    self.navigationItem.title = @"我来小结";
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelVC)];
    cancelButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *commitButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(commitDiagnose)];
    commitButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.rightBarButtonItem = commitButtonItem;
    
    [self.view addSubview:self.diagnoseTextView];
    [self.diagnoseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Selectors
- (void)cancelVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitDiagnose {
    
    if (self.diagnoseTextView.text.length == 0) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"评论不能为空"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(diagnoseMasterComment:)]) {
        
        [self.delegate diagnoseMasterComment:self.diagnoseTextView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Properties
- (UITextView *)diagnoseTextView {
    
	if(_diagnoseTextView == nil) {
        
		_diagnoseTextView = [[UITextView alloc] init];
        _diagnoseTextView.placeholder = @"填写小结";
	}
	return _diagnoseTextView;
}

@end
