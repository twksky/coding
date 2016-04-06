//
//  IDIHavePatientManager.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDIHavePatientManager.h"
#import "APIManager.h"
#import "IDGetPatientInformation.h"
#import "IDGetPatientCaseModel.h"
#import "IDGetPatientCaseProcesses.h"
#import "IDpatientCaseTagModel.h"
#import "IDGetDoctorPatient.h"
#import "IDGetPatientCaseTemplate.h"
#import "IDGetPatientMedicalModel.h"
#import "IDGetReginModel.h"
#import "IDPatientMedicalsModel.h"
#import "IDPatientMedicalsCommentsModel.h"

#import "IDMedicaledModel.h"
#import "IDMedicalDoctorModel.h"

#import "Account.h"
#import "AccountManager.h"

#import <MJExtension.h>

@interface IDIHavePatientManager()

@property (nonatomic, strong) APIManager *apiManger;

@end

@implementation IDIHavePatientManager

+(instancetype)sharedInstance
{
    static IDIHavePatientManager *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _apiManger = [APIManager sharedManager];
    }
    
    return self;
}

// 获取我的患者列表
- (void)getPatientsInformationWithDoctorID:(int)doctorID withCompletionHandelr:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
     Account *account = [[AccountManager sharedInstance] account];
    NSString *string = [NSString stringWithFormat:@"v4/doctors/%ld/patients",(long)account.doctor_id];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDGetDoctorPatient objectArrayWithKeyValuesArray:responseObject[@"patients"]];
        
        completionHandler(array);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
    
    
}


// 获取患者的基本信息
- (void)getPatientsInformationWithPatientID:(int)patientID withCompletionHandelr:(void (^)(IDGetPatientInformation *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *strin = [NSString stringWithFormat:@"v4/patients/%d/info",patientID];
    
    
    [[APIManager sharedManager] GET:strin parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        IDGetPatientInformation *model = [IDGetPatientInformation objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);

    }];
    
}


// 提交患者的基本信息
- (void)submitPatientInformationWithPatientID:(int)patientID PatientInfo:(NSDictionary *)patientInfo withCompletionHandelr:(void (^)(IDGetPatientInformation *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/patients/%d/info",patientID];
    
    [[APIManager sharedManager] POST:string parameters:patientInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        IDGetPatientInformation *model = [IDGetPatientInformation objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
         errorHandler(error);
        
    }];
    
    
    
}

// 查询某个患者被填写过的病例
- (void)getPatientCaseWithPatientID:(int)patientID withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/patients/%d/medicals",patientID];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDMedicaledModel objectArrayWithKeyValuesArray:responseObject[@"patient_medicals"]];
        
        completionHandler(array);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
        
    }];
    
    
}

