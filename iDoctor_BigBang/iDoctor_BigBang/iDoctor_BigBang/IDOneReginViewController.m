//
//  IDOneReginViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/28.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDOneReginViewController.h"
#import "IDTwoReginViewController.h"

#import "IDGetReginModel.h"
#import "IDGetSubRegin.h"
#import "IDIHavePatientManager.h"

@interface IDOneReginViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation IDOneReginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择地区";
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 44));
        
    }];
    
    
    [self getDatas];
    
}

- (void)getDatas
{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    [[IDIHavePatientManager sharedInstance] getProvincialWithRegionID:1 deepth:1 withCompletionHandelr:^(IDGetReginModel *model) {
       
        [MBProgressHUD hideHUDForView:self.view];
        [self.datas addObjectsFromArray:model.sub_regions];
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
    }];
}

#pragma mark - 表的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"IDOneReginViewControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = UIColorFromRGB(0x353d3f);
    
    IDGetSubRegin *model = self.datas[indexPath.row + 1];
    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xeaeaea);
    [cell.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(0);
        make.bottom.equalTo(cell.contentView).with.offset(-1);
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
    IDGetSubRegin *model = self.datas[indexPath.row + 1];
    
    IDTwoReginViewController *twoRegin = [[IDTwoReginViewController alloc] init];
    twoRegin.model = model;
    
    [self.navigationController pushViewController:twoRegin animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _tableView;
}

 -(NSMutableArray *)datas
{
    if (_datas == nil) {
        
        _datas = [NSMutableArray array];
    }
    
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
