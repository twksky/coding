//
//  SupplementViewController.h
//  AppFramework
//
//  Created by ABC on 8/10/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SupplementViewController;

@protocol SupplementViewControllerDelegate <NSObject>

- (void)supplementViewControllerDidSuccessSupplement:(SupplementViewController *)viewController;

@end

@interface SupplementViewController : UIViewController

@property (nonatomic, weak) id<SupplementViewControllerDelegate> delegate;

@end
