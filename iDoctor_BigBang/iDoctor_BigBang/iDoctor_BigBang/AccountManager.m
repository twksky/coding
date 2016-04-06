//
//  AccountManager.m
//  iDoctor_Bigbang
//
//  Created by tianxiewuhua on 15/7/27.
//  Copyright (c) 2015年 iDoctor_Bigbang. All rights reserved.
//

#import "AccountManager.h"
#import "APIManager.h"
#import "NSString+Extension.h"
#import <MJExtension.h>

#import "IDDoctorIsGoodAtDiseaseModel.h"

#import "Account.h"

@interface AccountManager ()

@property (nonatomic, strong) APIManager *apiManager;

@end

@implementation AccountManager

+ (AccountManager *)sharedInstance
{
    static AccountManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AccountManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _apiManager = [APIManager sharedManager];
    }
    
    return self;
}

- (void)loginWithLoginName:(NSString *)loginName withPassword:(NSString *)password withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    NSString *urlPath = @"v4/doctors/login";

    NSDictionary *params = @{@"loginname": loginName, @"password": [password md5String]};
    
    [self.apiManager POST:urlPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        Account *model = [Account objectWithKeyValues:responseObject];
        self.account = model;
        [self.apiManager.requestSerializer setValue:model.token forHTTPHeaderField:@"X-AUTH-TOKEN"];
        
        [self cacheAccount];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}

// 获取注册验证码
- (void)requestChapterWithMobile:(NSString *)mobile withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    NSString *urlPath = @"api/doctor/captcha";
    NSDictionary *params = @{@"mobile": mobile};
    
    [self.apiManager POST:urlPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}


// 获取验证码
- (void)getPasswordChapterWithMobile:(NSString *)mobile withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *urlPath = @"api/doctor/retrieve_password";
    NSDictionary *params = @{@"mobile": mobile};
    
    [self.apiManager POST:urlPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
    
}

- (void)resetPasswordWithMobile:(NSString *)mobile withCaptcha:(NSString *)captcha withNewPassword:(NSString *)newPassword withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    NSString *urlPath = @"api/doctor/retrieve_password";
    NSDictionary *params = @{@"mobile": mobile, @"captcha": captcha, @"password": [newPassword md5String].uppercaseString};
    
   [self.apiManager PUT:urlPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
       
       Account *model = [Account objectWithKeyValues:responseObject];
       self.account = model;
       // [self.apiManager.requestSerializer setValue:model.token forHTTPHeaderField:@"X-AUTH-TOKEN"];
       
       [self cacheAccount];
       
       completionHandler();
       
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
       errorHandler(error);
   }];
}


- (void)changePasswordWithOldPassword:(NSString *)password newPassword:(NSString *)newPassword withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSDictionary *dic = @{@"old_password":[password md5String], @"new_password":[newPassword md5String]};
    
    [[APIManager sharedManager] PUT:@"api/doctor/change_password" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
 
        completionHandler();
   
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];
    
    
}

///// 注册第一步 --- 验证手机号 和 验证码
- (void)registOneWithMobile:(NSString *)mobile captcha:(NSString *)captcha withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSDictionary *diction = @{@"mobile":mobile, @"captcha":captcha};

    [[APIManager sharedManager] POST:@"v4/doctors/register_1" parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {

            completionHandler(YES);
  
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];

}



////// 注册第二部 --- 完善资料
- (void)registTwoWithDiction:(NSDictionary *)diction withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    [[APIManager sharedManager] POST:@"v4/doctors/register_2" parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        Account *model = [Account objectWithKeyValues:responseObject];
        self.account = model;
        [self cacheAccount];
        
        completionHandler(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}


/**
 *  获取医生擅长疾病列表
 */
- (void)doctorerIsGoodAtDiseasesWithKeyword:(NSString *)keyword withCompletionHandler:(void (^)(NSArray *array))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSDictionary *diction = @{@"keyword":keyword};
    
    [[APIManager sharedManager] GET:@"v4/diseases" parameters:diction success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDDoctorIsGoodAtDiseaseModel objectArrayWithKeyValuesArray:responseObject[@"diseases"]];
        
        completionHandler(array);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}


// 退出登录
- (void)resignLoginWithCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *string = [NSString stringWithFormat:@"v4/doctors/login"];
    
    [[APIManager sharedManager] DELETE:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
       
        completionHandler();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
        
    }];
    
}


#pragma mark -
- (BOOL)isCachedAccount {
    
    return self.account != nil;
}

- (void)cacheAccount {
    
    if (self.account) {
    
       [NSKeyedArchiver archiveRootObject:self.account toFile:GDDocumentsDir(@"account.data")];
    }
}

#pragma mark -
- (Account *)account {
    
    if (!_account) {
        
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:GDDocumentsDir(@"account.data")];
    }
    
    return _account;
}

//+ (Account *)getAccount
//{
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:GDDocumentsDir(@"account.data")];
//}

+ (void)saveAccount:(Account *)account
{
    [AccountManager sharedInstance].account = account;
}
@end


















