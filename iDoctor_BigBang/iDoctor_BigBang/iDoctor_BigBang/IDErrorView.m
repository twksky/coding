//
//  IDErrorView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/2.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDErrorView.h"

@implementation IDErrorView

- (instancetype)init
{
    if ([super init]) {
        
        [self setupUI];
        
        // 给自己加上一个手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClicked)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

// 这个控件被点击了
- (void)selfClicked
{
    if (_block) {
        
        _block();
        
    }
    
}

- (void)setupUI
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"errors"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(170);
        
    }];
    
    UILabel *oneLabel = [[UILabel alloc] init];
    oneLabel.font = [UIFont systemFontOfSize:15.0f];
    oneLabel.textColor = UIColorFromRGB(0x353d3f);
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.text = @"加载失败";
    [self addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(0);
        make.top.equalTo(imageView.bottom).offset(15);
        make.width.equalTo(App_Frame_Width);
    }];
    
    UILabel *twoLabel = [[UILabel alloc] init];
    twoLabel.font = [UIFont systemFontOfSize:15.0f];
    twoLabel.textColor = UIColorFromRGB(0x353d3f);
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.text = @"刷新重试";
    [self addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(0);
        make.top.equalTo(oneLabel.bottom).offset(7);
        make.width.equalTo(App_Frame_Width);
    }];

}




@end
