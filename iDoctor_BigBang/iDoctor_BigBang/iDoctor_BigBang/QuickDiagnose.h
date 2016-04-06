//
//  QuickDiagnose.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@class User;
@interface QuickDiagnose : NSObject

@property (nonatomic, copy) NSString *quickDiagnoseDescription;

@property (nonatomic, assign) NSInteger quickDiagnoseId;

@property (nonatomic, copy) NSString *report_type;

@property (nonatomic, strong) User *user;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL answer;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray *images_url;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *medicine;

@property (nonatomic, copy) NSString *ctime_iso;

@property (nonatomic, assign) NSInteger images_count;

@property (nonatomic, copy) NSString *last_time;

@property (nonatomic, assign) NSInteger region_id;

@property (nonatomic, copy) NSString *burst_reason;

@property (nonatomic, assign) NSInteger comments_count;

@property (nonatomic, copy) NSString *department;

@property (nonatomic, copy) NSString *genetic_disease;

@property (nonatomic, copy) NSString *surgery;


@end


@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *avatar_url;

@property (nonatomic, copy) NSString *realname;

@end

