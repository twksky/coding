//
//  IDMedicaledModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/30.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LabelModel,IDMedicalDoctorModel;
@interface IDMedicaledModel : NSObject

/**
 *  患者病例ID
 */
@property (nonatomic, strong) NSString *patient_medical_id;

/**
 *  创建者的id
 */
@property (nonatomic, strong) NSString *creater_id;

/**
 *  患者id
 */
@property (nonatomic, assign) NSInteger patient_id;

/**
 *  病例模板id
 */
@property (nonatomic, strong) NSString *medical_id;

/**
 *  病例名字
 */
@property (nonatomic, strong) NSString *medical_name;

/**
 *  病例等级
 */
@property (nonatomic, assign) NSInteger medical_rank;

/**
 *  接收医生的ID
 */
@property (nonatomic, assign) NSInteger receive_doctor_id;

/**
 *  病例标签
 */
@property (nonatomic, strong) LabelModel *medical_label;

/**
 *  患者名字
 */
@property (nonatomic, strong) NSString *patient_name;

/**
 *  患者的年龄
 */
@property (nonatomic, assign) NSInteger patient_age;

/**
 *  患者的性别
 */
@property (nonatomic, strong) NSString *patient_sex;

/**
 *  创建时间
 */
@property (nonatomic, strong) NSString *created_at;

/**
 *  更新时间
 */
@property (nonatomic, strong) NSString *updated_at;

/**
 *  地区ID
 */
@property (nonatomic, assign) NSInteger region_id;

/**
 *  创建者
 */
@property (nonatomic, strong) NSString *creater;

/**
 *  医院
 */
@property (nonatomic, strong) NSString *hospital;

/**
 *  患者头像的URL
 */
@property (nonatomic, strong) NSString *patient_avatar_url;

/**
 *  患者的省
 */
@property (nonatomic, strong) NSString *patient_province;

/**
 *  患者的市
 */
@property (nonatomic, strong) NSString *patient_city;

/**
 *  患者的需求
 */
@property (nonatomic, strong) NSString *patient_requirement;

/**
 *  第一次创建
 */
@property (nonatomic, assign) BOOL first_create;

/**
 *  是否换成全部过程
 */
@property (nonatomic, assign) BOOL finish;

/**
 *  医生回复的意见数
 */
@property (nonatomic, assign) NSInteger comment_count;

/**
 *  是否有过补充
 */
@property (nonatomic, assign) BOOL supplement;

/**
 *  患者地区名称
 */
@property (nonatomic, strong) NSString *region;

/**
 *  医生信息
 */
@property (nonatomic, strong) IDMedicalDoctorModel *doctor;


/**
 *  接收医生列表
 */
@property (nonatomic, strong) NSArray *receive_doctor_list;


@end
