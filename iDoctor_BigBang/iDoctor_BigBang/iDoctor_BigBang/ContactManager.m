//
//  ContactManager.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/9.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "ContactManager.h"
#import "IDGetDoctorPatient.h"
#import "IDIHavePatientManager.h"

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

@property (strong, nonatomic, readonly) NSMutableArray *applyArray;//申请的消息

@property (nonatomic, strong) NSMutableArray        *recentlyContactArray;//消息列表需要的一个数组
@property (nonatomic, strong) NSMutableDictionary   *contactDic;            // 联系人
@property (nonatomic, strong) NSArray               *sortedContactKeysArray;//排列好的数组
@property (nonatomic, strong) NSArray               *contactArrC; //服务器的返回的数组，需要监听
@property (nonatomic, assign) BOOL                  isAppear;//显示提示框

- (void)parseContact:(NSMutableArray *)contactArray;
- (void)parseRecentlyContact:(NSArray *)contactArray;

//- (void)giftInfoChanged:(NSNotification *)notification;

@end

@implementation ContactManager

+ (ContactManager *)sharedInstance
{
    static ContactManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ContactManager alloc] init];
        //[instance initManager];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(refreshContact) name:KaddOrRemoveAPatient object:nil];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.contactArrC = [NSArray array];
        self.isAppear = NO;
        //准备监听联系人发生变化
        [self addObserver:self forKeyPath:@"contactArrC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        
        _applyArray = [NSMutableArray array];
        
#warning 以下两行代码必须写，注册为SDK的ChatManager的delegate
        [[EaseMob sharedInstance].chatManager removeDelegate:self];
        //注册为SDK的ChatManager的delegate
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftInfoChanged:) name:kGiftInfoChanged object:nil];
    }
    return self;
}

//- (void)initManager
//{
//    [self asyncReloadContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
//        [self asyncReloadRecentlyContactsWithCompletionHandler:^(BOOL bSuccess, NSInteger contactCount) {
//
//        } withErrorHandler:^(NSError *error) {
//
//        }];
//    } withErrorHandler:^(NSError *error) {
//
//    }];
//}

- (void)dealloc
{
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KaddOrRemoveAPatient object:nil];
}

- (void)clear
{
    [_applyArray removeAllObjects];
}

- (void)refreshContact{
    [self getPatientsInformationWithDoctorID:KContactViewRefresh withCompletionHandelr:^(BOOL bSuccess, NSInteger contactCount) {
        
    } withErrorHandler:^(NSError *error) {
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^(){
            [NSThread sleepForTimeInterval:5];
            [self refreshContact];
        });
    }];
}


//#pragma mark - EMChatManagerBuddyDelegate
//
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

