//
//  IDSearchViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class IDMedicaledModel;

typedef void(^ChangeViewBlock)(IDMedicaledModel *model);


@interface IDSearchViewController : BaseViewController

@property (nonatomic, copy) ChangeViewBlock block;

// 患者的id
@property (nonatomic, assign) NSInteger patient_id;

// 患者所在地区的id
@property (nonatomic, assign) NSInteger regin_id;

@end
