//
//  IDIHavePatientManager.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDGetPatientInformation, IDGetPatientCaseModel,IDpatientCaseTagModel,IDGetPatientMedicalModel,IDGetReginModel,IDMedicaledModel,IDPatientMedicalsModel,IDPatientMedicalsCommentsModel;

@interface IDIHavePatientManager : NSObject

+ (instancetype)sharedInstance;


// 获取我的患者列表
- (void)getPatientsInformationWithDoctorID:(int)doctorID withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 获取患者的基本信息
- (void)getPatientsInformationWithPatientID:(int)patientID withCompletionHandelr:(void (^)(IDGetPatientInformation *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 提交患者的基本信息
- (void)submitPatientInformationWithPatientID:(int)patientID PatientInfo:(NSDictionary *)patientInfo withCompletionHandelr:(void (^)(IDGetPatientInformation *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 查询某个患者被填写过的病例
- (void)getPatientCaseWithPatientID:(int)patientID withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 创建患者病历
- (void)creatPatientCaseWithPatientID:(int)PatientID medicals:(NSDictionary *)medicals withCompletionHandelr:(void (^)(IDMedicaledModel *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 通过病例id查询病例过程
- (void)getPatientCaseProgressWithPatientCaseID:(NSString *)PatientCaseID withCompletionHandelr:(void (^)(IDGetPatientMedicalModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 提交病例标签
- (void)submitPatientCaseTagWithPatientCaseID:(int)patientCaseID withCompletionHandelr:(void (^)(IDpatientCaseTagModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 获取病例模板
- (void)getPatientCasewithKeyword:(NSString *)keyword withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 得到相应的省 市
- (void)getProvincialWithRegionID:(int)regionID deepth:(NSInteger)deepth withCompletionHandelr:(void (^)(IDGetReginModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


#pragma mark ------
- (void)getPatientMedicalCaseWithDoctorID:(int)doctorID withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 得到患者填写病例
- (void)getPatientMedicalCaseWithPatientID:(int)patientID withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 获取患者病例详情
- (void)getPatientMedicalsWithPatientMedicalID:(NSString *)patient_medical_id withCompletionHandelr:(void (^)(IDPatientMedicalsModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 获取医生对患者病例发表的意见
- (void)getAllCommentsWithPatientMedicalID:(NSString *)patient_medical_id withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 接收患者
- (void)receivePatientWithPatientMedicalID:(NSString *)patient_medical_id WithCompletionHandelr:(void (^)(IDMedicaledModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 取消接收患者
- (void)registerPatientWithPatientMedicalID:(NSString *)patient_medical_id WithCompletionHandelr:(void (^)(IDMedicaledModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 医生对患者病例发表意见
- (void)doctorPubilshCommentWithPatientMedicalID:(NSString *)patient_medical_id description:(NSString *)description  WithCompletionHandelr:(void (^)(IDPatientMedicalsCommentsModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;



@end
