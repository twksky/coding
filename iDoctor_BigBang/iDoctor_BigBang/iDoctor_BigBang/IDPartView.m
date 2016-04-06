//
//  IDPartView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPartView.h"

@interface IDPartView()

// 底部的线
@property (nonatomic, strong) UIImageView *bgView;

// 中间的圆圈
@property (nonatomic, strong) UIImageView *dotImageView;


@end

@implementation IDPartView


- (instancetype)initWithName:(NSString *)name
{
    if ([super init]) {
        
       self.backgroundColor = [UIColor whiteColor];
        
        [self setUIWithName:name];
    }
    
    return self;
}


- (void)setUIWithName:(NSString *)name
{
    
    CGFloat width = App_Frame_Width/3;
    
    // 背景线
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(19);
        make.size.equalTo(CGSizeMake(width, 2));
        
    }];

    
    // 中间的小圆点
    [self addSubview:self.dotImageView];
    [self.dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(width / 2 - 5);
        make.top.equalTo(self).with.offset(19 - 5);
        make.size.equalTo(CGSizeMake(10, 10));
        
    }];
    
    // 底部的文字
    [self addSubview:self.titleLabel];
    self.titleLabel.text = name;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self.dotImageView.bottom).with.offset(15);
        make.right.equalTo(self).with.offset(0);
        
    }];

}



- (void)changeColorAndTextColor
{
    self.bgView.backgroundColor = UIColorFromRGB(0x36cacc);
    self.dotImageView.image = [UIImage imageNamed:@"myHavePatient_ringBlue"];
    self.titleLabel.textColor = UIColorFromRGB(0x353d3f);
}


#pragma mark - 懒加载
- (UIView *)bgView
{
    if (_bgView == nil) {
        
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bgView;
}


- (UIImageView *)dotImageView
{
    if (_dotImageView == nil) {
        
        _dotImageView = [[UIImageView alloc] init];
        _dotImageView.image = [UIImage imageNamed:@"myHavePatient_ringGray"];
    }
    
    return _dotImageView;
}


- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textColor = UIColorFromRGB(0xc8c8c8);
    }
    
    return _titleLabel;
}


@end
