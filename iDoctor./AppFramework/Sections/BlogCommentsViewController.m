//
//  BlogCommentsViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/7/1.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BlogCommentsViewController.h"
#import "BlogItem.h"
#import <PureLayout.h>
#import <MJRefresh.h>
#import "AccountManager.h"
#import "BlogCommentCell.h"
#import "AddBlogCommentViewController.h"

#define BLOGS_COMMENTS_PAGE_SIZE 20

@interface BlogCommentsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
AddBlogCommentViewControllerDelegate
>

@property (nonatomic, strong) UITableView *commentsTableView;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) BlogItem *blog;
@property (nonatomic, strong) UIButton *commentItBtn;

@end

@implementation BlogCommentsViewController

- (instancetype)initWithBlog:(BlogItem *)blog {
    
    self = [super init];
    if (self) {
        
        self.blog = blog;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setNavigationBarWithTitle:@"评论" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self setupViews];
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    self.commentsTableView.footer = refreshFooter;
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetBlogCommentsWithBlogId:self.blog.blogId withPage:1 withSize:20 withCompletionHandler:^(NSArray *comments) {
        [self dismissLoading];
        
        self.comments = comments;
        [self.commentsTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - private methods

- (void)setupViews {
    
    UIView *contentView = self.view;
//    [contentView addSubview:self.commentsTableView];
//    {
//        [contentView addConstraints:[self.commentsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
//    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [contentView addSubview:bottomView];
    {
        [contentView addConstraints:[bottomView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 60.0f)]];
        [contentView addConstraint:[bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
#pragma mark - 修改
        [contentView addConstraint:[bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
    }
    
    [bottomView addSubview:self.commentItBtn];
    {
        [bottomView addConstraints:[self.commentItBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12.0f, 45.0f, 12.0f, 45.0f)]];
    }
    
    [contentView addSubview:self.commentsTableView];
    {
        // [contentView addConstraints:[self.blogWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
        [contentView addConstraint:[self.commentsTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
        [contentView addConstraint:[self.commentsTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [contentView addConstraint:[self.commentsTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
        [contentView addConstraint:[self.commentsTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:bottomView withOffset:0.0f]];
    }
    
}

#pragma mark - selector

- (void)loadMoreComments {
    
    if (self.comments.count % BLOGS_COMMENTS_PAGE_SIZE != 0 || self.comments.count == 0) {
        
        [self.commentsTableView.footer noticeNoMoreData];
        return;
    }
    
    NSInteger page = self.comments.count / BLOGS_COMMENTS_PAGE_SIZE + 1;
    NSInteger size = BLOGS_COMMENTS_PAGE_SIZE;
    
    [[AccountManager sharedInstance] asyncGetBlogCommentsWithBlogId:self.blog.blogId withPage:page withSize:size withCompletionHandler:^(NSArray *comments) {
        
        NSMutableArray *temArray = [[NSMutableArray alloc] initWithArray:self.comments];
        [temArray addObjectsFromArray:comments];
        self.comments = temArray;
        
        [self.commentsTableView reloadData];
        [self.commentsTableView.footer endRefreshing];
        
    } withErrorHandler:^(NSError *error) {
        
        [self.commentsTableView.footer endRefreshing];
        [self showHint:[error localizedDescription]];
    }];
}

- (void)toAddCommentViewController {
    
    AddBlogCommentViewController *acv = [[AddBlogCommentViewController alloc] initWithBlog:self.blog];
    acv.delegate = self;
    [self.navigationController pushViewController:acv animated:YES];
}


#pragma mark - AddBlogCommentViewControllerDelegate Methods

- (void)addedComment:(Comment *)comment withBlog:(BlogItem *)blog {
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:self.comments];
    [tmpArray insertObject:comment atIndex:0];
    if (self.comments.count != 0 && self.comments.count % BLOGS_COMMENTS_PAGE_SIZE == 0) {
        
        [tmpArray removeObjectAtIndex:self.comments.count];
    }
    self.comments = tmpArray;
    
    [self.commentsTableView reloadData];
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *BlogCommentCellReusedIdentifier = @"8d9de94f-7dfd-47d1-9d70-277b2c20cd3f";
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BlogCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:BlogCommentCellReusedIdentifier];
    if (!cell) {
        
        cell = [[BlogCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BlogCommentCellReusedIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadDataWithComment:comment];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    return [BlogCommentCell cellHeightWithComment:comment];
}


#pragma mark - properties

- (UITableView *)commentsTableView {
    
    if (!_commentsTableView) {
        
        _commentsTableView = [[UITableView alloc] init];
        _commentsTableView.delegate = self;
        _commentsTableView.dataSource = self;
        
        _commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _commentsTableView;
}

- (NSArray *)comments {
    
    if (!_comments) {
        
        _comments = [[NSArray alloc] init];
    }
    
    return _comments;
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
