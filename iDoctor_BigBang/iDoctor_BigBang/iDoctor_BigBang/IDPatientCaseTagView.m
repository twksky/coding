//
//  IDPatientCaseTagView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCaseTagView.h"


@interface IDPatientCaseTagView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tagTableView;

// 装数据的一个array
@property (nonatomic, strong) NSArray *datas;

@end

@implementation IDPatientCaseTagView


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
    
    [self addSubview:self.tagTableView];
    [self.tagTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        
    }];
    
}


#pragma  mark - 表的代理和数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, App_Frame_Width, 125);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = UIColorFromRGB(0x36cacc);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ensureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(view).with.offset(15);
        make.right.equalTo(view).with.offset(-15);
        make.bottom.equalTo(view).with.offset(-15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
    }];
    
    return view;
}


// 确定按钮被点击了
- (void)ensureButtonClicked:(UIButton *)button
{
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"最多填写6项，不能为空";
    label.textColor = UIColorFromRGB(0xb7b7b7);
    label.backgroundColor = UIColorFromRGB(0xf8f8f8);
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(0, 0, App_Frame_Width, 25);
    
    return label;
}










#pragma mark - 懒加载
- (NSArray *)datas
{
    if (_datas == nil) {
        
        _datas = @[@"症    状",@"伴随症状",@"发病时间",@"分    期",@"病理分析",@"检查项目",@"相关病史",@"手    术",@"治    疗",@"合 并 症"];
    }
    
    return _datas;
}

- (UITableView *)tagTableView
{
    if (_tagTableView == nil) {
        
        _tagTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tagTableView.dataSource = self;
        _tagTableView.delegate = self;
        
    }
    
    return _tagTableView;
}

@end
