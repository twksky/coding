//
//  ReviseContactInfoViewController.h
//  AppFramework
//
//  Created by ABC on 8/19/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class Patient;
@class ReviseContactInfoViewController;

@protocol ReviseContactInfoViewControllerDelegate <NSObject>

- (void)reviseContactInfoViewController:(ReviseContactInfoViewController *)viewController didChangeNoteNameWithText:(NSString *)text;

@end

@interface ReviseContactInfoViewController : BaseMainViewController

@property (nonatomic, weak) id<ReviseContactInfoViewControllerDelegate> delegate;

- (id)initWithPatient:(Patient *)patient;

@end
