//
//  DFDFollowUpListViewController.h
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManager.h"
#import "DFDFollowUpDetailViewController.h"

@interface DFDFollowUpListViewController : UIViewController
<
DFDFollowUpDetailViewControllerDelegate
>

@property (nonatomic, strong) NSString  *followUpReportType;

- (void)selectedFollowUpReport:(FollowUpReport *)followUpReport;

@end
