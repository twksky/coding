//
//  IDPatientMedicalsCommentsModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/20.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@interface IDPatientMedicalsCommentsModel : NSObject
/**
 *  创建时间
 */
@property (nonatomic, strong) NSString *created_at;
/**
 *  创建标记
 */
@property (nonatomic, assign) NSInteger created_stamp;
/**
 *  描述
 */
@property (nonatomic, strong) NSString *comment_descreption;
/**
 *  医生信息
 */
@property (nonatomic, strong) Account *doctor;
/**
 *  医生id
 */
@property (nonatomic, assign) NSInteger doctor_id;
/**
 *  患者病例id
 */
@property (nonatomic, strong) NSString *patient_medical_id;

@end
