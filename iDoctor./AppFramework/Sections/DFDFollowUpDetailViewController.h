//
//  DFDFollowUpDetailViewController.h
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FollowUpReport;
@class DFDFollowUpDetailViewController;

@protocol DFDFollowUpDetailViewControllerDelegate <NSObject>

- (void)followUpDetailViewController:(DFDFollowUpDetailViewController *)viewController didChangedFollowUpReportStatus:(FollowUpReport *)report;

@end

@interface DFDFollowUpDetailViewController : UIViewController

@property (nonatomic, weak) id<DFDFollowUpDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) FollowUpReport    *followUpReport;

@end
