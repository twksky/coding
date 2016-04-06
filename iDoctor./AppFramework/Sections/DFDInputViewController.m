//
//  DFDInputViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/13/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDInputViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "IQKeyboardManager.h"
#import "UIView+Autolayout.h"

@interface DFDInputViewController ()

- (void)cancelBarButtonItemClicked:(id)sender;
- (void)confirmBarButtonItemClicked:(id)sender;

@end

@implementation DFDInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
    
    [self.view addSubview:self.textView];
    [self.view addConstraints:[self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonItemClicked:)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = confirmButtonItem;
    
    [self.textView setText:self.inputText];
    
    self.textViewWidthLayoutConstraint.constant = App_Frame_Width;
    self.textViewHeightLayoutConstraint.constant = App_Frame_Height - kStatusBarHeight - self.navigationBarHeight;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}


#pragma mark - Selector

- (void)cancelBarButtonItemClicked:(id)sender
{
    [self.delegate inputViewControllerDidCancelInput:self];
}

- (void)confirmBarButtonItemClicked:(id)sender
{
    NSString *confirmedText = self.textView.text;
    if (nil != self.confirmInputTextBlock) {
        self.confirmInputTextBlock(confirmedText);
    }
    [self.delegate inputViewController:self didConfirmInputWithText:confirmedText];
}


#pragma mark - Public Method

+ (void)presentInputViewControllerWithTitle:(NSString *)title inputText:(NSString *)inputText confirmInputTextBlock:(ConfirmInputTextBlock)block parentViewController:(UIViewController<DFDInputViewControllerDelegate> *)viewController
{
    DFDInputViewController *inputViewController = [[DFDInputViewController alloc] init];
    inputViewController.delegate = viewController;
    inputViewController.title = title;
    inputViewController.inputText = inputText;
    inputViewController.confirmInputTextBlock = block;
    
    UINavigationController *inputNavigationController = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:inputViewController];
    [viewController.navigationController presentViewController:inputNavigationController animated:YES completion:^{
        
    }];
}


#pragma mark - Property

- (UITextView *)textView
{
    if (nil == _textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

- (NSLayoutConstraint *)textViewWidthLayoutConstraint
{
    if (nil != _textViewWidthLayoutConstraint) {
        _textViewWidthLayoutConstraint = [[NSLayoutConstraint alloc] init];
    }
    return _textViewWidthLayoutConstraint;
}

- (NSLayoutConstraint *)textViewHeightLayoutConstraint
{
    if (nil != _textViewHeightLayoutConstraint) {
        _textViewHeightLayoutConstraint = [[NSLayoutConstraint alloc] init];
    }
    return _textViewHeightLayoutConstraint;
}

@end
