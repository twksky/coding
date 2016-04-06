//
//  IDPatientCommentDetailViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCommentDetailViewController.h"

@interface IDPatientCommentDetailViewController ()

@property (nonatomic, strong) UITextView *detailView;

@end

@implementation IDPatientCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评论详情";
    
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, App_Frame_Height - 30 - 44));
        
        
    }];
 
}

- (UITextView *)detailView
{
    if (_detailView == nil) {
        
        _detailView = [[UITextView alloc] init];
        _detailView.scrollEnabled = YES;
        _detailView.selectable = NO;
        _detailView.text = _comment_descreption;
        _detailView.textColor = UIColorFromRGB(0x353d3f);
        _detailView.font = [UIFont systemFontOfSize:14.0f];
    
    }
    
    return _detailView;
}

@end
