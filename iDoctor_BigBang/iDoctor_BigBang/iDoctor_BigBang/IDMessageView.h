//
//  IDMessageView.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDGetPatientInformation;

@protocol IDMessageViewDelegate <NSObject>

// 将需要进行上传的数据 进行相应的回传
- (void)nextStepWithDic:(NSDictionary *)diction;

@end

@interface IDMessageView : UIView

@property (nonatomic, assign) id<IDMessageViewDelegate> delegate;

- (instancetype)initWithModel:(IDGetPatientInformation *)model;

@end
