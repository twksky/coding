//
//  DoctorBalanceViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorBalanceViewController.h"
#import "UIView+AutoLayout.h"
#import "DoctorBalanceHeaderView.h"
#import "ImageUtils.h"
#import "DoctorBalanceTransactionRecordCellTableViewCell.h"
#import "WithDrawalCashViewController.h"
#import "Payments.h"
#import "AccountManager.h"
#import <MJRefresh/MJRefresh.h>

#define RECORD_PAGE_COUNT 20

@interface DoctorBalanceViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DoctorBalanceHeaderView *headerView;

@property (nonatomic, strong) NSArray *paymentsRecord;

@end

@implementation DoctorBalanceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:self.headerView];
//    self.headerView.totalBalanceNumberLabel.text = @"280.00";
//    self.headerView.balanceNumberLabel.text = [NSString stringWithFormat:@"%.02f元", (CGFloat)([AccountManager sharedInstance].account.balance / 100.0f)];
    
    //AutoLayout
    {
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view]];
        [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view]];
    }
    
    // 上拉刷新
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNewsrell)];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    self.tableView.footer = refreshFooter;
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AccountManager sharedInstance] asyncGetPaymentsRecordWithPageIndex:1 size:RECORD_PAGE_COUNT CompletionHandler:^(NSArray *recordArray) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.paymentsRecord = recordArray;
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self showHint:[error localizedDescription]];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
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

#pragma mark - IBAction 

- (void)crashIt:(id)sender {
    
    NSLog(@"crashIt");
    
    WithDrawalCashViewController *wdv = [[WithDrawalCashViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:wdv animated:YES];
}

// 加载更多的交易记录
- (void)loadMoreNewsrell
{
    if (self.paymentsRecord.count % RECORD_PAGE_COUNT != 0 || self.paymentsRecord.count == 0) {
        [self.tableView.footer noticeNoMoreData];
        return;
    }
    
    NSInteger pageIndex = self.paymentsRecord.count / RECORD_PAGE_COUNT + 1;
    NSInteger pageSize = RECORD_PAGE_COUNT;
    
    [[AccountManager sharedInstance] asyncGetPaymentsRecordWithPageIndex:pageIndex size:pageSize CompletionHandler:^(NSArray *recordArray) {
        
        if (recordArray.count == 0) {
            [self.tableView.footer noticeNoMoreData];
            return ;
        }
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.paymentsRecord];
        [tempArray addObjectsFromArray:recordArray];
        self.paymentsRecord = tempArray;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
        
    }];
    
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.paymentsRecord count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *DoctorBalanceTransactionRecordCellTableViewCellReusedIdentifier = @"fba1e337-3354-44fe-afaa-6a8200246787";
    
    Payments *payments = [self.paymentsRecord objectAtIndex:indexPath.row];
    DoctorBalanceTransactionRecordCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DoctorBalanceTransactionRecordCellTableViewCellReusedIdentifier];
    if (!cell) {
        
        cell = [[DoctorBalanceTransactionRecordCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DoctorBalanceTransactionRecordCellTableViewCellReusedIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadDataWithPayments:payments];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *HeaderFooterViewIdentifier = @"62dedeb9-aac5-4c1e-974c-a3c004bc4cc0";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderFooterViewIdentifier];
    
    if (!headerView) {
        
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderFooterViewIdentifier];
        
        UIButton *cashBtn = [[SkinManager sharedInstance] createDefaultV3GreenButton];
        UILabel *tip = [[UILabel alloc] init];
        
        [cashBtn setTitle:@"提现" forState:UIControlStateNormal];
//        cashBtn.titleLabel.textColor = [UIColor whiteColor];
        cashBtn.titleLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        
//        UIImage *normalImg = [ImageUtils createImageWithColor:UIColorFromRGB(0x479cea)];
//        UIImage *selectedImg = [ImageUtils createImageWithColor:UIColorFromRGB(0x3a7ebc)];
        
//        [cashBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
//        [cashBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        
        
        cashBtn.layer.cornerRadius = 5.0f;
        cashBtn.layer.masksToBounds = YES;
        [cashBtn addTarget:self action:@selector(crashIt:) forControlEvents:UIControlEventTouchUpInside];
        
        tip.text = @"交易记录";
        tip.textColor = UIColorFromRGB(0x404040);
        tip.font = [UIFont systemFontOfSize:14.0f];
        
        [headerView addSubview:cashBtn];
        [headerView addSubview:tip];
        
        //AutoLayout
        {
            [headerView addConstraint:[cashBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f]];
            [headerView addConstraint:[cashBtn autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 30.0f]];
            [headerView addConstraint:[cashBtn autoSetDimension:ALDimensionHeight toSize:50.0f]];
            [headerView addConstraint:[cashBtn autoAlignAxisToSuperviewAxis:ALAxisVertical]];
            
            [headerView addConstraint:[tip autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:15.0f]];
            [headerView addConstraint:[tip autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headerView withOffset:-5.0f]];
        }
    }
    
    return headerView;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO 处理点击时间
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    self.headerView.balanceNumberLabel.text = [NSString stringWithFormat:@"%.02f元", (CGFloat)([AccountManager sharedInstance].account.balance / 100.0f)];
}


#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (DoctorBalanceHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[DoctorBalanceHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, App_Frame_Width, 151.0f);
    }
    
    return _headerView;
}

- (NSArray *)paymentsRecord {
    
    if (!_paymentsRecord) {
        
        _paymentsRecord = [[NSArray alloc] init];
    }
    
    return _paymentsRecord;
}

@end
