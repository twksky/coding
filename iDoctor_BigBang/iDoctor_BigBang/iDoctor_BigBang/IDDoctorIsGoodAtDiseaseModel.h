//
//  IDDoctorIsGoodAtDiseaseModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/14.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

// 1: 疾病与疾病组 2：症状与体征
@interface IDDoctorIsGoodAtDiseaseModel : NSObject

/**
 *  类型
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  id
 */
@property (nonatomic, assign) NSInteger disease_id;

/**
 *  名字
 */
@property (nonatomic, strong) NSString *name;

@end
