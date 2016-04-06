//
//  IDSelectTimeViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/12.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^selectedTimeBlock)(NSArray *timeArray);

@interface IDSelectTimeViewController : BaseViewController


@property (nonatomic, copy) selectedTimeBlock block;

@property (nonatomic, strong) NSArray *selectTimeArray;

@end
