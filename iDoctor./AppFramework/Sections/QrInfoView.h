//
//  QrInfoView.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/23.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface QrInfoView : UIView

- (void)loadDataWithAccount:(Account *)account;

@end