- (void)parseContact:(NSMutableArray *)contactArray
{
    /*
     NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYinUserName" ascending:YES]];
     [self.contactArray sortUsingDescriptors:sortDescriptors];
     */
    
    [self.contactDic removeAllObjects];
    for (IDGetDoctorPatient *thePatient in contactArray) {
        //        if (thePatient.isStarted) {
        //            if (![self.contactDic objectForKey:kStarContactKey]) {
        //                [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:kStarContactKey];
        //            }
        //            [[self.contactDic objectForKey:kStarContactKey] addObject:thePatient];
        //        } else if (thePatient.isBlocked) {
        //            if (![self.contactDic objectForKey:kBlockContactKey]) {
        //                [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:kBlockContactKey];
        //            }
        //            [[self.contactDic objectForKey:kBlockContactKey] addObject:thePatient];
        //        } else {
        
        //            NSString *patientPinYinName = thePatient.pinYinRealName;
        //            if (!patientPinYinName || [patientPinYinName length] == 0) {
        //                patientPinYinName = thePatient.pinYinLoginName;
        //            }
        //            NSString *firstChar = [patientPinYinName substringWithRange:NSMakeRange(0, 1)];
        //            firstChar = [firstChar uppercaseString];
        /*返回第一个字母*/
        NSString *firstChar = [self returnFirstElement:thePatient.realname];
        const char *firstElement = [firstChar cStringUsingEncoding:NSUTF8StringEncoding];
        char element = firstElement[0];
        if (element > 'Z' || element < 'A') {
            if (![[self.contactDic allKeys] containsObject:@"#"]) {
                if (![self.contactDic objectForKey:@"#"]) {
                    [self.contactDic setObject:[NSMutableArray array] forKey:@"#"];
                }
            }
            [[self.contactDic objectForKey:@"#"] addObject:thePatient];
        }else{
            if (![[self.contactDic allKeys] containsObject:firstChar]) {
                if (![self.contactDic objectForKey:firstChar]) {
                    [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:firstChar];
                }
            }
            [[self.contactDic objectForKey:firstChar] addObject:thePatient];
            //        }
        }
    }
    // 添加医生助手
    IDGetDoctorPatient *doctorAssistant = [[IDGetDoctorPatient alloc] init];
    doctorAssistant.realname = @"医生助手（官方客服）";
    doctorAssistant.patient_id = kDoctorAssistantID;
    if (![self.contactDic objectForKey:@"🔍"]) {
        [self.contactDic setObject:[[NSMutableArray alloc] init] forKey:@"🔍"];
    }
    [[self.contactDic objectForKey:@"🔍"] addObject:doctorAssistant];
    
    if ([self.contactDic count] > 0) {
        self.sortedContactKeysArray = [[self.contactDic allKeys] sortedArrayUsingSelector:@selector(contactCompare:)];
    }
    for (NSString *element in self.sortedContactKeysArray) {
        if ([element isEqualToString:@"#"]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.sortedContactKeysArray];
            [array removeObject:@"#"];
            [array insertObject:@"#" atIndex:array.count];
            self.sortedContactKeysArray = array;
        }
    }
    //搜索需要用的
    self.searchArr = contactArray;
    [self.searchArr addObject:doctorAssistant];
}

#pragma mark - 先把名字转成拼音,返回第一个字母
/*先把名字转成拼音,返回第一个字母*/
- (NSString *)returnFirstElement:(NSString *)name
{
    
    NSString *first = nil;
    
    if (name.length == 0) {
        
        first = @" ";
        
        return first;
    }
    
    
    if (name) {
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:name];
        
        // 将汉字转成有音调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)ms , 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        
        // 将拼音的音调去掉
        if (CFStringTransform((__bridge CFMutableStringRef)ms , 0, kCFStringTransformStripDiacritics, NO)) {
            
            NSString *upperMs = ms.uppercaseString;
            
            
            first = [upperMs substringToIndex:1];
            
        }
        
    }
    return first;
    
}


//- (void)parseRecentlyContact:(NSArray *)contactArray
//{
//
//}

 //环信获取最近联系人
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

//// 得到最后消息时间
//-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
//{
//    NSString *ret = @"";
//    EMMessage *lastMessage = [conversation latestMessage];;
//    if (lastMessage) {
//        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
//    }
//
//    return ret;
//}

//// 得到未读消息条数
//- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
//{
//    NSInteger ret = 0;
//    ret = conversation.unreadMessagesCount;
//
//    return  ret;
//}

#pragma mark - Public Method
//搜索的时候用的
- (id)getSearchArrWithRealName:(NSString *)realName{
    NSMutableArray *arr = [NSMutableArray array];
    for (IDGetDoctorPatient *patient in self.searchArr) {
        if ([patient.realname isEqualToString:realName]) {
            return patient;
        }
    }
    return nil;
}

//个到数量
- (NSInteger)getContactCount
{
    NSInteger contactCount = 0;
    for (NSString *key in self.sortedContactKeysArray) {
        NSArray *contactArray = [self.contactDic objectForKey:key];
        contactCount += [contactArray count];
    }
    return contactCount;
}

//得到索引的key
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


- (NSArray *)getContactArrayWithSection:(NSInteger)section
{
    NSString *key = [self.sortedContactKeysArray objectAtIndex:section];
    NSArray *contactArray = [self.contactDic valueForKey:key];
    return contactArray;
}

