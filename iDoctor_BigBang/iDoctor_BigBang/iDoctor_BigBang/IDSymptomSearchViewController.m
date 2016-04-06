//
//  IDSymptomSearchViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDSymptomSearchViewController.h"

#import "IDSymptomSearchTableViewCell.h"

#import "IDDoctorIsGoodAtDiseaseModel.h"

#import "AccountManager.h"

@interface IDSymptomSearchViewController ()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,IDSymptomSearchTableViewCellDelegate>

// 顶部的搜索按钮框
@property (nonatomic, strong) UISearchBar *searchBar;

// 显示的tableView
@property (nonatomic, strong) UITableView *caseTableView;

// 装数据
@property (nonatomic, strong) NSMutableArray *datas;

// 疾病数组
@property (nonatomic, strong) NSMutableArray *diseaseArray;

// 症状数组
@property (nonatomic, strong) NSMutableArray *symptomArray;

@end

@implementation IDSymptomSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    [self.searchBar becomeFirstResponder];
    
    // [@"symptom"]:症状  [@"disease"]:疾病
    [self.diseaseArray addObjectsFromArray:_diction[@"disease"]];
    [self.symptomArray addObjectsFromArray:_diction[@"symptom"]];
    
    [self getDatas];
    
    [self.view addSubview:self.caseTableView];
    [self.caseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        
    }];
    
    
}


// 得到数据
- (void)getDatas
{
    
    [[AccountManager sharedInstance] doctorerIsGoodAtDiseasesWithKeyword:@"心" withCompletionHandler:^(NSArray *array) {
        
        [self.datas addObjectsFromArray:array];
        [self.caseTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
    }];
    
}

#pragma mark - 表的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"SymptomSearchTableViewCell";
    
    IDSymptomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[IDSymptomSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    
    [cell createCellWithModel:self.datas[indexPath.row] indexPath:indexPath];
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


// cell的代理
- (void)addButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexPath
{
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1 找出相应的model
    IDDoctorIsGoodAtDiseaseModel *model = self.datas[indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    // 2 根据类型加入相应的数组 type 1: 疾病与疾病组 2：症状与体征
    if (model.type == 1) { // 疾病
        
        if (self.diseaseArray.count == 3) { // 正好有三个  不允许再添加
            
            alert.message = @"疾病最多可添加3个";
            [alert show];
            
        } else {
            
            for (IDDoctorIsGoodAtDiseaseModel *diseaseModel in self.diseaseArray) {
                
                if (diseaseModel.disease_id == model.disease_id) { // 重复添加
                    
                    alert.message = @"不可重复添加";
                    [alert show];
                    
                    return;
                }
            }
            
            UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:nil message:@"+1" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alerts show];
            [alerts dismissWithClickedButtonIndex:0 animated:YES];
            
            [self.diseaseArray addObject:model];
            
        }
        
        
        
        
    } else if (model.type == 2) { // 体征
        
        if (self.symptomArray.count == 3) { // 正好有三个  不允许再添加
            
            alert.message = @"体征最多可添加3个";
            [alert show];
            
        } else {
            
            for (IDDoctorIsGoodAtDiseaseModel *diseaseModel in self.symptomArray) {
                
                if (diseaseModel.disease_id == model.disease_id) { // 重复添加
                    
                    alert.message = @"不可重复添加";
                    [alert show];
                    
                    return;
                }
            }
            
            UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:nil message:@"+1" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alerts show];
            [alerts dismissWithClickedButtonIndex:0 animated:YES];

            [self.symptomArray addObject:model];
            
        }
        
    }
    
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
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
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        
        // Change search bar text color
        searchField.textColor = [UIColor whiteColor];
        
        // Change the search bar placeholder text color
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.frame = CGRectMake(10, 0, App_Frame_Width - 30, 44);
        UIImage *image = [UIImage createImageWithColor:UIColorFromRGB(0x2abec0) andSize:CGSizeMake(App_Frame_Width - 10, 30)];
        UIImage *rImg = [UIImage createRoundedRectImage:image size:CGSizeMake(App_Frame_Width - 10, 30) radius:10];
        [_searchBar setSearchFieldBackgroundImage:rImg forState:UIControlStateNormal];
    }
    
    return _searchBar;
}


// 搜索按钮被点击了
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 取消成为第一相应项
    [searchBar resignFirstResponder];
    [self.datas removeAllObjects];
    
    NSString *keyword = searchBar.text;
    
    [MBProgressHUD showMessage:@"搜索中..." toView:self.view isDimBackground:NO];
    [[AccountManager sharedInstance] doctorerIsGoodAtDiseasesWithKeyword:keyword withCompletionHandler:^(NSArray *array) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.datas addObjectsFromArray:array];
        [self.caseTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

// 取消按钮被点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 取消成为第一相应项
    [searchBar resignFirstResponder];
    
    // 将用户添加的数据 (一个字典  带回上一个页面)  [@"symptom"]:症状  [@"disease"]:疾病
    
    NSDictionary *diction = @{@"symptom":self.symptomArray, @"disease":self.diseaseArray};
    
    if (self.searchBlock) {
        self.searchBlock(diction);
    }
    
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


- (NSMutableArray *)diseaseArray
{
    if (_diseaseArray == nil) {
        
        _diseaseArray = [NSMutableArray array];
        
    }
    
    return _diseaseArray;
}

- (NSMutableArray *)symptomArray
{
    if (_symptomArray == nil) {
        
        _symptomArray = [NSMutableArray array];
    }
    
    return _symptomArray;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
    
}

@end
