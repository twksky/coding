//
//  DoctorCreditViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorCreditViewController.h"
#import <PureLayout.h>
#import "DoctorCreditHeaderView.h"
#import "DoctorBalanceTransactionScoreCell.h"
#import "AccountManager.h"
#import "ScoreModel.h"
#import "SkinManager.h"
#import "DoctorCreditShopViewController.h"
#import "WebShowViewController.h"
#import <MJRefresh/MJRefresh.h>

#define SCROE_PAGE_COUNT 20

@interface DoctorCreditViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DoctorCreditHeaderView *headerView;

@property (nonatomic, strong) NSArray *scoreRecord;

@end

@implementation DoctorCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:self.headerView];
    [self.headerView setSpendCreditButtonAction:@selector(toCreditShopViewController:) withTarget:self];
    [self.headerView setEarnCreditButtonAction:@selector(toEarnCreditWebViewController:) withTarget:self];
    
    //AutoLayout
    {
        [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 上拉刷新
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreScroe)];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    self.tableView.footer = refreshFooter;
    
    [[AccountManager sharedInstance] asyncGetScoreListWithPageIndex:1 pageSize:SCROE_PAGE_COUNT CompletionHandler:^(NSArray *scoreModels) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.scoreRecord = scoreModels;
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self showHint:[error localizedDescription]];
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateHeaderView];
    
    [[AccountManager sharedInstance] asyncUpdateAccountWithCompletionHandler:^(Account *account) {
        
        [AccountManager sharedInstance].account.balance = account.balance;
        [AccountManager sharedInstance].account.score = account.score;
        
        [self updateHeaderView];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - selectors

// 上拉加载更多的积分数据
- (void)loadMoreScroe
{
    if (self.scoreRecord.count % SCROE_PAGE_COUNT != 0 || self.scoreRecord.count == 0) {
        
        [self.tableView.footer noticeNoMoreData];
        
        return ;
        
    }
    
    NSInteger pageIndex = self.scoreRecord.count / 20 + 1;
    NSInteger pageSize = SCROE_PAGE_COUNT;
    
    [[AccountManager sharedInstance] asyncGetScoreListWithPageIndex:pageIndex pageSize:pageSize CompletionHandler:^(NSArray *scoreModels) {
        
        if (scoreModels.count == 0) {
            [self.tableView.footer noticeNoMoreData];
            return ;
        }
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.scoreRecord];
        [tempArray addObjectsFromArray:scoreModels];
        
        self.scoreRecord = tempArray;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
          [self.tableView.footer endRefreshing];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
        
    }];
    
    
}

- (void)toCreditShopViewController:(id)sender {
    
    DoctorCreditShopViewController *creditShopViewController = [[DoctorCreditShopViewController alloc] init];
    [self.navigationController pushViewController:creditShopViewController animated:YES];
}

- (void)toEarnCreditWebViewController:(id)sender {
    
    WebShowViewController *wvc = [[WebShowViewController alloc] initWithUrl:@"http://www.ihaoyisheng.com/w/score/rules/"];
    [self.navigationController pushViewController:wvc animated:YES];
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.scoreRecord count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *DoctorScoreRecordCellTableViewCellReusedIdentifier = @"7e5da666-c9a2-49d6-85ca-39914441f1c6";
    
    ScoreModel *score = [self.scoreRecord objectAtIndex:indexPath.row];
    
    DoctorBalanceTransactionScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:DoctorScoreRecordCellTableViewCellReusedIdentifier];
    if (!cell) {
        
        cell = [[DoctorBalanceTransactionScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DoctorScoreRecordCellTableViewCellReusedIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadDataWithScoreModel:score];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *HeaderFooterViewIdentifier = @"76b33da2-839f-4a29-b4bb-c6e805fcf211";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderFooterViewIdentifier];
    
    if (!headerView) {
        
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderFooterViewIdentifier];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tip = [[UILabel alloc] init];
        tip.text = @"积分详情";
        tip.textColor = UIColorFromRGB(0x000000);
        tip.font = [UIFont boldSystemFontOfSize:18.0f];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
        
        [headerView addSubview:tip];
        [headerView addSubview:line];
        
        //AutoLayout
        {
            [headerView addConstraint:[tip autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
//            [headerView addConstraint:[tip autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f]];
            [headerView addConstraint:[tip autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
            
            [headerView addConstraints:[line autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
            [headerView addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
            [headerView addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        }
    }
    
    return headerView;
}


#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 66;
}

#pragma mark - private methods

- (void)showHint:(NSString *)hint {
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)updateHeaderView {
    
    self.headerView.creditNumberLabel.text = [NSString stringWithFormat:@"%ld", [AccountManager sharedInstance].account.score];
}


#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (DoctorCreditHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[DoctorCreditHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, App_Frame_Width, 200.0f);
    }
    
    return _headerView;
}

- (NSArray *)scoreRecord {
    
    if (!_scoreRecord) {
        
        _scoreRecord = [[NSArray alloc] init];
    }
    
    return _scoreRecord;
}

@end








