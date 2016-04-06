//
//  IDRegistSuccessView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDRegistSuccessView.h"

@interface IDRegistSuccessView()



@end

@implementation IDRegistSuccessView

- (instancetype)init
{
    if ([super init]) {
        
        [self setupUI];
        
    }
    
    return self;
}


- (void)setupUI
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7;
    
    // 背景
    UIView *view = [[UIView alloc] init];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 1;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self);
        make.size.equalTo(CGSizeMake(251, 191));
        
    }];
    
    // 钩
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"regist_success"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(view);
        make.top.equalTo(view).with.offset(30);
        make.size.equalTo(CGSizeMake(60, 60));
        
    }];
    
    // 恭喜您，注册成功
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.font = [UIFont systemFontOfSize:17.0f];
    successLabel.textColor = UIColorFromRGB(0x36cacc);
    successLabel.text = @"恭喜您";
    successLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:successLabel];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(view).offset(0);
        make.width.equalTo(251);
        make.top.equalTo(imageView.bottom).offset(16);
        
    }];
    
    UILabel *Label = [[UILabel alloc] init];
    Label.font = [UIFont systemFontOfSize:17.0f];
    Label.textColor = UIColorFromRGB(0x36cacc);
    Label.text = @"注册成功";
    Label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:Label];
    [Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view).offset(0);
        make.width.equalTo(251);
        make.top.equalTo(successLabel.bottom).offset(7);
        
        
    }];
    
    
}


@end
