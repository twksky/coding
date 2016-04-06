//
//  IDSymptomSearchViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^symptomSearchBlock)(NSDictionary *diction);

@interface IDSymptomSearchViewController : BaseViewController

@property (nonatomic, copy) symptomSearchBlock searchBlock;

@property (nonatomic, strong) NSDictionary *diction;

@end
