//
//  IDGetPatientMedicalModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/28.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDPatientMedical, IDMedicaledModel;
@interface IDGetPatientMedicalModel : NSObject

@property (nonatomic, strong) IDPatientMedical *medical;

@property (nonatomic, strong) NSArray *processes;

@property (nonatomic, strong) IDMedicaledModel *patient_medical;

@end
