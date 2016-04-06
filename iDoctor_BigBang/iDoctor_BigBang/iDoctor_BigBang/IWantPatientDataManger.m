//
//  IWantPatientDataManger.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/6/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IWantPatientDataManger.h"
#import "PatientsModel.h"
#import "IDMedicaledModel.h"

@implementation IWantPatientDataManger

// 获取患者推荐列表
+ (void)getPatientRecommendWithSuccess:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure
{
    NSString *string = [NSString stringWithFormat:@"v4/doctors/%ld/patient_medicals/recommend",kAccount.doctor_id];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDMedicaledModel objectArrayWithKeyValuesArray:responseObject[@"patient_medicals"]];
        
        success(array);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        failure(error);
        
    }];
    
}


+ (void)getPatientsIfSuccess:(void (^)(PatientsModel *))success failure:(void (^)(NSError *))failure
{
    [[APIManager sharedManager] GET:@"/v4/patients/no_receive/medicals" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        PatientsModel *model = [PatientsModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getPatientsWithFilterRequest:(FilterRequest *)filterRequest
                             success:(void (^)(NSArray *patientsArray))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM = filterRequest.keyValues;
    
    GDLog(@"%@",filterRequest.keyValues);
    
    [[APIManager sharedManager] GET:@"/v4/patients/no_receive/medicals" parameters:dictM success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSURLRequest *req = task.currentRequest;
        NSURL *url = req.URL;
        GDLog(@"%@",url.absoluteString);
        
        NSArray *model = [IDMedicaledModel objectArrayWithKeyValuesArray:responseObject[@"patient_medicals"]];
        if (success) {
            success(model);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSURLRequest *req = task.currentRequest;
        NSURL *url = req.URL;
        GDLog(@"%@",url.absoluteString);

        if (failure) {
            failure(error);
        }
    }];
}




+ (void)addRecruitWithRecruitRequest:(RecruitRequest *)recruitRequest success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"v4/doctors/%ld/recruits/",kAccount.doctor_id];
    
    [[APIManager sharedManager] POST:urlPath parameters:recruitRequest.keyValues success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(@"发布成功");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }

        
    }];
}

+ (void)getRecruitListWithAccountId:(NSInteger)accountId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"/v4/doctors/%ld/recruits",accountId];

    [[APIManager sharedManager] GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        

        if (success) {
            NSMutableArray *arrM = [RecruitList objectArrayWithKeyValuesArray:responseObject[@"recruits"]];
            success(arrM);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)getRecruitDetailWithRecruitId:(NSInteger)recruitId success:(void (^)(RecruitDetail *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"v4/recruits/%ld",recruitId];
    
    [[APIManager sharedManager] GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            RecruitDetail *rd = [RecruitDetail objectWithKeyValues:responseObject];
            success(rd);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }

    }];
}

+ (void)closeRecruitWithRecruitId:(NSInteger)recruitId success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"v4/recruits/%ld",recruitId];
    
    [[APIManager sharedManager] PUT:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            
            success(@"关闭成功!");
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }

    }];
    
}
@end

@implementation FilterRequest

- (NSNumber *)page
{
    return _page ? _page : @(1);
}
- (NSNumber *)size
{
    return _size ? _size : @(20);
}
@end
@implementation RecruitRequest



@end

@implementation RecruitList

- (NSString *)ctime
{
    return [_ctime substringToIndex:10];
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end

@implementation RecruitDetail


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
