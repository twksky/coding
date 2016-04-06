//
//  ReviseUserInfoViewController.h
//  AppFramework
//
//  Created by ABC on 8/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

enum UserInfoType
{
    UIT_Mobile = 0,
    UIT_Realname,
    UIT_Schedule,
    UIT_Brief,
    UIT_OfficePhone
};

@class Account;
@class ReviseUserInfoViewController;

@protocol ReviseUserInfoViewControllerDelegate <NSObject>

- (void)reviseUserInfoViewController:(ReviseUserInfoViewController *)viewController didChangeType:(NSInteger)type withText:(NSString *)text;

@end

@interface ReviseUserInfoViewController : UIViewController

@property (nonatomic, weak) id<ReviseUserInfoViewControllerDelegate> delegate;

- (id)initWithUserInfoType:(NSInteger)type withAccount:(Account *)account;

@end
