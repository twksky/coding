//
//  ContactManager.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/9.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IChatManagerDelegate.h>
//通知刷新的
#define kContactChangedNotification             @"0D4FB310-B6A6-4591-B3CB-628AA05D2FFB"
#define kRecentlyContactChangedNotification     @"14C2E8A3-74C2-4480-AB43-B3B5B5416C77"


@interface ContactManager : NSObject <IChatManagerDelegate>

@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) NSArray *iHavePatientArr;

+ (ContactManager *)sharedInstance;

//- (void)initManager;

- (id)getSearchArrWithRealName:(NSString *)realName;//得到搜索的数组
- (NSInteger)getContactCount;//得到联系人数量
- (NSArray *)getIndexKeys;//得到索引的所有值（数组）
- (NSString *)getIndexKeyWithSection:(NSInteger)section;//得到一个组的索引值
- (NSInteger)getContactCountWithIndexKey:(NSString *)indexKey;//通过某个索引值的凉席人数量
- (NSInteger)getContactCountWithSection:(NSInteger)section;//通过某个组得到联系人数量
- (id)getContactWithSection:(NSInteger)section withRow:(NSInteger)row;//通过section和row得到一个model
- (NSArray *)getContactArrayWithSection:(NSInteger)section;// 通过section来获取一个model数组


- (id)getContactWithUserID:(NSString *)userID;//通过用户id得到联系人

- (BOOL)containContactWithUserID:(NSString *)userID;
//- (void)asyncReloadContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// Recently
- (NSInteger)getRecentlyContactCount;
- (NSInteger)getContactIndexWithUserID:(NSString *)userID;
- (id)getRecentlyContactWithIndex:(NSInteger)index;
- (id)getRecentlyContactWithUserID:(NSString *)userID;
- (void)removeRecentlyContactWithIndex:(NSInteger)index;
- (void)removeRecentlyContactWithUserID:(NSString *)userID;
- (BOOL)containRecentlyContactWithUserID:(NSString *)userID;
- (void)asyncReloadRecentlyContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;
// Update
- (void)updateContact:(id)oldContact withNewContact:(id)newContact;
//
// Clear
- (void)clearContacts;

#pragma mark - 网络请求
// 获取我的患者列表
- (void)getPatientsInformationWithDoctorID:(int)doctorID withCompletionHandelr:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// 打电话
- (void)asyncCallPatientWithUserID:(NSInteger)userID withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

@end
