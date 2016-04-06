//
//  DFDSetPriceViewController.h
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class DFDSetPriceViewController;

@protocol DFDSetPriceViewControllerDelegate <NSObject>

- (void)setPriceViewController:(DFDSetPriceViewController *)viewController didSelectedPrice:(NSInteger)price;

@end

@interface DFDSetPriceViewController : BaseMainViewController

@property (nonatomic, weak) id<DFDSetPriceViewControllerDelegate> delegate;

@end
