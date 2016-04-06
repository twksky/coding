//
//  ApiManager.m
//  AppFramework
//
//  Created by ABC on 7/15/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ApiManager.h"
#import "AppNetworkEngine.h"
#import <JSONKit-NoWarning/JSONKit.h>
#import "ManagerUtil.h"

@interface ApiManager ()

@property (nonatomic, strong) AppNetworkEngine  *networkEngine;

+ (ImageHandle *)parseImageHandleFromJson:(NSDictionary *)jsonData;

@end

@implementation ApiManager

+ (ApiManager *)sharedInstance
{
    static ApiManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ApiManager alloc] init];
    });
    return instance;
}


#pragma mark - Class Method

+ (ImageHandle *)parseImageHandleFromJson:(NSDictionary *)jsonData
{
    @try {
        if (jsonData == nil || [jsonData count] == 0) {
            return  nil;
        }
        ImageHandle *imageHandle    = [[ImageHandle alloc] init];
        imageHandle.imageID         = [[jsonData objectForKey:@"id"] integerValue];
        imageHandle.imageName       = [jsonData objectForKey:@"name"];
        imageHandle.imageURLString  = [jsonData objectForKey:@"url"];
        return imageHandle;
    } @catch (NSException *exception) {
        return nil;
    }
}


#pragma mark - Property

- (AppNetworkEngine *)networkEngine
{
    if (!_networkEngine) {
        _networkEngine = [[AppNetworkEngine alloc] initWithHostName:kHostName];
        [_networkEngine useCache];
    }
    return _networkEngine;
}

#pragma mark - Method

- (void)asyncUploadImage:(UIImage *)image
   withCompletionHandler:(void (^)(ImageHandle *imageHandle))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSString *urlPath = @"/api/images";
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);
    NSString *mageDataString = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    [paramDic setValue:mageDataString forKey:@"image"];
    [paramDic setValue:@"image/jpeg" forKey:@"mimetype"];
    MKNetworkOperation *op = [self.networkEngine operationWithPath:urlPath params:paramDic httpMethod:@"POST"];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) { return [postDataDict JSONString]; } forType:@"text/json"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSString *jsonResponseString = [operation responseString];
        DLog(@"[operation responseData]-->>%@", jsonResponseString);
        NSDictionary *jsonRespDic = [jsonResponseString objectFromJSONString];
        NSInteger statusCode = [ManagerUtil parseStatusCode:jsonRespDic];
        if (0 == statusCode) {
            ImageHandle *imageHandleResult = [ApiManager parseImageHandleFromJson:jsonRespDic];
            completionHandler(imageHandleResult);
        } else {
            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
            [errorDetails setValue:[ManagerUtil parseStatusMessage:jsonRespDic] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kHostName code:statusCode userInfo:errorDetails];
            errorHandler(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        DLog(@"MKNetwork request error : %@", [err localizedDescription]);
        errorHandler(err);
    }];
    [self.networkEngine enqueueOperation:op];
}

@end
