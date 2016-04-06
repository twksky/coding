//
//  CardViewController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/17.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewController : UIViewController

+ (instancetype)visibleGridMenu;

@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIBezierPath *backgroundPath;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat blurLevel;

@property (nonatomic, strong) UIBezierPath *blurExclusionPath;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, strong) UIFont *itemFont;

@property (nonatomic, assign) NSTextAlignment itemTextAlignment;

@property (nonatomic, copy) dispatch_block_t dismissAction;

@property (nonatomic, assign) BOOL bounces;

@property (nonatomic, strong) UIButton *cancelBtn;//取消按钮

- (instancetype)initForView:(UIView *)view;//需要手动调用的方法，创建一个View出来

- (void)showInViewController:(UIViewController *)parentViewController center:(CGPoint)center;

- (void)dismissAnimated:(BOOL)animated;

@end


@interface RNLongPressGestureRecognizer : UILongPressGestureRecognizer

@end
