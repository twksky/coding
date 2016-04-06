//
//  IDExchangeSuccessView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/5.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDExchangeSuccessView.h"

@implementation IDExchangeSuccessView

- (instancetype)initWithImageName:(NSString *)imageName
{
    if ([super init]) {
        
//        self.backgroundColor = [UIColor blackColor];
//        self.alpha = 0.7;
        
        [self setupUIWithImageName:imageName];
        
    }
    
    return self;
}

- (void)setupUIWithImageName:(NSString *)imageName
{
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:imageName];
    [self addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(80);
        make.size.equalTo(CGSizeMake(298, 236));
        
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close_interger"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(45, 45));
        make.top.equalTo(iconImage.bottom).offset(30);
        
    }];
    
    
}

- (void)buttonClicked:(UIButton *)button
{
    [self.delegate dismissAnimated:YES];
    [((UIViewController *)self.delegateVC).navigationController popToRootViewControllerAnimated:YES];
}

@end
