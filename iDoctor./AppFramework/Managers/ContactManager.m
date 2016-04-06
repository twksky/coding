//
//  ContactManager.m
//  AppFramework
//
//  Created by ABC on 6/27/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ContactManager.h"
#import "Patient.h"
#import "AccountManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

@interface NSString (ContactCompare)

- (NSComparisonResult)contactCompare:(NSString *)contactNameKey;

@end

@implementation NSString (ContactCompare)

- (NSComparisonResult)contactCompare:(NSString *)contactNameKey
{
    const char *pSelfAsciiCode = self.lowercaseString.UTF8String;
    const char *pContactAsciiCode = contactNameKey.lowercaseString.UTF8String;
    return *pSelfAsciiCode > *pContactAsciiCode;
}

@end

@interface ContactManager ()

@property (strong, nonatomic, readonly) NSMutableArray *applyArray;

@property (nonatomic, strong) NSMutableArray        *recentlyContactArray;
@property (nonatomic, strong) NSMutableDictionary   *contactDic;            // 联系人
@property (nonatomic, strong) NSArray               *sortedContactKeysArray;

- (void)parseContact:(NSArray *)contactArray;
- (void)parseRecentlyContact:(NSArray *)contactArray;

- (void)giftInfoChanged:(NSNotification *)notification;

@end

@implementation ContactManager

+ (ContactManager *)sharedInstance
{
    static ContactManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ContactManager alloc] init];
        //[instance initManager];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _applyArray = [NSMutableArray array];
        
#warning 以下两行代码必须写，注册为SDK的ChatManager的delegate
        [[EaseMob sharedInstance].chatManager removeDelegate:self];
        //注册为SDK的ChatManager的delegate
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftInfoChanged:) name:kGiftInfoChanged object:nil];
    }
    return self;
}

- (void)initManager
{
    [self asyncReloadContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
        [self asyncReloadRecentlyContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
            
        } withErrorHandler:^(NSError *error) {
            
        }];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)dealloc
{
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)clear
{
    [_applyArray removeAllObjects];
}


#pragma mark - EMChatManagerBuddyDelegate

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = @"";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"username":username, @"applyMessage":message, @"acceptState":@NO}];
    [_applyArray addObject:dic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    /*
    for (EMBuddy *tmpBuudy in changedBuddies) {
        for (EMBuddy *buudy in buddyList) {
            if ([tmpBuudy.username isEqualToString:buudy.username]) {
                buudy.isPendingApproval = isAdd;
            }
        }
    }
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
}


#pragma mark - Property

- (NSMutableArray *)recentlyContactArray
{
    if (!_recentlyContactArray) {
        _recentlyContactArray = [[NSMutableArray alloc] init];
    }
    return _recentlyContactArray;
}

- (NSMutableDictionary *)contactDic
{
    if (!_contactDic) {
        _contactDic = [[NSMutableDictionary alloc] init];
    }
    return _contactDic;
}

- (void)parseContact:(NSArray *)contactArray
{
    /*
     NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYinUserName" ascending:YES]];
     [self.contactArray sortUsingDescriptors:sortDescriptors];
     */
    [self.contactDic removeAllObjects];
    for (Patient *thePatient in contactArray) {
        if (thePatient.isStarted) {
            if (![self.contactDic objectForKey:kStarContactKey]) {
                [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:kStarContactKey];
            }
            [[self.contactDic objectForKey:kStarContactKey] addObject:thePatient];
        } else if (thePatient.isBlocked) {
            if (![self.contactDic objectForKey:kBlockContactKey]) {
                [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:kBlockContactKey];
            }
            [[self.contactDic objectForKey:kBlockContactKey] addObject:thePatient];
        } else {
            NSString *patientPinYinName = thePatient.pinYinRealName;
            if (!patientPinYinName || [patientPinYinName length] == 0) {
                patientPinYinName = thePatient.pinYinLoginName;
            }
            NSString *firstChar = [patientPinYinName substringWithRange:NSMakeRange(0, 1)];
            firstChar = [firstChar uppercaseString];
            if (![[self.contactDic allKeys] containsObject:firstChar]) {
                if (![self.contactDic objectForKey:firstChar]) {
                    [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:firstChar];
                }
            }
            [[self.contactDic objectForKey:firstChar] addObject:thePatient];
        }
    }
    // 添加医生助手
    Patient *doctorAssistant = [[Patient alloc] init];
    doctorAssistant.realName = @"医生助手（官方客服）";
    doctorAssistant.pinYinRealName = @"yishengzhushou";
    doctorAssistant.userID = kDoctorAssistantID;
    if (![self.contactDic objectForKey:kDoctorAssistantKey]) {
        [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:kDoctorAssistantKey];
    }
    [[self.contactDic objectForKey:kDoctorAssistantKey] addObject:doctorAssistant];
    
    if ([self.contactDic count] > 0) {
        self.sortedContactKeysArray = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(contactCompare:)];
    }
}

