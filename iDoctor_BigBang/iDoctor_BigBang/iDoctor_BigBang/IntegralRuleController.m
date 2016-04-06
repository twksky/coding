//
//  IntegralController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IntegralRuleController.h"

@interface IntegralRuleController ()
<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *scoreRuleWebView;

@end

@implementation IntegralRuleController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews {
    
    [self.view addSubview:self.scoreRuleWebView];
    [self.scoreRuleWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ihaoyisheng.com/w/score/rules/"]];
    [self.scoreRuleWebView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self hideLoading];
}



- (UIWebView *)scoreRuleWebView {
    
    if(_scoreRuleWebView == nil) {
        
        _scoreRuleWebView = [[UIWebView alloc] init];
        _scoreRuleWebView.delegate = self;
    }
    return _scoreRuleWebView;
}

@end
