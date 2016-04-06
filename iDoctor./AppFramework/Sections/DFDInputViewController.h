//
//  DFDInputViewController.h
//  AppFramework
//
//  Created by DebugLife on 2/13/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFDInputViewController;

@protocol DFDInputViewControllerDelegate <NSObject>

- (void)inputViewController:(DFDInputViewController *)viewController didConfirmInputWithText:(NSString *)text;
- (void)inputViewControllerDidCancelInput:(DFDInputViewController *)viewController;

@end

typedef void (^ConfirmInputTextBlock)(NSString *text);

@interface DFDInputViewController : UIViewController

@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) NSLayoutConstraint *textViewWidthLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textViewHeightLayoutConstraint;

@property (nonatomic, weak) id<DFDInputViewControllerDelegate>  delegate;

@property (nonatomic, strong) NSString *inputText;
@property (nonatomic, strong) ConfirmInputTextBlock confirmInputTextBlock;

+ (void)presentInputViewControllerWithTitle:(NSString *)title inputText:(NSString *)inputText confirmInputTextBlock:(ConfirmInputTextBlock)block parentViewController:(UIViewController<DFDInputViewControllerDelegate> *)viewController;

@end
