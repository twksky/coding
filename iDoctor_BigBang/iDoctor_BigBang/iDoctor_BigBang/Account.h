//
//  Account.h
//  iDoctor_BigBang
//
//  Created by tianxiewuhua on 15/9/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//


@interface Account : NSObject

/**
 *  用户头像
 */
@property (nonatomic, strong) NSString *avatar_url;

/**
 *  余额
 */
@property (nonatomic, assign) NSInteger balance;

/**
 *  简介
 */
@property (nonatomic, strong) NSString *brief;
/**
 *  检查?
 */
@property (nonatomic, assign) BOOL checked;

/**
 *  证书的ID
 */
@property (nonatomic, strong) NSString *credentials_id;

/**
 *  证书的地址
 */
@property (nonatomic, strong) NSString *credentials_url;

/**
 *  所属部门
 */
@property (nonatomic, strong) NSString *department;

/**
 *  环信密码
 */
@property (nonatomic, strong) NSString *easemob_passwd;

/**
 *  详细地址
 */
@property (nonatomic, strong) NSString *full_region_path;

/**
 *  医院
 */
@property (nonatomic, strong) NSString *hospital;

/**
 *  医院询问的价格
 */
@property (nonatomic, assign) NSInteger hospital_ask_price;

/**
 *  医院id
 */
@property (nonatomic, assign) NSInteger hospital_id;

/**
 *  医生的id （登录者的ID）
 */
@property (nonatomic, assign) NSInteger doctor_id;

/**
 *  登录名
 */
@property (nonatomic, strong) NSString *loginname;

/**
 *  电话号码
 */
@property (nonatomic, strong) NSString *mobile;

/**
 *  办公电话
 */
@property (nonatomic, strong) NSString *office_phone;

/**
 *  是否在线
 */
@property (nonatomic, assign) BOOL online;

/**
 *  门诊病人询问价格
 */
@property (nonatomic, assign) NSInteger outpatient_ask_price;

/**
 *  相应的二维码地址
 */
@property (nonatomic, strong) NSString *qr_code_url;

/**
 *  真实姓名
 */
@property (nonatomic, strong) NSString *realname;


/**
 *  所在的地区
 */
@property (nonatomic, strong) NSString *region;

/**
 *  所在地区的id
 */
@property (nonatomic, assign) NSInteger region_id;

/**
 *  出诊时间
 */
@property (nonatomic, strong) NSString *schedule;

/**
 *  积分
 */
@property (nonatomic, assign) NSInteger score;
/**
 *  技能
 */
@property (nonatomic, strong) NSArray *skills;
/**
 *  性别
 */
@property (nonatomic, strong) NSString *sex;

/**
 *  医生头衔
 */
@property (nonatomic, strong) NSString *title;

/**
 *  token
 */
@property (nonatomic, strong) NSString *token;

/**
 *  紧急询问价格
 */
@property (nonatomic, assign) NSInteger urgency_ask_price;

/**
 *  得到的票数
 */
@property (nonatomic, assign) NSInteger voted_count;

/**
 *  新门诊时间
 */
@property (nonatomic, strong) NSArray *work_time_list;

- (NSString *)getDisplayName;

@end
