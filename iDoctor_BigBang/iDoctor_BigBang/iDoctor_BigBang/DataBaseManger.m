//
//  DataBaseManger.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/29.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "DataBaseManger.h"

static FMDatabaseQueue *_queue;

#define KPath [NSString stringWithFormat:@"%@/iDoctorDataBase.sqlite",NSHomeDirectory()]

@implementation DataBaseManger

+(void)initialize{
    //创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:KPath];
    
    // 3.创建表
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 首页资讯表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS HOMEINFO (Id INTEGER PRIMARY KEY AUTOINCREMENT, DATAARR BLOB);"];
    }];

}

+ (void)addHomeInfoWithData:(id)data
{
    //只缓存前十条数据
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *d = [NSKeyedArchiver archivedDataWithRootObject:data];
        [db executeUpdate:@"INSERT INTO HOMEINFO (DATAARR) values(?)",d];
    }];
}

+ (id)getHomeInfoWithData:(id)model{
    __block NSMutableArray *dataArr = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from HOMEINFO;"];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"DATAARR"];
            dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        [rs close];
    }];
    return dataArr;
}

@end
