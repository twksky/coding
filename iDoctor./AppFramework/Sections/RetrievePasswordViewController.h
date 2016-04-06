//
//  RetrievePasswordViewController.h
//  AppFramework
//
//  Created by ABC on 8/7/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@protocol RetrievePasswordViewControllerDelegate <NSObject>

- (void)RetrievePasswordSuccess;

@end

@interface RetrievePasswordViewController : BaseMainViewController

@property (weak, nonatomic) id<RetrievePasswordViewControllerDelegate> delegate;

- (instancetype)initWithMobile:(NSString *)mobile;

@end
