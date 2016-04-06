//
//  IDMyCardViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDMyCardViewController.h"
#import "IDMyCardView.h"

@implementation IDMyCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的名片";
    
    IDMyCardView *cardView = [[IDMyCardView alloc] init];
    [self.view addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColorFromRGB(0x36cacc);
    [self hidNavBarBottomLine];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:KaddOrRemoveAPatient object:nil];
}

@end
