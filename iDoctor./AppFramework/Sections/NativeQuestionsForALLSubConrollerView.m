//
//  NativeQuestionsForALLSubConrollerView.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/15.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionsForALLSubConrollerView.h"
#import <PureLayout.h>
#import <MBProgressHUD.h>
#import "AccountManager.h"
#import "QuickQuestion.h"
#import "DFDQuickQuestionDetailViewController.h"
#import "NativeQuestionCellTableViewCell.h"
#import <MJRefresh.h>
#import "ContactInfoViewController.h"

#define PAGE_COUNT 20

@interface NativeQuestionsForALLSubConrollerView ()
<
UITableViewDelegate,
UITableViewDataSource,
NativeQuestionCellTableViewCellDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *nativeQuestions;

@property (nonatomic, strong) NSString *currentOfficeType;

@end

@implementation NativeQuestionsForALLSubConrollerView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    self.tableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateNativeQuestions)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer = refreshFooter;
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    [self.tableView.header beginRefreshing];
}

#pragma mark - NativeQuestionsListPort Methods

- (void)updateListWithQuestion:(QuickQuestion *)question Comment:(Comment *)comment {
    
    for (QuickQuestion *nativeQuestion in self.nativeQuestions) {
        
        if (nativeQuestion.questionID == question.questionID) {
            
            nativeQuestion.comments = question.comments;
            nativeQuestion.commentsCount = question.commentsCount;
            [self.tableView reloadData];
            break;
        }
    }
}

//这里的分页处理很搓, 这个有时间得改
- (void)officeTypeChanged:(NSString *)officeType {
    
    if (!officeType || [self.currentOfficeType isEqualToString:officeType]) { return; }
    
    self.currentOfficeType = officeType;
    self.nativeQuestions = [[NSArray alloc] init];
    [self.tableView reloadData];
    
    [self.tableView.header beginRefreshing];
}

#pragma mark - private Methods

- (void)updateNativeQuestions {
    
    NSInteger page = 1;
    NSInteger size = self.nativeQuestions.count == 0 ? PAGE_COUNT : self.nativeQuestions.count;
    [[AccountManager sharedInstance] asyncGetQuickQuestionListWithPage:page size:size department:self.currentOfficeType CompletionHandler:^(NSArray *quickQuestionList) {
        
        //TODO 需要做很多事
        self.nativeQuestions = quickQuestionList;
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } withErrorHandler:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    if (self.nativeQuestions.count % PAGE_COUNT != 0) {
        
        [self.tableView.footer noticeNoMoreData];
        return;
    }
    
    NSInteger page = self.nativeQuestions.count / PAGE_COUNT + 1;
    NSInteger size = PAGE_COUNT;
    [[AccountManager sharedInstance] asyncGetQuickQuestionListWithPage:page size:size department:nil CompletionHandler:^(NSArray *quickQuestionList) {
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:self.nativeQuestions];
        [tmpArray addObjectsFromArray:quickQuestionList];
        
        self.nativeQuestions = tmpArray;
        
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
        if (quickQuestionList.count != PAGE_COUNT) {
            
            [self.tableView.footer noticeNoMoreData];
        }
        
    } withErrorHandler:^(NSError *error) {
        
        //TODO 处理网络错误
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuickQuestion *question = [self.nativeQuestions objectAtIndex:indexPath.row];
    DFDQuickQuestionDetailViewController *questionDetailViewController = [[DFDQuickQuestionDetailViewController alloc] init];
    NativeQuestionsViewController *nvc = (NativeQuestionsViewController *)self.parentViewController;
    questionDetailViewController.delegate = nvc; 
    questionDetailViewController.quickQuestion = question;
    [self.parentViewController.navigationController pushViewController:questionDetailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 150.0f;
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.nativeQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *NativeQuestionCellTableViewCellReusedIdentifier = @"b94283ac-67e2-4c9d-a85b-2445bc500e4f";
    
    QuickQuestion *question = [self.nativeQuestions objectAtIndex:indexPath.row];
    
    NativeQuestionCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NativeQuestionCellTableViewCellReusedIdentifier];
    if (!cell) {
        
        cell = [[NativeQuestionCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NativeQuestionCellTableViewCellReusedIdentifier];
        cell.delegate = self;
    }
    
    [cell loadData:question];
 
    return cell;
}

#pragma mark - NativeQuestionCellTableViewCellDelegate Methods

- (void)iconUserImageClickedWithPatient:(Patient *)patient {
    
    ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
    [self.navigationController pushViewController:infoViewController animated:YES];
}


#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSArray *)nativeQuestions {
    
    if (!_nativeQuestions) {
        
        _nativeQuestions = [[NSArray alloc] init];
    }
    
    return _nativeQuestions;
}

- (NSString *)currentOfficeType {
    
    if (!_currentOfficeType) {
        
        _currentOfficeType = @"全部";
    }
    
    return _currentOfficeType;
}

@end
