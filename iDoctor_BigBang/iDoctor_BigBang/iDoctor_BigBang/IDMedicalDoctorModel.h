//
//  IDMedicalDoctorModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/15.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMedicalDoctorModel : NSObject

/**
 *  医生所属的部门
 */
@property (nonatomic, strong) NSString *department;

/**
 *  医生所属的医院
 */
@property (nonatomic, strong) NSString *hospital;

/**
 *  医生的ID
 */
@property (nonatomic, assign) NSInteger doctor_id;

/**
 *  医生真实姓名
 */
@property (nonatomic, strong) NSString *realname;

/**
 *  医生的性别
 */
@property (nonatomic, strong) NSString *sex;



@end
