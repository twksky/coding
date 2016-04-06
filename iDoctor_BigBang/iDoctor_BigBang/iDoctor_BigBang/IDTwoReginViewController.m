//
//  IDTwoReginViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/28.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDTwoReginViewController.h"
#import "IDGetSubRegin.h"

#import "IDGetReginModel.h"

#import "IDIHavePatientManager.h"

#import "IDHavePatientViewController.h"

@interface IDTwoReginViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSString *regin;

@end

@implementation IDTwoReginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _model.name;
    
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
    [[IDIHavePatientManager sharedInstance] getProvincialWithRegionID:(int)_model.regin_id deepth:1 withCompletionHandelr:^(IDGetReginModel *model) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.datas addObjectsFromArray:model.sub_regions];
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

#pragma mark - 表的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
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
    
    IDGetSubRegin *model = self.datas[indexPath.row];
    cell.textLabel.text = model.name;
    
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
    IDGetSubRegin *regin = self.datas[indexPath.row];
    
    self.regin = [NSString stringWithFormat:@"%@ %@",_model.name,regin.name];
    
    // 发送通知
    NSNotification *noti = [NSNotification notificationWithName:@"IDTwoReginViewController" object:nil userInfo:@{@"regin":self.regin, @"regin_id":@(regin.regin_id)}];
    
    // 通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    
    // 跳回到新建病例的页面
    for (UIViewController *cntroller in self.navigationController.viewControllers) {
        
        
        if ([cntroller isKindOfClass:[IDHavePatientViewController class]]) {
            
            
            [self.navigationController popToViewController:cntroller animated:YES];
            
            break;
        }
        
    }

    
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
