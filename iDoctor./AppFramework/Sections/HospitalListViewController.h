//
//  HospitalListViewController.h
//  AppFramework
//
//  Created by ABC on 7/19/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HospitalItem;
@class HospitalListViewController;

@protocol HospitalListViewControllerDelegate <NSObject>

- (void)hospitalListViewController:(HospitalListViewController *)viewController didSelectedHospitalItem:(HospitalItem *)hospitalItem;

@end

@interface HospitalListViewController : UIViewController

@property (nonatomic, weak) id<HospitalListViewControllerDelegate> delegate;

- (id)initWithRegionCode:(NSInteger)regionCode;

@end
