//
//  IDPatientCaseTwoView.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDGetPatientMedicalModel,IDGetPatientCaseProcesses,IDMedicaledModel;
@protocol IDPatientCaseTwoViewDelegate <NSObject>


// 病症主诉按钮被点击了
- (void)mainButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model;


// 检查报告按钮被点击了
- (void)reportButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model;

// 其他信息按钮被点击了
- (void)relatedButtonClicked:(UIButton *)button model:(IDGetPatientCaseProcesses *)model;


// 保存病史的按钮被点击了
- (void)saveCaseButtonClicked:(UIButton *)button;

@end


@interface IDPatientCaseTwoView : UIView

// 根据得到的病种名字  来布局相应的页面
- (void)setupUIWithModel:(IDGetPatientMedicalModel *)model;

@property (nonatomic, assign)id<IDPatientCaseTwoViewDelegate> delegate;


@end

