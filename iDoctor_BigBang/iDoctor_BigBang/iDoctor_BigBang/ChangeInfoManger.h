//
//  ChangeInfoManger.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/30/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@class InfoChangeRequest,AddrModel,TemplateModel;
@interface ChangeInfoManger : NSObject

+ (void)uploadAvatarWithBase64String:(NSString *)base64String
                           accountId:(NSInteger)accountId
                             success:(void(^)(NSString *avatarURLString))success
                             failure:(void(^)(NSError *error))failure;

+ (void)changeInfoWithInfoChangeRequest:(InfoChangeRequest *)request
                              accountId:(NSInteger)accountId
                                success:(void(^)(Account *account))success
                                failure:(void(^)(NSError *error))failure;

/**
 *  修改地址
 *
 *  @param request
 *  @param success
 *  @param failure
 */
+ (void)changeAddrWithRequest:(AddrModel *)request 
                      success:(void(^)(NSString *success))success
                      failure:(void(^)(NSError *error))failure;
/**
 *  获取地址
 *
 *  @param success
 *  @param failure
 */
+ (void)getAddrIfSuccess:(void(^)(AddrModel *addrModel))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  增加地址
 *
 *  @param request
 *  @param success
 *  @param faiure
 */
+ (void)addAddrWithRequest:(AddrModel *)request
                   success:(void(^)(NSString *success))success
                   failure:(void(^)(NSError *error))faiure;

+ (void)asyncGetMyTemplatesWithCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler;

// 增加模板
+ (void)addTemplatesWithDiction:(NSDictionary *)diction CompletionHandler:(void (^)(TemplateModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler;

// 更新模板
+ (void)putTemplatesWithDiction:(NSDictionary *)diction templateID:(NSInteger)template_id CompletionHandler:(void (^)(TemplateModel * model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;



@end

@interface InfoChangeRequest : NSObject


@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *region_id;

@property (nonatomic, copy) NSString *hospital_id;

@property (nonatomic, strong) NSArray *good_disease_list;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, strong) NSArray *work_time_list;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *department;

@property (nonatomic, copy) NSString *office_phone;

+ (instancetype)request;

@end