//通过id得到联系人
- (id)getContactWithUserID:(NSString *)userID
{
    for (id key in self.sortedContactKeysArray) {
        NSArray *contactArray = [self.contactDic objectForKey:key];
        for (IDGetDoctorPatient *thePatient in contactArray) {
            if ([userID isEqual:thePatient.patient_id]) {
                return thePatient;
            }
        }
    }
    return nil;
}

- (BOOL)containContactWithUserID:(NSString *)userID
{
    return (nil != [self getContactWithUserID:userID]);
}

//网络请求的
//- (void)asyncReloadContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
//{
//    IDIHavePatientManager *manger = [IDIHavePatientManager sharedInstance];
//    [manger getPatientsInformationWithDoctorID:0 withCompletionHandelr:^(NSArray *arr) {
//        //解析放回的数组
//        [self parseContact:arr];
//        NSInteger contactCount = [self getContactCount];
//        if (completionHandler) {
//            completionHandler(YES, contactCount);
//        }
//        //通知刷新数据
//        [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
//        
//    } withErrorHandler:^(NSError *error) {
//        
//    }];
////    [[AccountManager sharedInstance] asyncGetPatientListWithCompletionHandler:^(NSArray *patientList) {
////        [self parseContact:patientList];
////        NSInteger contactCount = [self getContactCount];
////        if (completionHandler) {
////            completionHandler(YES, contactCount);
////        }
////        [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
////    } withErrorHandler:errorHandler];
//}


#pragma mark - Recently  消息列表需要的方法和数据

- (NSInteger)getRecentlyContactCount
{
    NSInteger contactCount = [self.recentlyContactArray count];
    return contactCount;
}
//
- (NSInteger)getContactIndexWithUserID:(NSString *)userID
{
    id contact = [self getContactWithUserID:userID];
    return [self.recentlyContactArray indexOfObject:contact];
}
//
- (id)getRecentlyContactWithIndex:(NSInteger)index
{
    return [self.recentlyContactArray objectAtIndex:index];
}
//
- (id)getRecentlyContactWithUserID:(NSString *)userID
{
    for (IDGetDoctorPatient *thePatient in self.recentlyContactArray) {
        if (userID == thePatient.patient_id) {
            return thePatient;
        }
    }
    return nil;
}
//
- (void)removeRecentlyContactWithIndex:(NSInteger)index
{
    IDGetDoctorPatient *thePatient = [self.recentlyContactArray objectAtIndex:index];
    NSString *chatter = thePatient.patient_id;
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:NO append2Chat:NO];
    [self.recentlyContactArray removeObjectAtIndex:index];
}

- (void)removeRecentlyContactWithUserID:(NSString *)userID
{
    for (IDGetDoctorPatient *thePatient in self.recentlyContactArray) {
        if (userID == thePatient.patient_id) {
            NSString *chatter = [NSString stringWithFormat:@"%ld", (long)thePatient.patient_id];
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:NO append2Chat:NO];
            [self.recentlyContactArray removeObject:thePatient];
            break;
        }
    }
}

- (BOOL)containRecentlyContactWithUserID:(NSString *)userID
{
    return (nil != [self getRecentlyContactWithUserID:userID]);
}

