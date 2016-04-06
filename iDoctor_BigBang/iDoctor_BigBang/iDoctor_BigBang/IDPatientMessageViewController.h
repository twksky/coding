//
//  IDPatientMessageViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class IDMedicaledModel,PatientModel;

@interface IDPatientMessageViewController : BaseViewController

@property (nonatomic, strong) IDMedicaledModel *medicalModel;

@property (nonatomic, strong) PatientModel *model;

// 患者的id
@property (nonatomic, assign) NSInteger patient_id;

@end