- (void)parseRecentlyContact:(NSArray *)contactArray
{
    
}

// 环信获取最近联系人
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

#pragma mark - Public Method

- (NSInteger)getContactCount
{
    NSInteger contactCount = 0;
    for (NSString *key in self.sortedContactKeysArray) {
        NSArray *contactArray = [self.contactDic objectForKey:key];
        contactCount += [contactArray count];
    }
    return contactCount;
}

- (NSArray *)getIndexKeys
{
    return self.sortedContactKeysArray;
}

- (NSString *)getIndexKeyWithSection:(NSInteger)section
{
    NSString *key = [self.sortedContactKeysArray objectAtIndex:section];
    return key;
}

- (NSInteger)getContactCountWithIndexKey:(NSString *)indexKey
{
    NSInteger contactCount = [[self.contactDic objectForKey:indexKey] count];
    return contactCount;
}

- (NSInteger)getContactCountWithSection:(NSInteger)section
{
    NSString *indexKey = [self getIndexKeyWithSection:section];
    return [self getContactCountWithIndexKey:indexKey];
}

- (id)getContactWithSection:(NSInteger)section withRow:(NSInteger)row
{
    NSString *key = [self.sortedContactKeysArray objectAtIndex:section];
    NSArray *contactArray = [self.contactDic valueForKey:key];
    return [contactArray objectAtIndex:row];
}

- (id)getContactWithUserID:(NSInteger)userID
{
    for (id key in self.sortedContactKeysArray) {
        NSArray *contactArray = [self.contactDic objectForKey:key];
        for (Patient *thePatient in contactArray) {
            if (userID == thePatient.userID) {
                return thePatient;
            }
        }
    }
    return nil;
}

- (BOOL)containContactWithUserID:(NSInteger)userID
{
    return (nil != [self getContactWithUserID:userID]);
}

- (void)asyncReloadContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    [[AccountManager sharedInstance] asyncGetPatientListWithCompletionHandler:^(NSArray *patientList) {
        [self parseContact:patientList];
        NSInteger contactCount = [self getContactCount];
        if (completionHandler) {
            completionHandler(YES, contactCount);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
    } withErrorHandler:errorHandler];
}


#pragma mark - Recently

- (NSInteger)getRecentlyContactCount
{
    NSInteger contactCount = [self.recentlyContactArray count];
    return contactCount;
}

- (NSInteger)getContactIndexWithUserID:(NSInteger)userID
{
    id contact = [self getContactWithUserID:userID];
    return [self.recentlyContactArray indexOfObject:contact];
}

- (id)getRecentlyContactWithIndex:(NSInteger)index
{
    return [self.recentlyContactArray objectAtIndex:index];
}

- (id)getRecentlyContactWithUserID:(NSInteger)userID
{
    for (Patient *thePatient in self.recentlyContactArray) {
        if (userID == thePatient.userID) {
            return thePatient;
        }
    }
    return nil;
}

