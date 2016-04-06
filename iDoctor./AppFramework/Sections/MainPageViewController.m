//
//  MainPageViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/8.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MainPageViewController.h"
#import "UIView+AutoLayout.h"
#import "MyCardCellTableViewCell.h"
#import "MyWorkTitleCell.h"
#import "MyWorkTitleItemCell.h"
#import "DFDUrgentCallController.h"
#import "BlogCell.h"
#import "BlogItem.h"
#import "AccountManager.h"
#import "BlogDetailViewController.h"
#import "SkinManager.h"
#import "QrInfoView.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#import <IChatManager.h>

#define BLOG_PAGE_COUNT 10

//TODO test
#import "GiftViewController.h"
#import "TipView.h"

@interface MainPageViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *myWorkItemTitles;
@property (nonatomic, strong) NSArray *myWorkItemIcons;
@property (nonatomic, strong) NSArray *myWorkMsgs;
@property (nonatomic, strong) NSArray *blogs;
@property (nonatomic, strong) NSDictionary *dashInfo;

@end

@implementation MainPageViewController

static NSInteger SectionMyCard = 0;
static NSInteger SectionMyWork = 1;
static NSInteger SectionBlog = 2;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.tabBarItem.title = @"首页";
        
        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultMainPageTabBarNormalIcon];
        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultMainPageTabBarHighlightedIcon];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //TODO 添加按钮事件
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(to)];
    
    [super setNavigationBarWithTitle:@"首页" leftBarButtonItem:nil rightBarButtonItem:nil];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBlogs)];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    self.tableView.footer = refreshFooter;
    
    {
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view]];
    }
    
    NSInteger page = 1;
    NSInteger size = BLOG_PAGE_COUNT;
    
    [[AccountManager sharedInstance] asyncGetBlogsWithPage:page withSize:size withCompletionHandler:^(NSArray *blogs)
    {
        self.blogs = blogs;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:YES];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[AccountManager sharedInstance] asyncDashInfoWithCompletionHandler:^(NSDictionary *dashInfo) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:dashInfo];;
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        NSInteger unreadCount = [chatManager totalUnreadMessagesCount];
        [dic setValue:@(unreadCount) forKey:@"unread_count"];
        
        self.dashInfo = dic;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:NO];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - private methods

- (void)showQrCodeController {
    
    QrInfoView *infoView = [[QrInfoView alloc] init];
    [infoView loadDataWithAccount:[AccountManager sharedInstance].account];
    infoView.frame = CGRectMake(0, 0, App_Frame_Width, Main_Screen_Height);
    
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:infoView];
}

