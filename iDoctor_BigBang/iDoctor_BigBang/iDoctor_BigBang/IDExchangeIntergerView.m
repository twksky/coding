//
//  IDExchangeIntergerView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/5.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDExchangeIntergerView.h"

@interface IDExchangeIntergerView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IDExchangeIntergerView

- (instancetype)init
{
    if ([super init]) {
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
            
        }];
    }
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"IDExchangeIntergerViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.array[indexPath.row];
    label.textColor = UIColorFromRGB(0xcbcbcb);
    label.font = [UIFont systemFontOfSize:15.0f];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(cell.contentView);
        
    }];
    
    
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [cell.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.contentView).offset(0);
        make.bottom.equalTo(cell.contentView).offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
    
    
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_block) {
        
        _block(self.array[indexPath.row]);
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSArray *)array
{
    if (_array == nil) {
        
        _array = @[@"10积分",@"100积分",@"200积分",@"500积分",@"1000积分"];
    }
    
    return _array;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


@end
