//
//  Doctor.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/21.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@interface Doctor : NSObject

@property (nonatomic, copy) NSString *credentials_id;

@property (nonatomic, copy) NSString *hospital;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger urgency_ask_price;

@property (nonatomic, copy) NSString *loginname;

@property (nonatomic, assign) NSInteger hospital_id;

@property (nonatomic, assign) NSInteger outpatient_ask_price;

@property (nonatomic, copy) NSString *qr_code_url;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, assign) NSInteger region_id;

@property (nonatomic, copy) NSString *schedule;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *avatar_url;

@property (nonatomic, assign) NSInteger balance;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray *skills;

@property (nonatomic, assign) NSInteger doctorId;

@property (nonatomic, assign) NSInteger voted_count;

@property (nonatomic, copy) NSString *department;

@property (nonatomic, copy) NSString *credentials_url;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, assign) NSInteger hospital_ask_price;

@property (nonatomic, copy) NSString *office_phone;

@property (nonatomic, assign) BOOL online;

@property (nonatomic, copy) NSString *easemob_passwd;


@end
