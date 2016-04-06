//
//  IDNoFinishController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/27.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class IDMedicaledModel;

typedef void(^saveMedicalBlock)(void);

@interface IDNoFinishController : BaseViewController

@property (nonatomic, strong) IDMedicaledModel *model;

@property (nonatomic, copy) saveMedicalBlock block;

@end
