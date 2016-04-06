//
//  WithDrawalCashViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"


//用来取代WithdrawalViewControllerStep2 提现页面 重写UI
@interface WithDrawalCashViewController : BaseMainViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end
