//
//  PatientsModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/6/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,IllnessType) {
    
    IllnessTypeLight = 1, // 轻
    IllnessTypeNormal, // 一般
    IllnessTypeHigh    // 危重
};
@class PatientModel,LabelModel;

@interface PatientsModel : NSObject

@property (nonatomic, strong) NSArray *patient_medicals;

@property (nonatomic, assign) NSInteger status_code;

@property (nonatomic, copy) NSString *status_message;

@end


@interface PatientModel : NSObject

@property (nonatomic, copy) NSString *medical_name;

@property (nonatomic, assign) NSInteger patient_id;

@property (nonatomic, copy) NSString *creater_id;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *hospital;

@property (nonatomic, copy) NSString *creater;

@property (nonatomic, strong) LabelModel *medical_label;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, assign) NSInteger receive_doctor_id;

@property (nonatomic, assign) IllnessType medical_rank;

@property (nonatomic, copy) NSString *medical_id;

@property (nonatomic, copy) NSString *patient_requirement;
@property (nonatomic, copy) NSString *patient_sex;
@property (nonatomic, copy) NSString *patient_avatar_url;
@property (nonatomic, assign) NSInteger patient_age;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString *patient_province;
@property (nonatomic, copy) NSString *patient_city;

@property (nonatomic, strong) NSArray *receive_doctor_list;


@end

@interface LabelModel : NSObject

@property (nonatomic, copy) NSString *check_item;

@property (nonatomic, copy) NSString *disease_time;

@property (nonatomic, copy) NSString *operation;

@property (nonatomic, copy) NSString *symptom;

@property (nonatomic, copy) NSString *medical_history;

@property (nonatomic, copy) NSString *follow_symptom;

@property (nonatomic, copy) NSString *treatment;

@property (nonatomic, copy) NSString *pathology;

@property (nonatomic, copy) NSString *complication;

@property (nonatomic, copy) NSString *stage;
@end

