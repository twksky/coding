//
//  IDMainViewViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDMainViewViewController.h"


#import "AccountManager.h"
#import "Account.h"

@interface IDMainViewViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation IDMainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *token = [[AccountManager sharedInstance] account].token;
    
    self.title = _titles;
    
    // http://m.ihaoyisheng.com/medical/processes/5608d0f560b232b35daf80d8?patient_medical_id=5620dc3260b27457e850a39a&token=6827515473022303125091-42
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@",_base_url,token]];
    

    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}


#pragma mark - 懒加载
-(UIWebView *)webView
{
    if (_webView == nil) {
       
        _webView = [[UIWebView alloc] init];
        
        _webView.delegate = self;
    }
    
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
