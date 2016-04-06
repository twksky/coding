//
//  IDNoFinishController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/27.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDNoFinishController.h"
#import "IDPatientCaseTwoView.h"

#import "IDMainViewViewController.h"
#import "IDGetPatientMedicalModel.h"
#import "IDGetPatientCaseProcesses.h"
#import "IDMedicaledModel.h"
#import "IDIHavePatientManager.h"
#import "IDGetPatientMedicalModel.h"

@interface IDNoFinishController ()<IDPatientCaseTwoViewDelegate>


@property (nonatomic, strong) IDGetPatientMedicalModel *patientMedicalModel;

@end

@implementation IDNoFinishController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _model.medical_name;

}

- (void)getData
{
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[IDPatientCaseTwoView class]]) {
            
            [view removeFromSuperview];
            
            break;
        }
        
    }
    
    
    [MBProgressHUD showMessage:@"加载中" toView:self.view isDimBackground:NO];
    
    // 进行网络请求得到相应的数据
    
    IDPatientCaseTwoView *twoView = [[IDPatientCaseTwoView alloc] init];
    
    twoView.delegate = self;
    
    [[IDIHavePatientManager sharedInstance] getPatientCaseProgressWithPatientCaseID:_model.patient_medical_id withCompletionHandelr:^(IDGetPatientMedicalModel *model) {
        
        self.patientMedicalModel = model;
        
//        IDPatientCaseTwoView *twoView = [[IDPatientCaseTwoView alloc] init];
//        
//        twoView.delegate = self;
        
        [MBProgressHUD hideHUDForView:self.view];
        
        // 导入一个新的view
        [self.view addSubview:twoView];
        [twoView setupUIWithModel:self.patientMedicalModel];
        [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(0);
            make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 44));
            
        }];
        
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
        // 导入一个新的view
        [self.view addSubview:twoView];
        [twoView setupUIWithModel:self.patientMedicalModel];
        [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(0);
            make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 44));
            
        }];
        
    }];
 
}


// 第二个病例界面的代理
// 病状主诉按钮被点击
- (void)mainButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model
{
    
    IDMainViewViewController *mainView = [[IDMainViewViewController alloc] init];
    mainView.base_url = model.base_url;
    mainView.titles = @"病状主诉";
    [self.navigationController pushViewController:mainView animated:YES];
    
    
}

// 检查报告的按钮被点击
- (void)reportButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model
{
    IDMainViewViewController *mainView = [[IDMainViewViewController alloc] init];
    mainView.base_url = model.base_url;
    mainView.titles = @"检查报告";
    [self.navigationController pushViewController:mainView animated:YES];
}

// 其他信息的按钮点击
- (void)relatedButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model
{
    IDMainViewViewController *mainView = [[IDMainViewViewController alloc] init];
    mainView.base_url = model.base_url;
    mainView.titles = @"其他信息";
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



@end
