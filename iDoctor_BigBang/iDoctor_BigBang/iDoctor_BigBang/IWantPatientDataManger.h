//
//  IWantPatientDataManger.h
//  iDoctor_BigBang
//
//  Created by … on 7/6/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientsModel.h"

@class FilterRequest,RecruitRequest,RecruitDetail;
@interface IWantPatientDataManger : NSObject

+ (void)getPatientsIfSuccess:(void(^)(PatientsModel *patients))success
                     failure:(void(^)(NSError *error))failure;

+ (void)getPatientsWithFilterRequest:(FilterRequest *)filterRequest
                             success:(void (^)(NSArray *patientsArray))success
                             failure:(void (^)(NSError *error))failure;

+ (void)addRecruitWithRecruitRequest:(RecruitRequest *)recruitRequest success:(void(^)(NSString *msg))success failure:(void(^)(NSError *error))failure;

+ (void)getRecruitListWithAccountId:(NSInteger)accountId
                            success:(void(^)(NSArray *recruitList))success
                            failure:(void(^)(NSError *error))failure;

+ (void)getRecruitDetailWithRecruitId:(NSInteger)recruitId success:(void(^)(RecruitDetail *recruitDetail))success failure:(void(^)(NSError *error))failure;

+ (void)closeRecruitWithRecruitId:(NSInteger)recruitId success:(void(^)(NSString *msg))success failure:(void(^)(NSError *error))failure;

+ (void)getPatientRecommendWithSuccess:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;


@end

@interface FilterRequest : NSObject

@property (nonatomic, assign) NSNumber *region_id;
@property (nonatomic, assign) NSNumber *rank;
@property (nonatomic, assign) NSNumber *page;
@property (nonatomic, assign) NSNumber *size;

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *category;

@end

@interface RecruitRequest : NSObject


@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, assign) NSNumber *need_people;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@end


@interface RecruitList : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *ctime;

@property (nonatomic, assign) NSInteger need_people;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger patient_count;

@property (nonatomic, assign) BOOL is_closed;

@end

@interface RecruitDetail : NSObject


@property (nonatomic, assign) NSInteger patient_count;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign) NSInteger status_code;

@property (nonatomic, copy) NSString *status_message;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger need_people;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL is_closed;

@end


