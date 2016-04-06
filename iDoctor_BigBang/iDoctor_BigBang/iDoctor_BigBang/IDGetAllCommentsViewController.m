//
//  IDGetAllCommentsViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDGetAllCommentsViewController.h"
#import "IDPatientCaseCommentTableViewCell.h"
#import "IDPatientCommentDetailViewController.h"

#import "IDPatientMedicalsCommentsModel.h"

#import "IDIHavePatientManager.h"

@interface IDGetAllCommentsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation IDGetAllCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部评论";
    

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    
    [self getDatas];
    
    
}

- (void)getDatas
{
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) ||[view isKindOfClass:[IDErrorView class]]) {
        
            [view removeFromSuperview];
            break;
            
        }
        
        
    }
    
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    [[IDIHavePatientManager sharedInstance] getAllCommentsWithPatientMedicalID:_patient_medical_id withCompletionHandelr:^(NSArray *arr) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArray addObjectsFromArray:arr];
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [self errorView];
        
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
    }];
}


- (void)errorView
{
    IDErrorView *errorView = [[IDErrorView alloc] init];
    errorView.block = ^(){
        
        [self getDatas];
    };
    
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height));
        
    }];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"IDPatientCaseCommentTableViewCell";
    
    IDPatientCaseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[IDPatientCaseCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    [cell dataCellCommentWithModel:self.dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 122;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDPatientCommentDetailViewController *detail = [[IDPatientCommentDetailViewController alloc] init];
    NSInteger row = indexPath.row;
    
    IDPatientMedicalsCommentsModel *commentsModel = self.dataArray[row];
    
    detail.comment_descreption = commentsModel.comment_descreption;
    [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
