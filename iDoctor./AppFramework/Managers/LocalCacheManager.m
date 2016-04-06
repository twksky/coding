//
//  LocalCacheManager.m
//  AppFramework
//
//  Created by ABC on 7/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "LocalCacheManager.h"
#import "FMDB.h"

@interface LocalCacheManager ()

@property (nonatomic, strong) FMDatabase    *db;
@property (nonatomic, assign) BOOL          dbOk;
@property (nonatomic, assign) long          cacheTimeout;

- (void)initManager;
- (BOOL)isTableExisted:(NSString *)tableName;

@end

@implementation LocalCacheManager

#define TABLE_ACCOUNT           @"account"
#define TABLE_LOGIN_ACCOUNT     @"login_account"
#define ONE_MINUTE 60  //(1 minutes)
#define kFirstLaunch   @"kFirstLaunch"
#define kPlayVibration @"kPlayVibration"
#define kPlayFromSpeaker @"kPlayFromSpeaker"

+ (LocalCacheManager *)sharedInstance
{
    static LocalCacheManager *localCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localCache = [[LocalCacheManager alloc] init];
        [localCache initManager];
    });
    return localCache;
}

- (void)initManager
{
    _cacheTimeout = ONE_MINUTE * 10;
    
    //init db
    NSString *dbPathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbFilePath = [dbPathDir stringByAppendingPathComponent:@"iDoctorCache.db"];
    _db = [FMDatabase databaseWithPath:dbFilePath];
    _dbOk = [_db open];
    if (!_dbOk) {
        DLog(@"initDataBase failed! path=%@", dbFilePath);
        return;
    }
    
    //1.account
    if (![self isTableExisted:TABLE_ACCOUNT]) {
        [_db executeUpdate:[NSString stringWithFormat:@"create table %@(account_name text unique, resp text, create_time integer)", TABLE_ACCOUNT]];
    }
    
    // 2.loginAccount
    if (![self isTableExisted:TABLE_LOGIN_ACCOUNT]) {
        [_db executeUpdate:[NSString stringWithFormat:@"create table %@(login_account text unique, login_name text, login_password text)", TABLE_LOGIN_ACCOUNT]];
    }
}

- (void) dealloc
{
    if(_db && _dbOk) {
        [_db close];
    }
}

- (void)emptyCache
{
    if (!_dbOk) {
        return;
    }
    
    @try {
        @synchronized(self) {
            __unused BOOL bRet = [_db executeUpdate:[NSString stringWithFormat:@"delete from %@", TABLE_ACCOUNT]];
            __unused BOOL cRet = [_db executeUpdate:[NSString stringWithFormat:@"delete from %@", TABLE_LOGIN_ACCOUNT]];
            DLog(@"empty account-result:%d", cRet);
        }
    } @catch (NSException *exception) {
        DLog(@"emptyCache failed,%@-%@", exception.name, exception.reason);
    }
}

- (BOOL)isTableExisted:(NSString *)tableName
{
    FMResultSet *rs = [_db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]){
        int count = [rs intForColumn:@"count"];
        return (count != 0);
    }
    return NO;
}

- (BOOL) isFirstLaunch
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kFirstLaunch]){
        return YES;
    }else{
        return NO;
    }
}

- (void) setFirstLaunched
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLaunch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isPlayVibration
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPlayVibration];
}

- (void)setPlayVibration:(BOOL)bPlayVibration
{
    [[NSUserDefaults standardUserDefaults] setBool:bPlayVibration forKey:kPlayVibration];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isPlayFromSpeaker
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPlayFromSpeaker];
}

- (void)setPlayFromSpeaker:(BOOL)bPlayFromSpeaker
{
    [[NSUserDefaults standardUserDefaults] setBool:bPlayFromSpeaker forKey:kPlayFromSpeaker];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)saveAvatarImage:(UIImage *)avatarImage
{
    NSData *imageData = UIImagePNGRepresentation(avatarImage);
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(avatarImage, 1);
    }
    if (!imageData) {
        return nil;
    }
    
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"image/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:fullPathToFile withIntermediateDirectories:YES attributes:nil error:&error];
    }
    fullPathToFile = [fullPathToFile stringByAppendingPathComponent:@"avatar"];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}

- (void)saveLoginAccountWithLoginName:(NSString *)loginName withLoginPassword:(NSString *)loginPassword;
{
    if (!_dbOk) {
        return;
    }
    
    @try
    {
        @synchronized(self)
        {
            NSString *sql = [NSString stringWithFormat:@"insert or replace into %@(login_account, login_name, login_password) values('%@', '%@','%@')", TABLE_LOGIN_ACCOUNT, @"login_account", loginName, loginPassword];
            DLog(@"saveLoginAccount:%@", sql);
            __unused BOOL bRet = [_db executeUpdate:sql];
            DLog(@"saveLoginAccount-result:%d",bRet);
        }
    }
    @catch (NSException *exception)
    {
        DLog(@"saveLoginAccount failed,%@-%@", exception.name, exception.reason);
    }
}

- (NSString *)getAccountLoginName
{
    if (!_dbOk) {
        return  nil;
    }
    @try
    {
        @synchronized(self)
        {
            NSString *sql = [NSString stringWithFormat:@"select login_name from %@ where login_account='%@'", TABLE_LOGIN_ACCOUNT, @"login_account"];
            FMResultSet *result = [_db executeQuery:sql];
            
            DLog(@"getAccountLoginName:%@",sql);
            if([result next])
            {
                NSString *resp = [result stringForColumn:@"login_name"];
                DLog(@"getAccountLoginName-result:%@", resp);
                return resp;
            }
            
            return nil;
        }
    }
    @catch (NSException *exception)
    {
        DLog(@"getAccountLoginName failed,%@-%@",exception.name,exception.reason);
    }
}

- (NSString *)getAccountLoginPassword
{
    if (!_dbOk) {
        return  nil;
    }
    @try
    {
        @synchronized(self)
        {
            NSString *sql = [NSString stringWithFormat:@"select login_password from %@ where login_account='%@'", TABLE_LOGIN_ACCOUNT, @"login_account"];
            FMResultSet *result = [_db executeQuery:sql];
            
            DLog(@"getAccountLoginPassword:%@",sql);
            if([result next])
            {
                NSString *resp = [result stringForColumn:@"login_password"];
                DLog(@"getAccountLoginPassword-result:%@", resp);
                return resp;
            }
            
            return nil;
        }
    }
    @catch (NSException *exception)
    {
        DLog(@"getAccountLoginPassword failed,%@-%@", exception.name, exception.reason);
    }
}


- (NSInteger)getSystemMessageUnreadCountWithMessageType:(NSString *)msgType
{
    NSNumber *msgCountNumber = [[NSUserDefaults standardUserDefaults] valueForKey:msgType];
    return [msgCountNumber integerValue];
}

- (void)saveSystemMessageUnreadCount:(NSInteger)msgCount withMessageType:(NSString *)msgType
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:msgCount] forKey:msgType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