- (void)asyncReloadRecentlyContactsWithCompletionHandler:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    NSMutableArray *recentlyConversation = [self loadDataSource];
    NSMutableArray *recentlyContactList = [[NSMutableArray alloc] init];
    for (EMConversation *obj in recentlyConversation) {
        id recentlyContact = [self getContactWithUserID:obj.chatter];
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

//联系人更新
- (void)updateContact:(id)oldContact withNewContact:(id)newContact
{
    IDGetDoctorPatient *oldPatient = oldContact;
    //Patient *newPatient = newPatient;

    NSMutableArray *contactMutableArray = [[NSMutableArray alloc] init];
    for (NSArray *contactArray in [self.contactDic allValues]) {
        [contactMutableArray addObjectsFromArray:contactArray];
    }
    if (oldContact) {
        for (NSInteger index = 0; index < contactMutableArray.count; index++) {
            IDGetDoctorPatient *tmpPatient = [contactMutableArray objectAtIndex:index];
            if (tmpPatient.patient_id == oldPatient.patient_id) {
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
    if ([self getRecentlyContactWithUserID:oldPatient.patient_id]) {
        if (oldContact) {
            for (NSInteger index = 0; index < self.recentlyContactArray.count; index++) {
                IDGetDoctorPatient *tmpPatient = [self.recentlyContactArray objectAtIndex:index];
                if (tmpPatient.patient_id == oldPatient.patient_id) {
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


#pragma mark - Clear

- (void)clearContacts
{
    [self.recentlyContactArray removeAllObjects];
    [self.contactDic removeAllObjects];            // 联系人
    self.sortedContactKeysArray = [[NSArray alloc] init];
}

#pragma mark - 网络请求
//获得联系人
- (void)getPatientsInformationWithDoctorID:(int)doctorID withCompletionHandelr:(void (^)(BOOL bSuccess, NSInteger contactCount))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler{
//    //用的是我有患者的请求模版
//    IDIHavePatientManager *manger = [IDIHavePatientManager sharedInstance];
//    [manger getPatientsInformationWithDoctorID:doctorID withCompletionHandelr:^(NSArray *arr) {
//        //解析放回的数组
//        [self parseContact:arr];
//        NSInteger contactCount = [self getContactCount];
//        if (completionHandler) {
//            completionHandler(YES, contactCount);
//        }
//        //通知刷新数据
//        //联系人数据刷新
//        [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
//        //最近联系人数据刷新
//        [[NSNotificationCenter defaultCenter] postNotificationName:kRecentlyContactChangedNotification object:nil];
//        
//    } withErrorHandler:^(NSError *error) {
//        
//    }];
    
    Account *account = [[AccountManager sharedInstance] account];
    NSString *string = nil;
    if(doctorID == KContactViewRefresh){
        string = [NSString stringWithFormat:@"v4/doctors/%ld/patients?no_medical=1",account.doctor_id];
    }else{
        string = [NSString stringWithFormat:@"v4/doctors/%ld/patients",account.doctor_id];
    }
    
    [[APIManager sharedManager] GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = [IDGetDoctorPatient objectArrayWithKeyValuesArray:responseObject[@"patients"]];
        
        self.contactArrC = [array mutableCopy];
        
        self.iHavePatientArr = [array mutableCopy];
        //解析放回的数组
        [self parseContact:array];
        NSInteger contactCount = [self getContactCount];
        if (completionHandler) {
            completionHandler(YES, contactCount);
        }
        //通知刷新数据
        //联系人数据刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kContactChangedNotification object:nil];
        //最近联系人数据刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kRecentlyContactChangedNotification object:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSMutableArray *changeArr = [NSMutableArray array];
    NSArray *newArr = [change objectForKey:@"new"];
    NSArray *oldArr = [change objectForKey:@"old"];
    for (IDGetDoctorPatient *newModel in newArr) {
        BOOL isAdd = YES;
        for (IDGetDoctorPatient *oldModel in oldArr) {
            if ([newModel.loginname isEqualToString:oldModel.loginname]) {
                isAdd = NO;
            }
        }
        if (isAdd == YES) {
            [changeArr addObject:newModel.realname];
        }
    }
    if (self.isAppear == YES) {
        if (changeArr.count >0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你成功添加了%@患者",changeArr[0]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
            
//            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"你成功添加了%@患者",changeArr[0]] toView:keyWindow];
            
            NSLog(@"变化啦啦啦啦");
        }
    }
    self.isAppear = YES;
}

- (void)asyncCallPatientWithUserID:(NSInteger)userID withCompletionHandler:(void (^)(BOOL isSuccess))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler
{
    
    NSString *urlPath = [NSString stringWithFormat:@"/api/my_patients/%ld/call", (long)userID];
    
    [[APIManager sharedManager] POST:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorHandler(error);
    }];
}



@end
