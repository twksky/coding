//
//  IDPatientCaseView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCaseView.h"
@interface IDPatientCaseView()

// 字体
@property (nonatomic, strong) UILabel *caseLabel;

// 搜索的按钮
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation IDPatientCaseView

- (instancetype)init
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        
    }
    
    return self;
}



- (void)setupUI
{
    // 得到一个灰色的空间
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 10));
        
    }];
    
    
//    // 标签
//    [self addSubview:self.caseLabel];
//    [self.caseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.equalTo(self).with.offset(15);
//        make.top.equalTo(topView.bottom).with.offset(16);
//        make.width.equalTo(App_Frame_Width - 30);
//        
//    }];

    // 搜索的按钮
    [self addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(topView.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 34));
        
    }];

}


#pragma mark - 懒加载
- (UILabel *)caseLabel
{
    if (_caseLabel == nil) {
        
        _caseLabel = [[UILabel alloc] init];
        _caseLabel.font = [UIFont systemFontOfSize:14.0f];
        _caseLabel.textColor = UIColorFromRGB(0x353d3f);
        _caseLabel.text = @"请在疾病库中寻找患者的病例";
        
    }
    
    return _caseLabel;
}


-(UIButton *)searchButton
{
    if (_searchButton == nil) {
        
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"myHavePatient_ellipse"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"请在疾病库中寻找患者的病症" forState:UIControlStateNormal];
        _searchButton.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [_searchButton setTitleColor:UIColorFromRGB(0xc7c7c7) forState:UIControlStateNormal];
        _searchButton.layer.masksToBounds = YES;
        _searchButton.layer.cornerRadius = 15;
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _searchButton.layer.borderWidth = 0.5;
        _searchButton.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        
        [_searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _searchButton;
}

// 按钮的点击事件
- (void)searchButtonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(searchButtonClickedPushSearchViewController:)]) {
        
        [self.delegate searchButtonClickedPushSearchViewController:button];
    }
    
}




@end
