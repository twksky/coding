//
//  AddBlogCommentViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/7/2.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "AddBlogCommentViewController.h"
#import <PureLayout.h>
#import <UITextView+Placeholder.h>
#import "AccountManager.h"
#import "BlogItem.h"

@interface AddBlogCommentViewController ()

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) BlogItem *blog;

@end

@implementation AddBlogCommentViewController

- (instancetype)initWithBlog:(BlogItem *)blog {
    
    self = [super init];
    if (self) {
        
        self.blog = blog;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(saveComment)];
    
    [self setNavigationBarWithTitle:@"评论" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:barButtonItem];
    
    [self setupViews];
}

#pragma mark - private methods

- (void)setupViews {
    
    [self.view addSubview:self.commentTextView];
    {
        [self.view addConstraints:[self.commentTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    }
}

#pragma mark - selector

- (void)saveComment {
    
    if ([self.commentTextView.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncSaveBlogCommentWithBlogId:self.blog.blogId withCommentDesc:self.commentTextView.text withCompletionHandler:^(Comment *comment) {
        [self dismissLoading];
        
        self.blog.commentCount++;
        [self showHint:@"发表评论成功"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(addedComment:withBlog:)]) {
            
            [self.delegate addedComment:comment withBlog:self.blog];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
    
}

#pragma mark - properties

- (UITextView *)commentTextView {
    
    if (!_commentTextView) {
        
        _commentTextView = [[UITextView alloc] init];
        _commentTextView.placeholder = @"写评论";
        _commentTextView.font = [UIFont systemFontOfSize:19.0f];
    }
    
    return _commentTextView;
}

@end
