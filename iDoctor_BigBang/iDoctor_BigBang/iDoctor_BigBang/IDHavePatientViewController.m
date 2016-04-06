//
//  IDHavePatientViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDHavePatientViewController.h"
#import "IDSearchViewController.h"
#import "IDOneReginViewController.h"
#import "IDMainViewViewController.h"

#import "IDIHavePatientManager.h"
#import "IDGetPatientInformation.h"
#import "IDGetPatientCaseModel.h"
#import "IDGetPatientMedicalModel.h"
#import "IDGetPatientCaseProcesses.h"
#import "IDPatientMedical.h"
#import "IDMedicaledModel.h"

#import "IDPartView.h"
#import "IDMessageView.h"
#import "IDPatientCaseView.h"
#import "IDPatientCaseTwoView.h"

#import "Account.h"
#import "AccountManager.h"


@interface IDHavePatientViewController()<IDPatientCaseViewDelegate,IDPatientCaseTwoViewDelegate,UITableViewDataSource, UITableViewDelegate>

// 顶部的view
@property (nonatomic, strong) UITableView *topTableView;

// 用一个数来装载相应的
@property (nonatomic, strong) NSString *regin_name;

// 病例
@property (nonatomic, strong) IDPatientCaseView *patientCaseView;

// 病例2
@property (nonatomic, strong) IDPatientCaseTwoView *patientCaseTwoView;

//
@property (nonatomic, strong) IDGetPatientMedicalModel *model;



// 用一个数来装用户的所选地区的id
@property (nonatomic, assign) NSInteger regin_id;


//
@property (nonatomic, assign) BOOL isEnterWeb;

//
@property (nonatomic, strong) NSString *patient_medical_id;

@end

@implementation IDHavePatientViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isEnterWeb == YES) {
        
        [self processWithPatientMedicalID:self.patient_medical_id];
    }
    
    // 注册通知监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegin:) name:@"IDTwoReginViewController" object:nil];
    
}



- (void)changeRegin:(NSNotification *)notification
{
    
    self.regin_id = [notification.userInfo[@"regin_id"] integerValue];
    
    self.regin_name = notification.userInfo[@"regin"];
    
    [self.topTableView reloadData];
}

- (void)viewDidLoad
{
    self.isEnterWeb = NO;
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新建病历";
    
    
    [self setupUI];
    
}


- (void)setupUI
{
    //    // tableView
    //    [self.view addSubview:self.topTableView];
    //    [self.topTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view).with.offset(0);
    //        make.top.equalTo(self.view).with.offset(0);
    //        make.size.equalTo(CGSizeMake(App_Frame_Width, 60));
    //
    //    }];
    //
    //
    // 导入一个新的view
    [self.view addSubview:self.patientCaseView];
    [self.patientCaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(-10);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height));
        
    }];
    
}


#pragma mark - 懒加载

- (UITableView *)topTableView
{
    if (_topTableView == nil) {
        
        _topTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _topTableView;
}

- (IDPatientCaseView *)patientCaseView
{
    if (_patientCaseView == nil) {
        
        _patientCaseView = [[IDPatientCaseView alloc] init];
        _patientCaseView.delegate = self;
    }
    
    return _patientCaseView;
}


// 患者病历的代理
- (void)searchButtonClickedPushSearchViewController:(UIButton *)button
{
    IDSearchViewController *searchView = [[IDSearchViewController alloc] init];
    searchView.patient_id = self.patient_id;
    //  searchView.regin_id = self.regin_id;
    
    // 搜索的回调的bloack
    searchView.block = ^(IDMedicaledModel *model){
        
        // 将旧的界面删除  加上新的view
        [self.patientCaseView removeFromSuperview];
        [self.topTableView removeFromSuperview];
        
        self.patient_medical_id = model.patient_medical_id;
        
        [self processWithPatientMedicalID:model.patient_medical_id];
        
    };
    
    [self.navigationController pushViewController:searchView animated:YES];
    
}


// 网络请求
- (void)processWithPatientMedicalID:(NSString *)patient_medical_id
{
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[IDPatientCaseTwoView class]]) {
            
            [view removeFromSuperview];
            
            break;
        }
        
    }
    
    // 进行网络请求得到相应的数据
    
    IDPatientCaseTwoView *twoView = [[IDPatientCaseTwoView alloc] init];
    twoView.delegate = self;
    
    [MBProgressHUD showMessage:@"正在刷新..." toView:self.view isDimBackground:NO];
    [[IDIHavePatientManager sharedInstance] getPatientCaseProgressWithPatientCaseID:patient_medical_id withCompletionHandelr:^(IDGetPatientMedicalModel *model) {
        
        self.model = model;
        
        [MBProgressHUD hideHUDForView:self.view];
        
        // 导入一个新的view
        
        
        [self.view addSubview:twoView];
        [twoView setupUIWithModel:model];
        [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(0);
            make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 44));
            
        }];
        
        self.isEnterWeb = YES;
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
        [self.view addSubview:twoView];
        [twoView setupUIWithModel:self.model];
        [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(0);
            make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 44));
            
        }];
        
        self.isEnterWeb = NO;
    }];
}


// 第二个病例界面的代理
// 病状主诉按钮被点击
- (void)mainButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model
{
  
    IDMainViewViewController *mainView = [[IDMainViewViewController alloc] init];
    mainView.titles = @"病状主诉";
    mainView.base_url = model.base_url;
    
    [self.navigationController pushViewController:mainView animated:YES];
    
    
}

// 检查报告的按钮被点击
- (void)reportButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model
{
    IDMainViewViewController *mainView = [[IDMainViewViewController alloc] init];
    mainView.titles = @"检查报告";
    mainView.base_url = model.base_url;
    
    [self.navigationController pushViewController:mainView animated:YES];
}

// 其他信息
- (void)relatedButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model
{
    IDMainViewViewController *mainView = [[IDMainViewViewController alloc] init];
    mainView.titles = @"其他信息";
    mainView.base_url = model.base_url;
    
    [self.navigationController pushViewController:mainView animated:YES];
}

// 保存病例按钮被点击
- (void)saveCaseButtonClicked:(UIButton *)button
{
    [MBProgressHUD showSuccess:nil];
    
    if (self.block) {
        
        _block();
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -  表的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = @"请选择患者所在地";
    cell.textLabel.textColor = UIColorFromRGB(0x353d3f);
    
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.detailTextLabel.textColor = UIColorFromRGB(0xa8a8a8);
    cell.detailTextLabel.text = _regin_name;
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// 行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDOneReginViewController *oneRegin = [[IDOneReginViewController alloc] init];
    [self.navigationController pushViewController:oneRegin animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
