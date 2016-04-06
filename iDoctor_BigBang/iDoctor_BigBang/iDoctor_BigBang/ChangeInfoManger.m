//
//  ChangeInfoManger.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/30/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ChangeInfoManger.h"
#import "AddrModel.h"
#import "TemplateModel.h"


@implementation ChangeInfoManger

+ (void)uploadAvatarWithBase64String:(NSString *)base64String accountId:(NSInteger)accountId success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *URLString = [NSString stringWithFormat:@"/v4/accounts/%ld/avatar",accountId];
    
    NSDictionary *dict = @{@"image" : base64String};
    
    [[APIManager sharedManager] POST:URLString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        GDLog(@"%@",responseObject);
        if (success) {
            success(responseObject[@"avatar_url"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)changeInfoWithInfoChangeRequest:(InfoChangeRequest *)request accountId:(NSInteger)accountId success:(void (^)(Account *))success failure:(void (^)(NSError *))failure
{
     NSString *URLString = [NSString stringWithFormat:@"v4/doctors/%ld",accountId];
    
    NSLog(@"%@", request.keyValues);
    
    [[APIManager sharedManager] PUT:URLString parameters:request.keyValues success:^(NSURLSessionDataTask *task, id responseObject) {
        
        GDLog(@"%@",responseObject);
        if (success) {
            Account *account = [Account objectWithKeyValues:responseObject];
            
            AccountManager *accountManager = [AccountManager sharedInstance];
            accountManager.account = account;
            [accountManager cacheAccount];
   
            success(account);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getAddrIfSuccess:(void (^)(AddrModel *))success failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [NSString stringWithFormat:@"/v4/doctors/%ld/shipping_address",kAccount.doctor_id];
    [[APIManager sharedManager] GET:URLStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            
            AddrModel *addrModel = [AddrModel objectWithKeyValues:responseObject];
            success(addrModel);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

+ (void)addAddrWithRequest:(AddrModel *)request success:(void (^)(NSString *))success failure:(void (^)(NSError *))faiure
{
    NSMutableDictionary *dict = request.keyValues;
    [dict removeObjectForKey:request.full_path];
    
    NSString *URLStr = [NSString stringWithFormat:@"/v4/doctors/%ld/shipping_address",kAccount.doctor_id];
    [[APIManager sharedManager] POST:URLStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(@"添加地址成功!");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (faiure) {
            
            faiure(error);
        }
    }];
    
}

+ (void)changeAddrWithRequest:(AddrModel *)request success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *dict = request.keyValues;
    [dict removeObjectForKey:request.full_path];
    NSString *URLStr = [NSString stringWithFormat:@"/v4/doctors/%ld/shipping_address",kAccount.doctor_id];
    [[APIManager sharedManager] PUT:URLStr parameters:request.keyValues success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(@"修改成功！");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取我的问诊模板
+ (void)asyncGetMyTemplatesWithCompletionHandler:(void (^)(NSArray *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/doctors/%ld/templates",kAccount.doctor_id];
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [TemplateModel objectArrayWithKeyValuesArray:responseObject[@"templates"]];
        
        completionHandler(array);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];

}

// 增加模板
+ (void)addTemplatesWithDiction:(NSDictionary *)diction CompletionHandler:(void (^)(TemplateModel *))completionHandler withErrorHandler:(void (^)(NSError *))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/doctors/%ld/templates",kAccount.doctor_id];
    
    [[APIManager sharedManager] POST:string parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        
        TemplateModel *model = [TemplateModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
          errorHandler(error);
        
        
    }];
}


// 更新模板
+ (void)putTemplatesWithDiction:(NSDictionary *)diction templateID:(NSInteger)template_id CompletionHandler:(void (^)(TemplateModel * model))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/templates/%ld",(long)template_id];
    
    [[APIManager sharedManager] PUT:string parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        
        TemplateModel *model = [TemplateModel objectWithKeyValues:responseObject];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
         errorHandler(error);
    }];
    
}

@end

@implementation InfoChangeRequest

+ (instancetype)request
{
   static InfoChangeRequest *_request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _request = [[self alloc] init];
    });
    return _request;
}

@end

