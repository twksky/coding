//
//  AddBlogCommentViewController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "AddBlogCommentViewController.h"
#import "HomeInfoModel.h"
#import "HomeManager.h"
#import <UITextView+Placeholder.h>
#import "HomeInfoViewController.h"


@interface AddBlogCommentViewController ()

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) HomeInfoModel *blog;

@end

@implementation AddBlogCommentViewController

- (instancetype)initWithBlog:(HomeInfoModel *)blog {
    
    self = [super init];
    if (self) {
        
        self.blog = blog;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(saveComment)];
    
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    [self setupViews];
}

//- (void)loadView {
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
////    [super loadView];
//}

#pragma mark - private methods

- (void)setupViews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Height)];
    [self.view addSubview:scrollView];
    
    self.commentTextView.frame = CGRectMake(0, 0, App_Frame_Width, App_Frame_Height);
    [scrollView addSubview:self.commentTextView];
}

#pragma mark - selector

- (void)saveComment {
    
    if ([self.commentTextView.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self showLoading];
//    [[AccountManager sharedInstance] asyncSaveBlogCommentWithBlogId:self.blog.blogId withCommentDesc:self.commentTextView.text withCompletionHandler:^(Comment *comment) {
//        [self dismissLoading];
//        
//        self.blog.commentCount++;
//        [self showHint:@"发表评论成功"];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(addedComment:withBlog:)]) {
//            
//            [self.delegate addedComment:comment withBlog:self.blog];
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    } withErrorHandler:^(NSError *error) {
//        [self dismissLoading];
//        
//        [self showHint:[error localizedDescription]];
//    }];
    [[HomeManager sharedInstance] postCommentWithModel:self.blog withDescription:self.commentTextView.text withCompletionHandelr:^(Comment *comment) {
        [self dismissLoading];
        [self showTips:@"发表评论成功"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(addedComment:withBlog:)]) {
            [self.delegate addedComment:comment withBlog:self.blog];
        }
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HomeInfoViewController class]]) {
                (((HomeInfoViewController*)controller).blogItem.comments_count)++;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        [self handleError:error];
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
