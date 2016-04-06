//
//  WithdrawalViewControllerStep1.m
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "WithdrawalViewControllerStep1.h"
#import "UIView+AutoLayout.h"
#import "SkinManager.h"
#import "EXUILabel.h"
#import "WithdrawalViewControllerStep2.h"

@interface WithdrawalViewControllerStep1 () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

// Selector
- (void)nextButtonClicked:(id)sender;

@end

@implementation WithdrawalViewControllerStep1

enum WithdrawalStyle
{
    WS_Card = 0,
    WS_Alipay,
    WS_UnionPay
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    self.title = @"提现";
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Property

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"DE396897-2682-4963-82C3-6847C612C05A";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusableCellIdentifier];
    }
    if (WS_Card == [indexPath row]) {
        [cell.imageView setImage:[UIImage imageNamed:@"icon_card.png"]];
        [cell.textLabel setText:@"银行卡提现"];
        [cell.detailTextLabel setText:@"支持储蓄卡、信用卡，无需开通网银"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pay_unchecked.png"]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *reusableHeaderIdentifier = @"5AB500A3-9FCB-4A7E-A91C-BF860A194211";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableHeaderIdentifier];
    if (!headerView) {
        EXUILabel *headerLabel = [[EXUILabel alloc] init];
        headerLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        headerLabel.font = [UIFont systemFontOfSize:14.0f];
        headerLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
        [headerLabel setText:@"请选择提现方式"];
        headerView = headerLabel;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *reusableFooterIdentifier = @"D059A2A4-5589-4D41-810D-12EA349393E2";
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableFooterIdentifier];
    if (!footerView) {
        UIView *containerView = [[UIView alloc] init];
        UIButton *nextButton = [[SkinManager sharedInstance] createDefaultButton];
        nextButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [nextButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setTitle:@"确认提现" forState:UIControlStateNormal];
        [containerView addSubview:nextButton];
        {
            // Autolayout
            [containerView addConstraint:[nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:containerView withOffset:10.0f]];
            [containerView addConstraint:[nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:containerView withOffset:15.0f]];
            [containerView addConstraint:[nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:containerView withOffset:-10.0f]];
            [containerView addConstraint:[nextButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:containerView withOffset:0.0f]];
        }
        footerView = containerView;
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pay_checked.png"]];
}


#pragma mark - Selector

- (void)nextButtonClicked:(id)sender
{
    WithdrawalViewControllerStep2 *withdrawalVCStep2 = [[WithdrawalViewControllerStep2 alloc] init];
    [self.navigationController pushViewController:withdrawalVCStep2 animated:YES];
}

@end
