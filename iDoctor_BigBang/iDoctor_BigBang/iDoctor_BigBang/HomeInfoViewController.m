//
//  HomeInfoViewController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/24.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "HomeInfoViewController.h"
#import "BlogCommentsViewController.h"
#import "HomeInfoModel.h"
#import "AddBlogCommentViewController.h"

@interface HomeInfoViewController ()<AddBlogCommentViewControllerDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *commentsBtn;//评论
@property (nonatomic, strong) UIButton *commentItBtn;//写评论

@end

@implementation HomeInfoViewController

-(instancetype)initWithUrlString:(HomeInfoModel *)model{
    self = [super init];
    if (self) {
        self.blogItem = model;
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:model.info_url]];
        [self.webView loadRequest:request];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCommentsNumber:self.blogItem.comments_count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addObserver:self forKeyPath:@"self.blogItem.comments_count" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    self.title = @"资讯";
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.commentsBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    // 约束buttom
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(60);
    }];
    
    [bottomView addSubview:self.commentItBtn];
    [self.commentItBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.left.equalTo(45);
        make.bottom.equalTo(-12);
        make.right.equalTo(-45);
    }];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.top).offset(0);
    }];
}

- (void)setCommentsNumber:(NSInteger)number {
    
    if (number > 999) {
        
        [self.commentsBtn setTitle:@"评论999+" forState:UIControlStateNormal];
    }
    else {
        
        [self.commentsBtn setTitle:[NSString stringWithFormat:@"评论%ld", number] forState:UIControlStateNormal];
    }
    self.commentsBtn.backgroundColor = [UIColor whiteColor];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    
//}

#pragma mark - selector

//不是写评论，是看评论
- (void)toBlogsCommentsViewController {
    
    BlogCommentsViewController *bvc = [[BlogCommentsViewController alloc] initWithBlog:self.blogItem];
    [self.navigationController pushViewController:bvc animated:YES];
}

- (void)toAddCommentViewController {
    
    AddBlogCommentViewController *acv = [[AddBlogCommentViewController alloc] initWithBlog:self.blogItem];
    acv.delegate = self;
    [self.navigationController pushViewController:acv animated:YES];
    
}

//右上角评论
- (UIButton *)commentsBtn {
    
    if (!_commentsBtn) {
        _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // [_commentsBtn setBackgroundImage:[UIImage imageNamed:@"" ] forState:UIControlStateNormal];//TODO切图
        _commentsBtn.frame = CGRectMake(0.0f, 0.0f, 60.0f, 20.0f);
        _commentsBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [_commentsBtn setTitleColor:UIColorFromRGB(0x34d2b4) forState:UIControlStateNormal];
        [_commentsBtn addTarget:self action:@selector(toBlogsCommentsViewController) forControlEvents:UIControlEventTouchUpInside];
        UIEdgeInsets insets = _commentsBtn.titleEdgeInsets;
        insets.top = 2.5f;
        insets.left = 3.0f;
        [_commentsBtn setTitleEdgeInsets:insets];
    }
    
    return _commentsBtn;
}

//写评论
- (UIButton *)commentItBtn {
    if (!_commentItBtn) {
        _commentItBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentItBtn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        _commentItBtn.layer.borderWidth = 0.7f;
        _commentItBtn.layer.borderColor = [UIColorFromRGB(0xd6d6d6) CGColor];
        _commentItBtn.layer.cornerRadius = 18.0f;//(60 - 12 - 12)/2
        [_commentItBtn setTitle:@" 写评论" forState:UIControlStateNormal];
        [_commentItBtn setImage:[UIImage imageNamed:@"矩形-1-拷贝"] forState:UIControlStateNormal];
        [_commentItBtn setTitleColor:UIColorFromRGB(0x908f94) forState:UIControlStateNormal];
        [_commentItBtn addTarget:self action:@selector(toAddCommentViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commentItBtn;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
