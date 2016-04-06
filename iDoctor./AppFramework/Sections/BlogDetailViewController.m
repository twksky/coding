//
//  BlogDetailViewController.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BlogDetailViewController.h"
#import "BlogItem.h"
#import <PureLayout.h>
#import "BlogCommentsViewController.h"
#import "AddBlogCommentViewController.h"

@interface BlogDetailViewController ()
<
UIWebViewDelegate,
AddBlogCommentViewControllerDelegate
>

@property (nonatomic, strong) UIWebView *blogWebView;
@property (nonatomic, strong) BlogItem *blogItem;
@property (nonatomic, strong) UIButton *commentsBtn;
@property (nonatomic, strong) UIButton *commentItBtn;

@end

@implementation BlogDetailViewController

- (instancetype)initWithBlogItem:(BlogItem *)blogItem {
    
    self = [super init];
    if (self) {
        
        self.blogItem = blogItem;
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.commentsBtn];
    
    [self setNavigationBarWithTitle:@"医学播报" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:barBtnItem];
    
    [self setupViews];
    
    [self.blogWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.blogItem.url]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setCommentsNumber:self.blogItem.commentCount];
}

#pragma mark - private methods

- (void)setupViews {
    
    UIView *contentView = self.view;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    // 约束buttom
    [contentView addSubview:bottomView];
    {
        [contentView addConstraints:[bottomView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 60.0f)]];
        [contentView addConstraint:[bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
#pragma mark - 改变
        [contentView addConstraint:[bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
    }
    // 约束button
    [bottomView addSubview:self.commentItBtn];
    {
        [bottomView addConstraints:[self.commentItBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12.0f, 45.0f, 12.0f, 45.0f)]];
    }
    
    // 约束webView
    [contentView addSubview:self.blogWebView];
    {
        // [contentView addConstraints:[self.blogWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
        [contentView addConstraint:[self.blogWebView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
        [contentView addConstraint:[self.blogWebView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [contentView addConstraint:[self.blogWebView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
        [contentView addConstraint:[self.blogWebView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:bottomView withOffset:0.0f]];
    }
    
    
}

- (void)setCommentsNumber:(NSInteger)number {
    
    if (number > 999) {
        
        [self.commentsBtn setTitle:@"评论999+" forState:UIControlStateNormal];
    }
    else {
        
        [self.commentsBtn setTitle:[NSString stringWithFormat:@"评论%ld", number] forState:UIControlStateNormal];
    }
}

#pragma mark - AddBlogCommentViewControllerDelegate Methods

- (void)addedComment:(Comment *)comment withBlog:(BlogItem *)blog {
    
    //Nothing
}

#pragma mark - selector

- (void)toBlogsCommentsViewController {
    
    BlogCommentsViewController *bvc = [[BlogCommentsViewController alloc] initWithBlog:self.blogItem];
    [self.navigationController pushViewController:bvc animated:YES];
}

- (void)toAddCommentViewController {
    
    AddBlogCommentViewController *acv = [[AddBlogCommentViewController alloc] initWithBlog:self.blogItem];
    acv.delegate = self;
    [self.navigationController pushViewController:acv animated:YES];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    //TODO 加载失败的处理方式
}


#pragma mark - property

- (UIWebView *)blogWebView {
    
    if (!_blogWebView) {
        
        _blogWebView = [[UIWebView alloc] init];
        _blogWebView.delegate = self;
        _blogWebView.scalesPageToFit = YES;
        _blogWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _blogWebView;
}

- (UIButton *)commentsBtn {
    
    if (!_commentsBtn) {
        
        _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentsBtn setBackgroundImage:[UIImage imageNamed:@"img_blog_comments_item" ] forState:UIControlStateNormal];
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

- (UIButton *)commentItBtn {
    
    if (!_commentItBtn) {
        
        _commentItBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentItBtn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        _commentItBtn.layer.borderWidth = 0.7f;
        _commentItBtn.layer.borderColor = [UIColorFromRGB(0xd6d6d6) CGColor];
        _commentItBtn.layer.cornerRadius = 3.0f;
        [_commentItBtn setTitle:@" 写评论" forState:UIControlStateNormal];
        [_commentItBtn setImage:[UIImage imageNamed:@"icon_edit_sth"] forState:UIControlStateNormal];
        [_commentItBtn setTitleColor:UIColorFromRGB(0x908f94) forState:UIControlStateNormal];
        [_commentItBtn addTarget:self action:@selector(toAddCommentViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commentItBtn;
}

@end
