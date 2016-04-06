//
//  QuickDiagnoseManager.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/16.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseManager.h"
#import "QuickDiagnose.h"
#import "AccountManager.h"
#import "Account.h"
#import "QuickDiagnoseComment.h"
#import "MasterDiagnose.h"

@interface QuickDiagnoseManager()

@property (nonatomic, strong) APIManager *apiManager;

@end

@implementation QuickDiagnoseManager

+(instancetype)sharedInstance
{
    static QuickDiagnoseManager *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[self alloc] init];
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

- (void)getQuickDiagnoseListWithDepartment:(NSString *)department withRegion:(NSInteger)regionId withPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *quickDiagnoseList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {

    NSDictionary *params = @{@"region_id": @(regionId) ,@"department": department, @"page": @(page), @"size": @(size)};
    
    [self.apiManager GET:@"/v4/quickly_asks" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseData = responseObject;
        NSArray *quickDiagnoseList = [QuickDiagnose objectArrayWithKeyValuesArray:responseData[@"quickly_asks"]];
        completionHandler(quickDiagnoseList);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}

- (void)getQuickDiagnoseCommentsWithQuickDiagnoseId:(NSInteger)quickDiagnoseId withCompletionHandler:(void (^)(NSArray *comments))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    //TODO
    Account *account = [AccountManager sharedInstance].account;
//    NSString *url = @"/v4/doctors/123722/quickly_asks/562/comments";
    NSString *url = [NSString stringWithFormat:@"/v4/doctors/%ld/quickly_asks/%ld/comments", account.doctor_id, quickDiagnoseId];
    
    [self.apiManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseData = responseObject;
        NSArray *comments = [QuickDiagnoseComment objectArrayWithKeyValuesArray:responseData[@"comments"]];
        completionHandler(comments);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}

- (void)getQuickDiagnoseAllCommentsWithQuickDiagnoseId:(NSInteger)quickDiagnoseId withCompletionHandler:(void (^)(NSArray *comments))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {

    NSString *url = [NSString stringWithFormat:@"/v4/quickly_asks/%ld/comments", quickDiagnoseId];
    
    [self.apiManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseData = responseObject;
        NSArray *comments = [QuickDiagnoseComment objectArrayWithKeyValuesArray:responseData[@"comments"]];
        completionHandler(comments);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}

- (void)replyQuickDiagnoseWithContent:(NSString *)content withQuickDiagnoseId:(NSInteger)quickDiagnoseId withCompletionHandler:(void (^)(QuickDiagnoseComment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {

    Account *account = [AccountManager sharedInstance].account;
//    NSString *url = @"/v4/doctors/123722/quickly_asks/562/comments";
    NSString *url = [NSString stringWithFormat:@"/v4/doctors/%ld/quickly_asks/%ld/comments", account.doctor_id, quickDiagnoseId];
    NSDictionary *params = @{@"description": content};
    
    [self.apiManager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseData = responseObject;
        QuickDiagnoseComment *comment = [QuickDiagnoseComment objectWithKeyValues:responseData];
        completionHandler(comment);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}

- (void)getRepliedQuickDiagnosesWithPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *quickDiagnoseList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    NSDictionary *params = @{@"page": @(page), @"size": @(size)};
    Account *account = [AccountManager sharedInstance].account;
    NSString *url = [NSString stringWithFormat:@"/v4/doctors/%ld/quickly_asks", account.doctor_id];
    [self.apiManager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseData = responseObject;
        NSArray *quickDiagnoseList = [QuickDiagnose objectArrayWithKeyValuesArray:responseData[@"quickly_asks"]];
        completionHandler(quickDiagnoseList);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}

- (void)getMasterDiagnosesWithPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *masterDiagnoseList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler {
    
    NSDictionary *params = @{@"page": @(page), @"size": @(size)};
    Account *account = [AccountManager sharedInstance].account;
    NSString *url = [NSString stringWithFormat:@"/v4/doctors/%ld/quickly_asks/consultation", account.doctor_id];
//    NSString *url = @"v4/doctors/123722/quickly_asks/consultation";
    
    [self.apiManager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseData= responseObject;
        NSArray *masterDiagnoseList = [MasterDiagnose objectArrayWithKeyValuesArray:responseData[@"quickly_asks"]];
        completionHandler(masterDiagnoseList);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        errorHandler(error);
    }];
}


@end








