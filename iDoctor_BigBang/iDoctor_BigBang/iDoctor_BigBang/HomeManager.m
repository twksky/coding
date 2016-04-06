//
//  HomeManager.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/23.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "HomeManager.h"
#import "APIManager.h"
#import "HomeInfoRequestModel.h"
#import "DataBaseManger.h"
#import "HomeInfoModel.h"
#import "Comment.h"

@interface HomeManager ()

@property (nonatomic, strong) APIManager *apiManger;

@end

@implementation HomeManager

+(instancetype)sharedInstance
{
    static HomeManager *instance;
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

//首页咨询
-(void)getHomeInfoWithModel:(HomeInfoRequestModel *)model withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler{
//    if ([model.page intValue] == 1){
//        
//    }
   
    [self.apiManger GET:@"v4/info_blogs" parameters:[model keyValues] success:^(NSURLSessionDataTask *task, id responseObject) {

        NSDictionary *dataDic = responseObject;
        NSMutableArray *infoArr = [dataDic objectForKey:@"info_blogs"];
        completionHandler(infoArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}

//地理位置（定位）
-(void)postLocationWithDic:(NSDictionary *)dic withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler{
    [self.apiManger POST:@"v4/doctors/100000/now_position_region" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        /*
         {
         "region_id": 2116,
         "region_name": "黄山市",
         "status_code": 0,
         "status_message": "OK"
         }
         */
        completionHandler(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}


-(void)getRegionWithDic:(NSDictionary *)dic withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler{
    [self.apiManger GET:[NSString stringWithFormat:@"api/region/%@",[dic objectForKey:@"deepth"]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDic = responseObject;
        NSMutableArray *regionsArr = [dataDic objectForKey:@"sub_regions"];
        completionHandler(regionsArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}

//获得某一条资讯的评论
-(void)getHomeInfoCommentWithModel:(HomeInfoModel *)model withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler{
    [self.apiManger GET:[NSString stringWithFormat:@"v4/info_blogs/%ld/comments/",(long)model.h_id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = [responseObject objectForKey:@"comments"];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            Comment *model = [Comment objectWithKeyValues:dic];
            [dataArr addObject:model];
        }
        completionHandler(dataArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}

//发评论
-(void)postCommentWithModel:(HomeInfoModel *)model withDescription:(NSString *)description withCompletionHandelr:(void (^)(Comment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler{
    [self.apiManger POST:[NSString stringWithFormat:@"v4/info_blogs/%ld/comments/",(long)model.h_id] parameters:@{@"description" : description } success:^(NSURLSessionDataTask *task, id responseObject) {
        Comment *comment = [Comment objectWithKeyValues:responseObject];
        completionHandler(comment);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}

- (void)checkVersionUpdate {
    
    [self.apiManger GET:@"/v4/check-version" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        //nil;
    }];
}

@end