- (void)loadMoreBlogs {
    
    if (self.blogs.count % BLOG_PAGE_COUNT != 0) {
        
        [self.tableView.footer noticeNoMoreData];
        return;
    }
    
    NSInteger page = self.blogs.count / BLOG_PAGE_COUNT + 1;
    NSInteger size = BLOG_PAGE_COUNT;
    
    [[AccountManager sharedInstance] asyncGetBlogsWithPage:page withSize:size withCompletionHandler:^(NSArray *blogs) {
        
        NSMutableArray *temArray = [[NSMutableArray alloc] initWithArray:self.blogs];
        [temArray addObjectsFromArray:blogs];
        self.blogs = temArray;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:NO];
        [self.tableView.footer endRefreshing];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    
    return _tableView;
}

- (NSArray *)myWorkItemTitles {
    
    if (!_myWorkItemTitles) {
        
        _myWorkItemTitles = [[NSArray alloc] initWithObjects:@"紧急回呼", @"患者对话", @"附近提问", nil];
    }
    
    return _myWorkItemTitles;
}

- (NSArray *)myWorkItemIcons {
    
    if (!_myWorkItemIcons) {
        
        _myWorkItemIcons = [[NSArray alloc] initWithObjects:@"icon_mainpage_call", @"icon_mainpage_msg", @"icon_mainpage_ask", nil];
    }
    
    return _myWorkItemIcons;
}

- (NSArray *)myWorkMsgs {
    
    if (!_myWorkMsgs) {
        
        _myWorkMsgs = [[NSArray alloc] initWithObjects:@"有%d条未回复", @"有%d人消息未读", @"有%d条未回答",nil];
    }
    
    return _myWorkMsgs;
}

- (NSArray *)blogs {
    
    if (!_blogs) {
        
        _blogs = [[NSArray alloc] init];
    }
    
    return _blogs;
}

- (NSDictionary *)dashInfo {
    
    if (!_dashInfo) {
        
        _dashInfo = [[NSDictionary alloc] init];
    }
    
    return _dashInfo;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (SectionMyCard == section) {
        
        return 1;
    }
    else if (SectionMyWork == section) {
        
        return 4;
    }
    if (SectionBlog == section) {
        
        return 1 + self.blogs.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (SectionMyCard == indexPath.section) {
        
        MyCardCellTableViewCell *myCardCell = [[MyCardCellTableViewCell alloc] init];
        [myCardCell.barCodeImageView sd_setImageWithURL:[NSURL URLWithString:[AccountManager sharedInstance].account.qCodeImageUrlString] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
        cell = myCardCell;
    }
    else if (SectionMyWork == indexPath.section){
        
        if (0 == indexPath.row) {
            
            MyWorkTitleCell *myWorkTitlecell = [[MyWorkTitleCell alloc] init];
            [myWorkTitlecell.titleImageView setImage:[UIImage imageNamed:@"icon_mywork"]];
            myWorkTitlecell.titleLabel.text = @"我的工作";
            [myWorkTitlecell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell = myWorkTitlecell;
        }
        else {
            
            NSString *key;
            switch (indexPath.row - 1) {
                case 0:
                    key = @"urgency_call_count";
                    break;
                case 1:
                    key = @"unread_count";
                    break;
                case 2:
                    key = @"quickly_ask_count";
                    break;
                default:
                    break;
            }
            
            NSInteger number = [[self.dashInfo objectForKey:key] integerValue];
            
            MyWorkTitleItemCell *itemCell = [[MyWorkTitleItemCell alloc] init];
            itemCell.workItemTitle.text = [self.myWorkItemTitles objectAtIndex:indexPath.row - 1];
            [itemCell.workItemIcon setImage:[UIImage imageNamed: [self.myWorkItemIcons objectAtIndex:indexPath.row - 1]]];
            itemCell.workItemMsg.text = [NSString stringWithFormat:[self.myWorkMsgs objectAtIndex:indexPath.row - 1], number];
            itemCell.tipView.tipNumberLabel.text = [NSString stringWithFormat:@"%ld", number];
            [itemCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell = itemCell;
        }
    }
    else if (SectionBlog == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            MyWorkTitleCell *myWorkTitlecell = [[MyWorkTitleCell alloc] init];
            [myWorkTitlecell.titleImageView setImage:[UIImage imageNamed:@"icon_mymedicine"]];
            myWorkTitlecell.titleLabel.text = @"医学播报";
            [myWorkTitlecell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell = myWorkTitlecell;
        }
        else {
            
            BlogCell *blogCell = [[BlogCell alloc] init];
            BlogItem *blogItem = [self.blogs objectAtIndex:indexPath.row - 1];
            
            [blogCell loadBlog:blogItem];
            
            cell = blogCell;
        }
    }

    
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (SectionMyCard == indexPath.section) {
        
        return 100;
    }
    else if (SectionMyWork == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            return 45;
        }
        else {
            
            return 60;
        }
    }
    else if (SectionBlog == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            return 45;
        }
        else {
            
            return 90;
        }
    }
    
    return 0;
}

//TODO
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (SectionMyCard != section) {
        
        return 15;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (SectionMyCard == indexPath.section) {
        
        [self showQrCodeController];
    }
    else if (SectionMyWork == indexPath.section) {
        
        if (1 == indexPath.row) {
            
            DFDUrgentCallController *dcc = [[DFDUrgentCallController alloc] init];
            [self.navigationController pushViewController:dcc animated:YES];
        }
        else if (2 == indexPath.row) {
            
            [self.tabBarController setSelectedIndex:2];
        }
        else if (3 == indexPath.row) {
            
            [self.tabBarController setSelectedIndex:1];
        }
        
    }
    else if (SectionBlog == indexPath.section && indexPath.row > 0) {
        
        BlogItem *blogItem = [self.blogs objectAtIndex:indexPath.row - 1];
        
        BlogDetailViewController *bgv = [[BlogDetailViewController alloc] initWithBlogItem:blogItem];
        [self.navigationController pushViewController:bgv animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
