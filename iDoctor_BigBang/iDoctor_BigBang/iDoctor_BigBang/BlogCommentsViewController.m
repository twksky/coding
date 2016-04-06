//
//  BlogCommentsViewController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "BlogCommentsViewController.h"
#import "HomeInfoModel.h"
#import "BlogCommentCell.h"
#import "HomeManager.h"
#import "AddBlogCommentViewController.h"

#define BLOGS_COMMENTS_PAGE_SIZE 20

@interface BlogCommentsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
,AddBlogCommentViewControllerDelegate
>

@property (nonatomic, strong) UITableView *commentsTableView;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) HomeInfoModel *blog;
@property (nonatomic, strong) UIButton *commentItBtn;

@end

@implementation BlogCommentsViewController

- (instancetype)initWithBlog:(HomeInfoModel *)blog {
    
    self = [super init];
    if (self) {
        
        self.blog = blog;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"评论";
//    [self setNavigationBarWithTitle:@"评论" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self setupViews];
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    self.commentsTableView.footer = refreshFooter;

    [self getData];
    
}

-(void)getData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[AccountManager sharedInstance] asyncGetBlogCommentsWithBlogId:self.blog.blogId withPage:1 withSize:20 withCompletionHandler:^(NSArray *comments) {
//            [self dismissLoading];
//    
//            self.comments = comments;
//            [self.commentsTableView reloadData];
//    
//        } withErrorHandler:^(NSError *error) {
//            [self dismissLoading];
//    
//            [self showHint:[error localizedDescription]];
//        }];
    HomeManager *manager = [HomeManager sharedInstance];
    [manager getHomeInfoCommentWithModel:self.blog withCompletionHandelr:^(NSArray *arr) {
//        NSLog(@"%@",arr);
        self.comments = arr;
        [self.commentsTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withErrorHandler:^(NSError *error) {
        [self showTips:error.description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - private methods

- (void)setupViews {
    
//    UIView *contentView = self.view;
    //    [contentView addSubview:self.commentsTableView];
    //    {
    //        [contentView addConstraints:[self.commentsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    //    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
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
     
     [self.view addSubview:self.commentsTableView];
     [self.commentsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.top).offset(0);
    }];
     
}

#pragma mark - selector

- (void)loadMoreComments {
    
    if (self.comments.count % BLOGS_COMMENTS_PAGE_SIZE != 0 || self.comments.count == 0) {
        
        [self.commentsTableView.footer noticeNoMoreData];
        return;
    }
    
    NSInteger page = self.comments.count / BLOGS_COMMENTS_PAGE_SIZE + 1;
    NSInteger size = BLOGS_COMMENTS_PAGE_SIZE;
    
//    [[AccountManager sharedInstance] asyncGetBlogCommentsWithBlogId:self.blog.h_id withPage:page withSize:size withCompletionHandler:^(NSArray *comments) {
//        
//        NSMutableArray *temArray = [[NSMutableArray alloc] initWithArray:self.comments];
//        [temArray addObjectsFromArray:comments];
//        self.comments = temArray;
//        
//        [self.commentsTableView reloadData];
//        [self.commentsTableView.footer endRefreshing];
//        
//    } withErrorHandler:^(NSError *error) {
//        
//        [self.commentsTableView.footer endRefreshing];
//        [self showHint:[error localizedDescription]];
//    }];
}

- (void)toAddCommentViewController {
    
    AddBlogCommentViewController *acv = [[AddBlogCommentViewController alloc] initWithBlog:self.blog];
    acv.delegate = self;
    [self.navigationController pushViewController:acv animated:YES];
    
}


#pragma mark - AddBlogCommentViewControllerDelegate Methods

- (void)addedComment:(Comment *)comment withBlog:(HomeInfoModel *)blog {
    
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
