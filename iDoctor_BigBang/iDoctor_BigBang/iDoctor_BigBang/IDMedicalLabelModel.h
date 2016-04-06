//
//  IDMedicalLabelModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/30.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//


// 病例标签
#import <Foundation/Foundation.h>

@interface IDMedicalLabelModel : NSObject

/**
 *  伴随症状
 */
@property (nonatomic, strong) NSString *follow_symptom;

/**
 *  发病的时间
 */
@property (nonatomic, strong) NSString *disease_time;

/**
 *  治疗
 */
@property (nonatomic, strong) NSString *treatment;

/**
 *  并发症
 */
@property (nonatomic, strong) NSString *complication;

/**
 *  检查项目
 */
@property (nonatomic, strong) NSString *check_item;

/**
 *  病理
 */
@property (nonatomic, strong) NSString *pathology;

/**
 *  病例医院
 */
@property (nonatomic, strong) NSString *medical_history;


/**
 *  操作
 */
@property (nonatomic, strong) NSString *operation;

/**
 *  病症
 */
@property (nonatomic, strong) NSString *symptom;

/**
 *  体征
 */
@property (nonatomic, strong) NSString *stage;


@end
