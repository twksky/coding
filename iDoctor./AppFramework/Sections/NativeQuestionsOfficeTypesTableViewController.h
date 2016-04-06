//
//  NativeQuestionsOfficeTypesTableViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/3.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NativeQuestionsOfficeTypesTableViewControllerDelegate <NSObject>

- (void)didSelectedOfficeType:(NSString *)officeType;

@end

@interface NativeQuestionsOfficeTypesTableViewController : UIViewController

@property (nonatomic, weak) id<NativeQuestionsOfficeTypesTableViewControllerDelegate> delegate;

@end
