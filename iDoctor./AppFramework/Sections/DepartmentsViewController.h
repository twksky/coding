//
//  DepartmentsViewController.h
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Department.h"

@class DepartmentsViewController;

@protocol DepartmentsViewControllerDelegate <NSObject>

- (void)departmentsViewController:(DepartmentsViewController *)controller didSelectedDepartments:(NSArray *)departmentsArray;

@end

@interface DepartmentsViewController : UIViewController

@property (nonatomic, weak) id <DepartmentsViewControllerDelegate>  delegate;

@end
