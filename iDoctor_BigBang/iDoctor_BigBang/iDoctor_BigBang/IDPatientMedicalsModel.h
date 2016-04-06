//
//  IDPatientMedicalsModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/20.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IDGetPatientInformation,IDMedicaledModel;
@interface IDPatientMedicalsModel : NSObject

// 评论
@property (nonatomic, strong) NSArray *comments;

// 患者信息
@property (nonatomic, strong) IDGetPatientInformation *patient_info;

// 患者病例信息
@property (nonatomic, strong) IDMedicaledModel *patient_medical;

/**
 *  url
 */
@property (nonatomic, strong) NSString *url;

@end