- (void)removeRecentlyContactWithIndex:(NSInteger)index
{
    Patient *thePatient = [self.recentlyContactArray objectAtIndex:index];
    NSString *chatter = [NSString stringWithFormat:@"%ld", (long)thePatient.userID];
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:NO append2Chat:NO];
    [self.recentlyContactArray removeObjectAtIndex:index];
}

- (void)removeRecentlyContactWithUserID:(NSInteger)userID
{
    for (Patient *thePatient in self.recentlyContactArray) {
        if (userID == thePatient.userID) {
            NSString *chatter = [NSString stringWithFormat:@"%ld", (long)thePatient.userID];
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:NO append2Chat:NO];
            [self.recentlyContactArray removeObject:thePatient];
            break;
        }
    }
}

- (BOOL)containRecentlyContactWithUserID:(NSInteger)userID
{
    return (nil != [self getRecentlyContactWithUserID:userID]);
}

- (void)asyncReloadRecentlyContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSMutableArray *recentlyConversation = [self loadDataSource];
    NSMutableArray *recentlyContactList = [[NSMutableArray alloc] init];
    for (EMConversation *obj in recentlyConversation) {
        id recentlyContact = [self getContactWithUserID:[obj.chatter integerValue]];
        if (recentlyContact) {
            [recentlyContactList addObject:recentlyContact];
        }
    }
    self.recentlyContactArray = recentlyContactList;
    NSInteger recentlyContactCount = [self getRecentlyContactCount];
    if (completionHandler) {
        completionHandler(YES, recentlyContactCount);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRecentlyContactChangedNotification object:nil];
}

- (void)updateContact:(id)oldContact withNewContact:(id)newContact
{
    Patient *oldPatient = oldContact;
    //Patient *newPatient = newPatient;
    
    NSMutableArray *contactMutableArray = [[NSMutableArray alloc] init];
    for (NSArray *contactArray in [self.contactDic allValues]) {
        [contactMutableArray addObjectsFromArray:contactArray];
    }
    if (oldContact) {
        for (NSInteger index = 0; index < contactMutableArray.count; index++) {
            Patient *tmpPatient = [contactMutableArray objectAtIndex:index];
            if (tmpPatient.userID == oldPatient.userID) {
                [contactMutableArray removeObjectAtIndex:index];
                break;
            }
        }
    }
    if (newContact) {
        [contactMutableArray addObject:newContact];
    }
    self.contactDic = nil;
    [self parseContact:contactMutableArray];
    
    // ----------
    
    NSMutableDictionary *contextInfoDic = [[NSMutableDictionary alloc] init];
    if (oldContact) {
        [contextInfoDic setObject:oldContact forKey:@"oldContact"];
    }
    if (newContact) {
        [contextInfoDic setObject:newContact forKey:@"newContact"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:contextInfoDic];
    
    // Recently Contact
    if ([self getRecentlyContactWithUserID:oldPatient.userID]) {
        if (oldContact) {
            for (NSInteger index = 0; index < self.recentlyContactArray.count; index++) {
                Patient *tmpPatient = [self.recentlyContactArray objectAtIndex:index];
                if (tmpPatient.userID == oldPatient.userID) {
                    [self.recentlyContactArray removeObjectAtIndex:index];
                    break;
                }
            }
            
        }
        if (newContact) {
            [self.recentlyContactArray addObject:newContact];
        }
        
        NSMutableDictionary *contextInfoDic = [[NSMutableDictionary alloc] init];
        if (oldContact) {
            [contextInfoDic setObject:oldContact forKey:@"oldContact"];
        }
        if (newContact) {
            [contextInfoDic setObject:newContact forKey:@"newContact"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kRecentlyContactChangedNotification object:contextInfoDic];
    }
}

- (void)giftInfoChanged:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRecentlyContactChangedNotification object:nil];
}


#pragma mark - Clear

- (void)clearContacts
{
    [self.recentlyContactArray removeAllObjects];
    [self.contactDic removeAllObjects];            // 联系人
    self.sortedContactKeysArray = [[NSArray alloc] init];
}

@end
