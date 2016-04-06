//
//  SNSShare.m
//  AppFramework
//
//  Created by ABC on 8/4/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "SNSShare.h"
#import "WXApi.h"
#import "MBProgressHUD.h"

@interface SNSShare () <WXApiDelegate>

- (BOOL)checkWXInstalled;
- (void)showMBToast:(NSString *)text Type:(int)type;

@end

@implementation SNSShare

#define kWxAppKey       @"wx23d7a8fb01edb378"
#define kWxSecretKey    @"6e61a262d45a1714331b45683fd9ae09"

#define MBTOAST_OK      0
#define MBTOAST_FAILED  1

+ (SNSShare *)sharedInstance
{
    static SNSShare *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SNSShare alloc] init];
    });
    return instance;
}

+ (void)registerSdk
{
    //注册微信
    __unused BOOL isSuccess = [WXApi registerApp:kWxAppKey];
    NSAssert(isSuccess, @"Register Wechat Error!");
}

//分享给微信好友
- (BOOL)shareToWXFriendWithContent:(NSString *)content;
{
    if (![self checkWXInstalled]) {
        return FALSE;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = WXSceneSession;
    
    BOOL isSuccess = [WXApi sendReq:req];
    NSAssert(isSuccess, @"Share Wechat Error!");
    return isSuccess;
}

//分享到微信朋友圈
- (BOOL)shareToWXMomentsWithContent:(NSString *)content
{
    if (![self checkWXInstalled]) {
        return FALSE;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    BOOL isSuccess = [WXApi sendReq:req];
    NSAssert(isSuccess, @"Share Wechat Error!");
    return isSuccess;
}


#pragma mark - Private Method

- (BOOL)checkWXInstalled
{
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
    {
        if(![WXApi isWXAppInstalled])
            [self showMBToast:@"您未安装微信" Type:MBTOAST_FAILED];
        else
            [self showMBToast:@"微信版本太低" Type:MBTOAST_FAILED];
        return NO;
    }
    return YES;
}

- (void)showMBToast:(NSString *)text Type:(int)type
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    CGFloat hidDelay = 1.5f;
    if(type == MBTOAST_OK){
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_hud_checkmark"]];
    }else{
        hidDelay = 2.5f;
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_hud_xmark"]];
    }
    hud.labelText = text;
    
    [hud hide:YES afterDelay:hidDelay];
}


#pragma mark - WXApiDelegate

- (void)onResp:(SendAuthResp *)resp
{
    if (resp.errCode == 0) {
        
    }
}

@end
