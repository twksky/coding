//
//  IDMyCardView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/28.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDMyCardView.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "Account.h"
#import "AccountManager.h"

@interface IDMyCardView()

// 顶部的view
@property (nonatomic, strong) UIView *topView;

// 底部的view
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation IDMyCardView

- (instancetype)init
{
    if ([super init]) {
        
        [self setupUI];
    }
    
    return self;
}


// ui布局
- (void)setupUI
{
    // 顶部的View
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height * 0.35));
        
    }];
    
    // 底部的view
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.topView.bottom).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height * 0.65));
        
    }];
}

- (UIView *)topView
{
    Account *model = [AccountManager sharedInstance].account;
    
    if (_topView == nil) {
    
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColorFromRGB(0x36cacc);
        
        // 头像
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.layer.masksToBounds = YES;
        iconImage.layer.cornerRadius = 35.0f;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"wantP_avatar"]];
        [_topView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(_topView);
            make.top.equalTo(_topView).with.offset(15);
            make.size.equalTo(CGSizeMake(70, 70));
    
        }];
        
        // 名字 + 职称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = [NSString stringWithFormat:@"%@ | %@",model.realname, model.title];
        [_topView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_topView).with.offset(0);
            make.top.equalTo(iconImage.bottom).with.offset(15);
            make.width.equalTo(App_Frame_Width);
            
        }];
        
        
        // 医院
        UILabel *hospitalLabel = [[UILabel alloc] init];
        hospitalLabel.font = [UIFont systemFontOfSize:14.0f];
        hospitalLabel.textColor = [UIColor whiteColor];
        hospitalLabel.textAlignment = NSTextAlignmentCenter;
        hospitalLabel.text = model.hospital;
        [_topView addSubview:hospitalLabel];
        [hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_topView).with.offset(0);
            make.top.equalTo(nameLabel.bottom).with.offset(5);
            make.width.equalTo(App_Frame_Width);
            
        }];
        
        // 科室 部分
        UILabel *departmentLabel = [[UILabel alloc] init];
        departmentLabel.font = [UIFont systemFontOfSize:14.0f];
        departmentLabel.textColor = [UIColor whiteColor];
        departmentLabel.textAlignment = NSTextAlignmentCenter;
        departmentLabel.text = model.department;
        [_topView addSubview:departmentLabel];
        [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_topView).with.offset(0);
            make.top.equalTo(hospitalLabel.bottom).with.offset(5);
            make.width.equalTo(App_Frame_Width);
            
        }];
        
    }
    
    return _topView;
}

- (UIView *)bottomView
{
    Account *model = [AccountManager sharedInstance].account;
    
    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        // 二维码
        UIImageView *SQ_imageView = [[UIImageView alloc] init];
        [SQ_imageView sd_setImageWithURL:[NSURL URLWithString:model.qr_code_url]];
        [_bottomView addSubview:SQ_imageView];
        [SQ_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(_bottomView);
            make.top.equalTo(_bottomView).with.offset(30);
            make.size.equalTo(CGSizeMake(App_Frame_Width - 80 * 2, App_Frame_Width - 80 * 2));

        }];
        
        // "扫码"
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = [UIFont systemFontOfSize:14.0f];
        tipLabel.textColor = UIColorFromRGB(0x353d3f);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"让您的患者扫二维码加您";
        [_bottomView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_bottomView).with.offset(0);
            make.top.equalTo(SQ_imageView.bottom).with.offset(15);
            make.width.equalTo(App_Frame_Width);
            
        }];
        
        
        
    }
    
    return _bottomView;
}


@end
