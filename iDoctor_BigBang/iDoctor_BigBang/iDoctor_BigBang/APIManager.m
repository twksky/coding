//
//  GDHttpTool.m
//  GoodDoctor
//
//  Created by hexy on 15/7/14.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "APIManager.h"
#import "AccountManager.h"
#import "Account.h"
#import "LoginManager.h"
#import <UIAlertView+Blocks.h>

#import <AFNetworkReachabilityManager.h>

@implementation APIManager

+(instancetype)sharedManager
{
    static dispatch_once_t predicate;
    static APIManager *_instance;
    
    dispatch_once(&predicate, ^{
        NSURL *url = [NSURL URLWithString:kHostName];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

        
        [config setHTTPAdditionalHeaders:@{@"APP-VERSION": kAppVerison, @"PLATFORM": kPlatform}];


        _instance = [[APIManager alloc] initWithBaseURL:url sessionConfiguration:config];
        
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/plain", nil];
        _instance.requestSerializer = [AFJSONRequestSerializer serializer];
    });
   
//    Account *account = [AccountManager sharedInstance].account;
//    GDLog(@"%@",account.token);
//    [_instance.requestSerializer setValue:account.token forHTTPHeaderField:@"X-AUTH-TOKEN"];

    return _instance;
}

- (void)setHttpHeaderValue:(NSString *)value forKey:(NSString *)key {
    
    [self.requestSerializer setValue:value forHTTPHeaderField:key];
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *task = [super GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger statusCode = [self parseStatusCode:responseObject];
        
        [self dealWith403WithStatusCode:statusCode];
        
        if (statusCode == 0) {
            
            success(task, responseObject);
            
        } else if (statusCode == 403) {
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
        } else if (statusCode == 428){
            
            NSString *updateURL = [self parseStatusMessage:responseObject];
            
            [self forceUpdateWithURL:updateURL];
        } else {
            
            failure(task, [self localErrorWithMsg:[self parseStatusMessage:responseObject] withCode:-200]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
//        GDLog(@"%@",error);
        NSString *msg = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || !task.response) {
            
            msg = @"网络异常，请稍后重试";
            
        } else {
            
            msg = @"服务器异常，请稍后重试";
            
        }
        
        failure(task,[self localErrorWithMsg:msg withCode:-100]);
    }];
    
    return task;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *task = [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger statusCode = [self parseStatusCode:responseObject];
        
        [self dealWith403WithStatusCode:statusCode];
        if (statusCode == 0) {
            
            success(task, responseObject);
        } else if (statusCode == 403) {
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
            
        } else {
            
            failure(task, [self localErrorWithMsg:[self parseStatusMessage:responseObject] withCode:-200]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        GDLog(@"%@",error);
        
        NSString *msg = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || !task.response) {
            
            msg = @"网络异常，请稍后重试";
        } else {
            
            msg = @"服务器异常，请稍后重试";
        }
        
        failure(task, [self localErrorWithMsg:msg withCode:-100]);
        
    }];
    
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *task = [super PUT:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger statusCode = [self parseStatusCode:responseObject];
        [self dealWith403WithStatusCode:statusCode];
        if (statusCode == 0) {
            
            success(task, responseObject);
        } else if (statusCode == 403) {
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
        } else {
            
            failure(task, [self localErrorWithMsg:[self parseStatusMessage:responseObject] withCode:-200]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSString *msg = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || !task.response) {
            
            msg = @"网络异常，请稍后重试";
        } else {
            
            msg = @"服务器异常，请稍后重试";
        }
        
        failure(task, [self localErrorWithMsg:msg withCode:-100]);
        // failure(task, error);
    }];
    
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *task = [super DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger statusCode = [self parseStatusCode:responseObject];
        
        [self dealWith403WithStatusCode:statusCode];
        if (statusCode == 0) {
            
            success(task, responseObject);
        } else if (statusCode == 403) {
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
      
        } else {
            
            failure(task, [self localErrorWithMsg:[self parseStatusMessage:responseObject] withCode:-200]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSString *msg = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || !task.response) {
            
            msg = @"网络异常，请稍后重试";
        } else {
            
            msg = @"服务器异常，请稍后重试";
        }
        
        failure(task, [self localErrorWithMsg:msg withCode:-100]);
        
         // failure(task, error);
    }];
    
    return task;
}

#pragma mark -
- (NSError *)localErrorWithMsg:(NSString *)msg withCode:(NSInteger)code {
    
    NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
    [errorDetails setValue:msg forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:kUrl code:code userInfo:errorDetails];
}

- (NSInteger)parseStatusCode:(NSDictionary *)jsonData {
    
    NSInteger statusCode = -1;
    
    if ([jsonData objectForKey:@"status_code"] && jsonData[@"status_code"] != [NSNull null]) {
        
        statusCode = [[jsonData objectForKey:@"status_code"] integerValue];
    }
    return statusCode;
}

- (NSString *)parseStatusMessage:(NSDictionary *)jsonData {
    
    NSString *statusMsg = @"未知错误";
    if ([jsonData objectForKey:@"status_message"] && [jsonData objectForKey:@"status_message"] != [NSNull null]) {
        
        statusMsg = [jsonData objectForKey:@"status_message"];
    }
    
    return statusMsg;
}

- (void)forceUpdateWithURL:(NSString *)updateURL {
    
    RIButtonItem *updateBtn = [RIButtonItem itemWithLabel:@"前往升级" action:^{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
        exit(0);
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本提示" message:@"版本过旧, 需要升级" cancelButtonItem:nil otherButtonItems:updateBtn, nil];
    [alertView show];
}


- (void)dealWith403WithStatusCode:(NSInteger)statusCode
{
    if (statusCode == 403) {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账号已在其他地方登陆，请重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
    }

}

@end






