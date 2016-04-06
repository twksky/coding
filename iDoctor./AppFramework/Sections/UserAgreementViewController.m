//
//  UserAgreementViewController.m
//  AppFramework
//
//  Created by ABC on 8/9/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "UserAgreementViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "MBProgressHUD.h"

@interface UserAgreementViewController () <MBProgressHUDDelegate>

@property (nonatomic, strong) UITextView        *textView;
@property (nonatomic, strong) MBProgressHUD     *progressHUD;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation UserAgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title = @"好医生用户隐私与用户协议";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithTitle:@"好医生用户隐私与用户协议" leftBarButtonItem:[self makeMiniLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:@"userAgreement"
                                                            ofType:@"txt"]
                                  encoding:NSUTF8StringEncoding
                                  error:&error];
    
    // If there are no results, something went wrong
    if (textFileContents == nil) {
        // an error occurred
        NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }
    [self.textView setText:textFileContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override parent methods

- (void)returnPreviousViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupSubviews
{
    [self.view addSubview:self.textView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
}


#pragma mark - Property

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [_textView setEditable:NO];
    }
    return _textView;
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"请稍候...";
    }
    return _progressHUD;
}

@end
