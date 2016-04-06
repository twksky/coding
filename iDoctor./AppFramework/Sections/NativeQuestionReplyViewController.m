//
//  NativeQuestionReplyViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/7/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionReplyViewController.h"
#import <UITextView+Placeholder.h>
#import <PureLayout.h>

@interface NativeQuestionReplyViewController ()

@property (nonatomic, strong) UITextView *replayTextView;

@end

@implementation NativeQuestionReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *replayBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(addComment)];
    
    [self setNavigationBarWithTitle:@"填写回复" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:replayBarButtonItem];
    
    [self setupViews];
}

#pragma mark - private methods

- (void)setupViews {
    
    [self.view addSubview:self.replayTextView];
    {
        [self.view addConstraints:[self.replayTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    }
}


#pragma mark - selectors

- (void)addComment {
    
    if (!self.replayTextView.text || [self.replayTextView.text length] == 0) {
        
        [self showSimpleAlertWithTitle:@"提示" msg:@"回复不能为空"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyWithText:)]) {
        
        [self.delegate replyWithText:self.replayTextView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - properties

- (UITextView *)replayTextView {
    
    if (!_replayTextView) {
        
        _replayTextView = [[UITextView alloc] init];
        _replayTextView.placeholder = @"填写回复";
        _replayTextView.font = [UIFont systemFontOfSize:19.0f];
    }
    
    return _replayTextView;
}

@end
