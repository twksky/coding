//
//  IDPatientCaseDetailViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class IDMedicaledModel,PatientModel;

@interface IDPatientCaseDetailViewController : BaseViewController

@property (nonatomic, strong) IDMedicaledModel *model;

@property (nonatomic, strong) PatientModel *patientModel;


@property (nonatomic, assign) BOOL isChat;

@end
