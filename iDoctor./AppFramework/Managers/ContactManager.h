//
//  ContactManager.h
//  AppFramework
//
//  Created by ABC on 6/27/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChatManagerDelegate.h"

#define kContactChangedNotification             @"0D4FB310-B6A6-4591-B3CB-628AA05D2FFB"
#define kRecentlyContactChangedNotification     @"14C2E8A3-74C2-4480-AB43-B3B5B5416C77"

#define kDoctorAssistantKey @"!"
#define kStarContactKey     @"#"
#define kBlockContactKey    @"~"

@interface ContactManager : NSObject
<
IChatManagerDelegate
>

+ (ContactManager *)sharedInstance;

- (void)initManager;

- (NSInteger)getContactCount;
- (NSArray *)getIndexKeys;
- (NSString *)getIndexKeyWithSection:(NSInteger)section;
- (NSInteger)getContactCountWithIndexKey:(NSString *)indexKey;
- (NSInteger)getContactCountWithSection:(NSInteger)section;
- (id)getContactWithSection:(NSInteger)section withRow:(NSInteger)row;
- (id)getContactWithUserID:(NSInteger)userID;
- (BOOL)containContactWithUserID:(NSInteger)userID;
- (void)asyncReloadContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// Recently
- (NSInteger)getRecentlyContactCount;
- (NSInteger)getContactIndexWithUserID:(NSInteger)userID;
- (id)getRecentlyContactWithIndex:(NSInteger)index;
- (id)getRecentlyContactWithUserID:(NSInteger)userID;
- (void)removeRecentlyContactWithIndex:(NSInteger)index;
- (void)removeRecentlyContactWithUserID:(NSInteger)userID;
- (BOOL)containRecentlyContactWithUserID:(NSInteger)userID;
- (void)asyncReloadRecentlyContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

// Update
- (void)updateContact:(id)oldContact withNewContact:(id)newContact;

// Clear
- (void)clearContacts;

@end
