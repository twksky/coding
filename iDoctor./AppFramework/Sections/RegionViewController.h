//
//  RegionViewController.h
//  AppFramework
//
//  Created by ABC on 6/6/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionItem.h"

@class RegionViewController;

@protocol RegionViewControllerDelegate <NSObject>

- (void)regionViewController:(RegionViewController *)viewController didSelectedRegionItem:(RegionItem *)regionItem;

@end

@interface RegionViewController : UIViewController

@property (nonatomic, weak)     id <RegionViewControllerDelegate>   delegate;

- (id)initWithRegionCode:(NSInteger)regionCode;

@end
