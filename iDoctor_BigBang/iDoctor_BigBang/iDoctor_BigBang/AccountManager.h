//
//  AccountManager.h
//  iDoctor_Bigbang
//
//  Created by tianxiewuhua on 15/7/27.
//  Copyright (c) 2015年 iDoctor_Bigbang. All rights reserved.
//

#import "Account.h"

@interface AccountManager : NSObject

@property (nonatomic, strong) Account *account;

+ (AccountManager *)sharedInstance;

//+ (Account *)getAccount;

+ (void)saveAccount:(Account *)account;

- (BOOL)isCachedAccount;

- (void)cacheAccount;

- (void)loginWithLoginName:(NSString *)loginName withPassword:(NSString *)password withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 获取注册验证码
- (void)requestChapterWithMobile:(NSString *)mobile withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 获取验证码
- (void)getPasswordChapterWithMobile:(NSString *)mobile withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)resetPasswordWithMobile:(NSString *)mobile withCaptcha:(NSString *)captcha withNewPassword:(NSString *)newPassword withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


- (void)changePasswordWithOldPassword:(NSString *)password newPassword:(NSString *)newPassword withCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


///// 注册第一步 --- 验证手机号 和 验证码
- (void)registOneWithMobile:(NSString *)mobile captcha:(NSString *)captcha withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


////// 注册第二部 --- 完善资料
- (void)registTwoWithDiction:(NSDictionary *)diction withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/**
 *  获取医生擅长疾病列表
 */
- (void)doctorerIsGoodAtDiseasesWithKeyword:(NSString *)keyword withCompletionHandler:(void (^)(NSArray *array))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


// 退出登录
- (void)resignLoginWithCompletionHandler:(void (^)())completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

@end
