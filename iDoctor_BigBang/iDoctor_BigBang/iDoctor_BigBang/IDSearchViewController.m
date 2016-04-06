//
//  IDSearchViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDSearchViewController.h"

#import "IDIHavePatientManager.h"

#import "IDGetPatientCaseTemplate.h"

#import "IDGetPatientCaseModel.h"
#import "IDMedicaledModel.h"

#import "Account.h"
#import "AccountManager.h"


@interface IDSearchViewController()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

// 顶部的搜索按钮框
@property (nonatomic, strong) UISearchBar *searchBar;

// 显示的tableView
@property (nonatomic, strong) UITableView *caseTableView;

// 装数据
@property (nonatomic, strong) NSMutableArray *datas;

// 模型
@property (nonatomic, strong) IDMedicaledModel *model;

// 字典
@property (nonatomic, strong) NSDictionary *diction;


@end

@implementation IDSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    [self.searchBar becomeFirstResponder];
    
    [self getDatas];
    
    [self.view addSubview:self.caseTableView];
    [self.caseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        
    }];

}


- (void)getDatas
{
    [[IDIHavePatientManager sharedInstance] getPatientCasewithKeyword:@"" withCompletionHandelr:^(NSArray *arr) {
        
        [self.datas addObjectsFromArray:arr];
        
        [self.caseTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    }];
    
}

#pragma mark - 表的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"IDSearchViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = UIColorFromRGB(0x353d3f);
     cell.textLabel.text = [self.datas[indexPath.row] name];
    
    
    
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [cell.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.contentView).with.offset(0);
        make.right.equalTo(cell.contentView).with.offset(0);
        make.bottom.equalTo(cell.contentView).with.offset(-1);
        
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IDGetPatientCaseTemplate *model = self.datas[indexPath.row];

    self.diction = @{@"medical_id":model.template_id, @"creater_id":[NSString stringWithFormat:@"doctor-%d",(int)kAccount.doctor_id], @"medical_name":model.name}; // @"region_id":@(_regin_id)
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要创建%@病吗？选定后不可再进行修改!",model.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = 1110;
    [alert show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {
        
        if (alertView.tag == 1110) {
            
            [MBProgressHUD showMessage:@"正在创建患者病例" toView:self.view isDimBackground:NO];
            
            [[IDIHavePatientManager sharedInstance] creatPatientCaseWithPatientID:(int)_patient_id medicals:self.diction withCompletionHandelr:^(IDMedicaledModel *model) {
                [MBProgressHUD hideHUDForView:self.view];
                
                
                self.model = model;
                
                if (model.first_create == YES) { // 第一次创建
                    
                    // 并将搜索的model 带到下一个界面去
                    _block(self.model);
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else { // 不是第一次创建
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该患者的该病例已经创建过了，是否进行补充或修改？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 1111;
                    [alert show];
                }
                
                
            } withErrorHandler:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                
                
            }];
            
            
        } else if (alertView.tag == 1111) {
        
            _block(self.model);
            [self.navigationController popViewControllerAnimated:YES];
        
            
        }
        
    }
}


#pragma mark - 懒加载
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.showsCancelButton = YES;
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.frame = CGRectMake(10, 0, App_Frame_Width - 30, 44);
        UIImage *image = [UIImage createImageWithColor:UIColorFromRGB(0x2abec0) andSize:CGSizeMake(App_Frame_Width - 10, 30)];
        UIImage *rImg = [UIImage createRoundedRectImage:image size:CGSizeMake(App_Frame_Width - 10, 30) radius:10];
        [_searchBar setSearchFieldBackgroundImage:rImg forState:UIControlStateNormal];
    }
    
    return _searchBar;
}

// 搜索框的代理
// 停止编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}


// 搜索按钮被点击了
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 取消成为第一相应项
    [searchBar resignFirstResponder];
    [self.datas removeAllObjects];
    
    [MBProgressHUD showMessage:@"正在搜索..." toView:self.view isDimBackground:NO];
    // 进行结果的搜索
    [[IDIHavePatientManager sharedInstance] getPatientCasewithKeyword:searchBar.text withCompletionHandelr:^(NSArray *arr) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.datas addObjectsFromArray:arr];
        
        [self.caseTableView reloadData];
    
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    }];


}

// 取消按钮被点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 取消成为第一相应项
    [searchBar resignFirstResponder];

    // 返回上一个界面
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)caseTableView
{
    if (_caseTableView == nil) {
        
        
        _caseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _caseTableView.dataSource = self;
        _caseTableView.delegate = self;
        _caseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _caseTableView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
       
        _datas = [NSMutableArray array];
    }
    
    return _datas;
}


@end