// 创建患者病历
- (void)creatPatientCaseWithPatientID:(int)PatientID medicals:(NSDictionary *)medicals withCompletionHandelr:(void (^)(IDMedicaledModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/patients/%d/medicals",PatientID];
    
    [[APIManager sharedManager] POST:string parameters:medicals success:^(NSURLSessionDataTask *task, id responseObject) {
        
        IDMedicaledModel *model = [IDMedicaledModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
        
    }];

}

// 通过病例id查询病例过程
- (void)getPatientCaseProgressWithPatientCaseID:(NSString *)PatientCaseID withCompletionHandelr:(void (^)(IDGetPatientMedicalModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    
    NSString *string = [NSString stringWithFormat:@"v4/patients/medicals/%@/processes",PatientCaseID];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // IDGetPatientMedicalModel 类中的processes 是 IDGetPatientCaseProcesses类
        [IDGetPatientMedicalModel setupObjectClassInArray:^NSDictionary *{
            
            return @{@"processes":@"IDGetPatientCaseProcesses"};
            
        }];
        
        IDGetPatientMedicalModel *model = [IDGetPatientMedicalModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];

}

// 提交病例标签
- (void)submitPatientCaseTagWithPatientCaseID:(int)patientCaseID withCompletionHandelr:(void (^)(IDpatientCaseTagModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/patients/%d/labels",patientCaseID];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        IDpatientCaseTagModel *model = [IDpatientCaseTagModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];

}


// 获取病例模板
- (void)getPatientCasewithKeyword:(NSString *)keyword withCompletionHandelr:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    
    NSDictionary *diction = @{@"keyword":keyword};
    
    [[APIManager sharedManager] GET:@"v4/medicals" parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *templateArray = [IDGetPatientCaseTemplate objectArrayWithKeyValuesArray:responseObject[@"medicals"]];
        
        completionHandler(templateArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        errorHandler(error);
        
    }];
    
}


// 得到相应的省市
- (void)getProvincialWithRegionID:(int)regionID deepth:(NSInteger)deepth withCompletionHandelr:(void (^)(IDGetReginModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"api/region/%d",regionID];
    NSDictionary *diction = @{@"deepth":@(deepth)};
    
    [[APIManager sharedManager] GET:string parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [IDGetReginModel setupObjectClassInArray:^NSDictionary *{
           
            return @{@"sub_regions":@"IDGetSubRegin"};
            
        }];
        
        
        IDGetReginModel *model = [IDGetReginModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
        
    }];
}


#pragma mark -----
- (void)getPatientMedicalCaseWithDoctorID:(int)doctorID withCompletionHandelr:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    Account *account = [[AccountManager sharedInstance] account];
    
    NSString *string = [NSString stringWithFormat:@"v4/doctors/%ld/patient_medicals",account.doctor_id];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDMedicaledModel objectArrayWithKeyValuesArray:responseObject[@"patient_medicals"]];
        
        completionHandler(array);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];

}


// 得到患者被填的数据
- (void)getPatientMedicalCaseWithPatientID:(int)patientID withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    
    // m.ihaoyisheng.com/v4/patients/<患者id>/medicals
    
    NSString *string = [NSString stringWithFormat:@"v4/patients/%d/medicals",patientID];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
 
}


// 获取患者病例详情
- (void)getPatientMedicalsWithPatientMedicalID:(NSString *)patient_medical_id withCompletionHandelr:(void (^)(IDPatientMedicalsModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{

    NSString *string = [NSString stringWithFormat:@"v4/patients/medicals/%@",patient_medical_id];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        IDPatientMedicalsModel *model = [IDPatientMedicalsModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];

}

// 获取医生对患者病例发表的意见
- (void)getAllCommentsWithPatientMedicalID:(NSString *)patient_medical_id withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"/v4/patients/medicals/%@/comments",patient_medical_id];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDPatientMedicalsCommentsModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        
        completionHandler(array);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
        
    }];

}


// 接收患者
- (void)receivePatientWithPatientMedicalID:(NSString *)patient_medical_id WithCompletionHandelr:(void (^)(IDMedicaledModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    
    NSString *string = [NSString stringWithFormat:@"v4/patients/medicals/%@/receive",patient_medical_id];
    
    NSDictionary *diction = @{@"doctor_id":@(kAccount.doctor_id)};
    
    [[APIManager sharedManager] POST:string parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
       
        IDMedicaledModel *model = [IDMedicaledModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
        errorHandler(error);
    
    }];
 
}

// 取消接收患者
- (void)registerPatientWithPatientMedicalID:(NSString *)patient_medical_id WithCompletionHandelr:(void (^)(IDMedicaledModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/patients/medicals/%ld/%@",kAccount.doctor_id,patient_medical_id];
    
    [[APIManager sharedManager] DELETE:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        IDMedicaledModel *model = [IDMedicaledModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];
    
}


// 医生对患者病例发表意见
- (void)doctorPubilshCommentWithPatientMedicalID:(NSString *)patient_medical_id description:(NSString *)description  WithCompletionHandelr:(void (^)(IDPatientMedicalsCommentsModel *model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/patients/medicals/%@/comments",patient_medical_id];
    NSDictionary *dic = @{@"doctor_id":@(kAccount.doctor_id), @"description":description};
    
    
    [[APIManager sharedManager] POST:string parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        IDPatientMedicalsCommentsModel *model = [IDPatientMedicalsCommentsModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];
    
    
    
}


@end
