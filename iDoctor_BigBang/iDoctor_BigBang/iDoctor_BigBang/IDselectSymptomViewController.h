//
//  IDselectSymptomViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^returnBlock)(NSArray *array, NSDictionary *diction);

@interface IDselectSymptomViewController : BaseViewController

@property (nonatomic, copy) returnBlock block;

@property (nonatomic, strong) NSDictionary *diction;

@end
