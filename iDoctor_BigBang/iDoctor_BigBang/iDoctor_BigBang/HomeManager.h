//
//  HomeManager.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/23.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeInfoRequestModel;
@class HomeInfoModel;
@class Comment;

@interface HomeManager : NSObject

+ (instancetype)sharedInstance;

//咨询
-(void)getHomeInfoWithModel:(HomeInfoRequestModel *)model withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

//地理位置（定位）
-(void)postLocationWithDic:(NSDictionary *)dic withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

//地理位置（定位）
-(void)getRegionWithDic:(NSDictionary *)dic withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

//获得某一条资讯的评论
-(void)getHomeInfoCommentWithModel:(HomeInfoModel *)model withCompletionHandelr:(void (^)(NSArray *arr))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

//发评论
-(void)postCommentWithModel:(HomeInfoModel *)model withDescription:(NSString *)description withCompletionHandelr:(void (^)(Comment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

//检查版本升级
- (void)checkVersionUpdate;
@end
