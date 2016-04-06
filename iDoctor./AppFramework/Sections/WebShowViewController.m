//
//  BlogDetailViewController.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "WebShowViewController.h"
#import "BlogItem.h"
#import <PureLayout.h>

@interface WebShowViewController ()
<
UIWebViewDelegate
>

@property (nonatomic, strong) UIWebView *templateWebView;
@property (nonatomic, strong) NSString *url;

@end

@implementation WebShowViewController

- (instancetype)initWithUrl:(NSString *)url {
    
    self = [super init];
    if (self) {
        
        self.url = url;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self makeLeftReturnBarButtonItem];
    [self.view addSubview:self.templateWebView];
    [self.view addConstraints:[self.templateWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    [self.templateWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self showLoading];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self dismissLoading];
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    //TODO 加载失败的处理方式
}


#pragma mark - property

- (UIWebView *)templateWebView {
    
    if (!_templateWebView) {
        
        _templateWebView = [[UIWebView alloc] init];
        _templateWebView.delegate = self;
        _templateWebView.scalesPageToFit = YES;
    }
    
    return _templateWebView;
}

@end
