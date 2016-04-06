//
//  IDPatientCaseView.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDSearchViewControllerDelegate;

@protocol IDPatientCaseViewDelegate <NSObject>

- (void)searchButtonClickedPushSearchViewController:(UIButton *)button;

@end


@interface IDPatientCaseView : UIView


@property (nonatomic, assign) id<IDPatientCaseViewDelegate> delegate;


@end
