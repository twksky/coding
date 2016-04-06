//
//  AccountManager.h
//  AppFramework
//
//  Created by ABC on 7/1/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppNetworkEngine.h"
#import "Account.h"
#import "RegionItem.h"
#import "Bankcard.h"
#import "HospitalItem.h"
#import "ImageHandle.h"
#import "Patient.h"
#import "MedicalRecord.h"
#import "GiftItem.h"
#import "Payments.h"
#import "WithdrawalParam.h"
#import "Comment.h"
#import "QuickQuestion.h"
#import "FamilyMember.h"
#import "UrgentCallInfo.h"
#import "FollowUpItem.h"
#import "FollowUpReport.h"
#import "BlogItem.h"
#import "TemplateModel.h"
#import "ScoreModel.h"
#import "GoodsModel.h"

#define kAccountInfoChanged     @"554FD7BB-C179-4367-A0EC-7909D9A5B351"
#define kGiftInfoChanged        @"ED63F184-8AE6-487C-ADAA-700241F2A588"

@interface AccountManager : NSObject

+ (AccountManager *)sharedInstance;

@property (nonatomic, strong) AppNetworkEngine  *networkEngine;

@property (nonatomic, strong) Account *account;

#pragma mark - Account
/*!x
 @function
 @abstract  获取验证码   OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetCaptchaWithMobile:(NSString *)mobile
            withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取找回密码的验证码  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetCaptchaForRetrievePasswordWithMobile:(NSString *)mobile
                               withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  创建新帐户（注册）   OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncRegisterAccountWithMobile:(NSString *)mobile withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword withRealName:(NSString *)realName withCaptcha:(NSString *)captcha
                 withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  用户登录    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncLoginWithLoginName:(NSString *)loginName withPassword:(NSString *)password
          withCompletionHandler:(void (^)(Account *account, NSInteger statusCode))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  注销登录    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncLogoutWithCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  同步账户信息    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUpdateAccountWithCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


/*!
 @function
 @abstract  找回密码
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncRetrievePassword:(NSString *)password withMobile:(NSString *)mobile withCaptcha:(NSString *)captcha
        withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  修改登录密码
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncChangeLoginPassword:(NSString *)password withOldPassword:(NSString *)oldPassword
           withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  在线状态    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUploadOnlineStatus:(BOOL)isOnline
        withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  申请我的名片  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncApplyNameCardWithReceiver:(NSString *)receiver withPhone:(NSString *)phone withPostcode:(NSString *)postcode withAddress:(NSString *)address
                 withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  修改医生个人资料    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUploadAccount:(Account *)accountParam
     withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  补充好医生账号手机号    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUploadHaoyishengMobile:(NSString *)mobile withCaptcha:(NSString *)captcha
              withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  异步上传头像    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUploadAvatarImage:(UIImage *)image
         withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  上传图片    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUploadImage:(UIImage *)image
   withCompletionHandler:(void (^)(ImageHandle *imageHandle))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  下载图片    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncDownloadImage:(NSString *)imagePath
     withCompletionHandler:(void (^)(UIImage *image))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncDownloadImageWithURLString:(NSString *)imageURLString
                  withCompletionHandler:(void (^)(UIImage *image))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncDownThumbnailImageWithURLString:(NSString *)imageURLString
          withCompletionHandler:(void (^)(UIImage *image))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


#pragma mark - Patient

/*!
 @function
 @abstract  获得我的患者列表    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetPatientListWithCompletionHandler:(void (^)(NSArray *patientList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获得患者病历    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetMedicalRecordWithUserID:(NSInteger)userID
                  withCompletionHandler:(void (^)(NSArray *medicalRecordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获得患者病历    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetMedicalRecordWithID:(NSInteger)medicalRecordID
              withCompletionHandler:(void (^)(MedicalRecord *medicalRecord))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  异步修改患者资料    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncUploadPatient:(Patient *)patient withCompletionHandler:(void (^)(Patient *updatedPatient))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


#pragma mark - Accounting Book

/*!
 @function
 @abstract  充值
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncRecharge:(long)money
    withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  账户余额
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetBalanceWithCompletionHandler:(void (^)(long balance))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  提现参数
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetWithdrawalParamWithCompletionHandler:(void (^)(WithdrawalParam *withdrawalParam))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  提现
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncWithdrawal:(long)money withBankAccount:(NSString *)bankAccount
  withCompletionHandler:(void (^)(long balance))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  添加银行卡
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncAddBankcard:(NSString *)bankcard withCardName:(NSString *)cardName withCardType:(NSString *)cardType withDefaultCard:(BOOL)isDefault
   withCompletionHandler:(void (^)(Bankcard *bankcard))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取银行卡列表
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetBankcardListWithCompletionHandler:(void (^)(NSArray *bankcardArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  接收拒绝花朵    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncAcceptGift:(BOOL)isAccept withDealID:(NSInteger)dealID
  withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  异步获得花朵记录    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetGiftRecordWithCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  异步获得用户花朵记录    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetUserGiftRecordWithUserID:(NSInteger)userID
                   withCompletionHandler:(void (^)(NSArray *recordArray))completionHandler
                        withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  异步获得收支记录    OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetPaymentsRecordWithPageIndex:(NSInteger)pageIndex size:(NSInteger)pageSize CompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncGetPaymentsRecordWithPageIndex:(NSInteger)pageIndex withCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncGetPaymentsRecordWithPageIndex:(NSInteger)pageIndex withSize:(NSInteger)pageSize withCompletionHandler:(void (^)(NSArray *recordArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

#pragma mark - Templates

- (void)asyncGetMyTemplatesWithCompletionHandler:(void (^)(NSArray *templates))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncGetTemplateCategoriesWithCompletionHandler:(void (^)(NSArray *templateCategories))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncSaveTemplateWith:(TemplateModel *)templateModel CompletionHandler:(void (^)(TemplateModel *templateModel))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncGetStandardTemplatesWithTemplateCategoryId:(NSInteger)categoryId CompletionHandler:(void (^)(NSArray *templates))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncUpdateTemplate:(TemplateModel *)templateModel CompletionHandler:(void (^)(TemplateModel *templateModel))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

#pragma mark - Others

/*!
 @function
 @abstract  获得BLOG列表  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetBlogsWithPage:(NSInteger)page withSize:(NSInteger)size  withCompletionHandler:(void (^)(NSArray *blogs))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获得BLOG评论列表  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetBlogCommentsWithBlogId:(NSInteger)blogId withPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *comments))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  发表BLOG评论  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncSaveBlogCommentWithBlogId:(NSInteger)blogId withCommentDesc:(NSString *)commentDesc withCompletionHandler:(void (^)(Comment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


/*!
 @function
 @abstract  获得首页的紧急回呼、患者对话、附近提问等数据  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncDashInfoWithCompletionHandler:(void (^)(NSDictionary *dashInfo))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取地区列表  OK
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetRegionWithRegionCode:(NSInteger)regionCode
               withCompletionHandler:(void (^)(RegionItem *regionItem))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取医院列表
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetHospitalListWithRegionCode:(NSInteger)regionCode
                     withCompletionHandler:(void (^)(NSArray *hospitalListArray))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取医院详情
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetHospitalWithHospitalID:(NSInteger)hospitalID
                 withCompletionHandler:(void (^)(HospitalItem *hospital))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取积分记录
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetScoreListWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize CompletionHandler:(void (^)(NSArray *scoreModels))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取积分对话物品列表
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetGoodsListWithCompletionHandler:(void (^)(NSArray *goodModels))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  积分兑换物品
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncExchangeGoodsWithGoodsId:(NSInteger)goodsId  withCompletionHandler:(void (^)(NSInteger remainScore))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  积分兑换金钱
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncExchangeMoney:(NSInteger)money  withCompletionHandler:(void (^)(Account *account))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


#pragma mark - Quick Question

/*!
 @function
 @abstract  获取医院详情
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncAddComment:(NSString *)commentText withQuestionID:(NSInteger)quectionID
  withCompletionHandler:(void (^)(Comment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取快速提问列表(附近提问)
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetQuickQuestionListWithPage:(NSInteger)page size:(NSInteger)size department:(NSString *)department CompletionHandler:(void (^)(NSArray *quickQuestionList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

/*!
 @function
 @abstract  获取我回复过的快速提问列表(附近提问)
 @discussion
 @param     completionHandler   完成Block
 @param     errorHandler        错误Block
 @result
 */
- (void)asyncGetMyRepliedQuickQuestionListWithPage:(NSInteger)page size:(NSInteger)size department:(NSString *)department CompletionHandler:(void (^)(NSArray *quickQuestionList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


#pragma mark - UrgentCall

- (void)asyncGetUrgentCallListWithCompletionHandler:(void (^)(NSArray *urgentCallList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncAcceptUrgentCall:(NSInteger)callID withCompletionHandler:(void (^)(UrgentCallInfo *urgentCallInfo))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncCallPatientWithUserID:(NSInteger)userID withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


#pragma mark - FollowUp

#define FollowUpType_PostDischarge  @"in_hospital"  // 住院随访
#define FollowUpType_Outpatient     @"outpatient"   // 门诊随访

- (void)asyncGetFollowUpReportListWithType:(NSString *)type
                     withCompletionHandler:(void (^)(NSArray *reportList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)asyncReceiveFollowUpItemWithItemID:(NSInteger)itemID
                           withCompletionHandler:(void (^)(FollowUpItem *followUpItem))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

@end
