//
//  GiftViewController.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "GiftViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "EXUILabel.h"
#import "UIView+AutoLayout.h"
#import "WithdrawalViewControllerStep2.h"
#import "AccountManager.h"
#import "ContactManager.h"

@interface GiftViewController () <UITableViewDataSource, UITableViewDelegate>
{
}

@property (nonatomic, strong) EXUILabel         *balanceLabel;
@property (nonatomic, strong) UIView            *horizontalLineA;
@property (nonatomic, strong) UIButton          *withdrawalsButton;
@property (nonatomic, strong) UIView            *horizontalLineB;
@property (nonatomic, strong) EXUILabel         *giftRecordLabel;
@property (nonatomic, strong) UITableView       *giftRecordTableView;

@property (nonatomic, strong) NSMutableArray    *giftArray;
@property (nonatomic, strong) NSMutableArray    *paymentsArray;
@property (nonatomic, assign) NSInteger         pageIndex;
@property (nonatomic, assign) BOOL              isLoadingPayment;

- (void)setupSubviews;
- (void)setupConstraints;
- (NSAttributedString *)formatBalanceWithBalance:(CGFloat)balance;

// Selector
- (void)withdrawalsButtonClicked:(id)sender;

@end

@implementation GiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"我的账户";
        self.pageIndex = 0;
        self.isLoadingPayment = NO;
        //self.tabBarItem.badgeValue = @"10";
        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultGiftTabBarNormalIcon];
        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultGiftTabBarHighlightedIcon];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //[self.view setFrame:CGRectMake(0.0f, App_Frame_Y + self.navigationBarHeight, App_Frame_Width, App_Frame_Height - self.navigationBarHeight - kTabBarHeight)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AccountManager sharedInstance] asyncGetBalanceWithCompletionHandler:^(long balance) {
        [self.balanceLabel setAttributedText:[self formatBalanceWithBalance:balance]];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
    self.pageIndex = 0;
    [[AccountManager sharedInstance] asyncGetPaymentsRecordWithPageIndex:self.pageIndex withCompletionHandler:^(NSArray *recordArray) {
        [self.paymentsArray removeAllObjects];
        [self.paymentsArray addObjectsFromArray:recordArray];
        [self.giftRecordTableView reloadData];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (EXUILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[EXUILabel alloc] init];
        _balanceLabel.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _balanceLabel.textEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
    }
    return _balanceLabel;
}

- (UIView *)horizontalLineA
{
    if (!_horizontalLineA) {
        _horizontalLineA = [[UIView alloc] init];
        _horizontalLineA.backgroundColor = UIColorFromRGB(0xd4d5d7);
    }
    return _horizontalLineA;
}

- (UIButton *)withdrawalsButton
{
    if (!_withdrawalsButton) {
        _withdrawalsButton = [[SkinManager sharedInstance] createDefaultButton];
        _withdrawalsButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _withdrawalsButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 15.0f);
        _withdrawalsButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [_withdrawalsButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_withdrawalsButton setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawalsButton addTarget:self action:@selector(withdrawalsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawalsButton;
}

- (UIView *)horizontalLineB
{
    if (!_horizontalLineB) {
        _horizontalLineB = [[UIView alloc] init];
        _horizontalLineB.backgroundColor = UIColorFromRGB(0xd4d5d7);
    }
    return _horizontalLineB;
}

- (EXUILabel *)giftRecordLabel
{
    if (!_giftRecordLabel) {
        _giftRecordLabel = [[EXUILabel alloc] init];
        _giftRecordLabel.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _giftRecordLabel.textAlignment = NSTextAlignmentCenter;
        [_giftRecordLabel setText:@"我的收花记录"];
    }
    return _giftRecordLabel;
}

- (UITableView *)giftRecordTableView
{
    if (!_giftRecordTableView) {
        _giftRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 0.0f)];
        _giftRecordTableView.dataSource = self;
        _giftRecordTableView.delegate = self;
        
        _giftRecordTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 165.0f)];
        [_giftRecordTableView.tableHeaderView addSubview:self.balanceLabel];
        [_giftRecordTableView.tableHeaderView addSubview:self.horizontalLineA];
        [_giftRecordTableView.tableHeaderView addSubview:self.withdrawalsButton];
        [_giftRecordTableView.tableHeaderView addSubview:self.horizontalLineB];
        [_giftRecordTableView.tableHeaderView addSubview:self.giftRecordLabel];
        {
            UIView *tableHeaderView = _giftRecordTableView.tableHeaderView;
            
            [tableHeaderView addConstraint:[self.balanceLabel autoSetDimension:ALDimensionHeight toSize:65.0f]];
            [tableHeaderView addConstraint:[self.balanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:tableHeaderView withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.balanceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:tableHeaderView withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.balanceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:tableHeaderView withOffset:0.0f]];
            
            [tableHeaderView addConstraint:[self.horizontalLineA autoSetDimension:ALDimensionHeight toSize:0.5f]];
            [tableHeaderView addConstraint:[self.horizontalLineA autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:tableHeaderView withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.horizontalLineA autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.balanceLabel withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.horizontalLineA autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:tableHeaderView withOffset:0.0f]];
            
            [tableHeaderView addConstraint:[self.withdrawalsButton autoSetDimension:ALDimensionHeight toSize:37.0f]];
            [tableHeaderView addConstraint:[self.withdrawalsButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:tableHeaderView withOffset:20.0f]];
            [tableHeaderView addConstraint:[self.withdrawalsButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.horizontalLineA withOffset:14.5f]];
            [tableHeaderView addConstraint:[self.withdrawalsButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:tableHeaderView withOffset:-20.0f]];
            
            [tableHeaderView addConstraint:[self.horizontalLineB autoSetDimension:ALDimensionHeight toSize:0.5f]];
            [tableHeaderView addConstraint:[self.horizontalLineB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:tableHeaderView withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.horizontalLineB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.withdrawalsButton withOffset:14.5f]];
            [tableHeaderView addConstraint:[self.horizontalLineB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:tableHeaderView withOffset:0.0f]];
            
            [tableHeaderView addConstraint:[self.giftRecordLabel autoSetDimension:ALDimensionHeight toSize:39.0f]];
            [tableHeaderView addConstraint:[self.giftRecordLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:tableHeaderView withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.giftRecordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.horizontalLineB withOffset:0.0f]];
            [tableHeaderView addConstraint:[self.giftRecordLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:tableHeaderView withOffset:0.0f]];
            //[tableHeaderView addConstraint:[self.giftRecordLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:tableHeaderView withOffset:0.0f]];
        }
        
        UILabel *pullUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 32.0f)];
        pullUpdateLabel.font = [UIFont systemFontOfSize:14.0f];
        pullUpdateLabel.textAlignment = NSTextAlignmentCenter;
        pullUpdateLabel.textColor = [SkinManager sharedInstance].defaultGrayColor;
        [pullUpdateLabel setText:@"向上滑动刷新记录"];
        _giftRecordTableView.tableFooterView = pullUpdateLabel;
    }
    return _giftRecordTableView;
}

- (NSMutableArray *)giftArray
{
    if (!_giftArray) {
        _giftArray = [[NSMutableArray alloc] init];
    }
    return _giftArray;
}

- (NSMutableArray *)paymentsArray
{
    if (!_paymentsArray) {
        _paymentsArray = [[NSMutableArray alloc] init];
    }
    return _paymentsArray;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.giftRecordTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraint:[self.giftRecordTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.giftRecordTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0.0f]];
    [self.view addConstraint:[self.giftRecordTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0f]];
    if (IOS_VERSION >= 7.0) {
        [self.view addConstraint:[self.giftRecordTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-kTabBarHeight]];
    } else {
        [self.view addConstraint:[self.giftRecordTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.0f]];
    }
}

- (NSAttributedString *)formatBalanceWithBalance:(CGFloat)balance
{
    // balance的单位是分
    NSString *balanceString = [NSString stringWithFormat:@"您的账户余额%.02f元", balance / 100.0f];
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:balanceString attributes:attributedDic];
    [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];
    [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[balanceString rangeOfString:@"元"]];
    return balanceAttributedString;
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.giftArray count];
    return [self.paymentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReusableCellIdentifier = @"B815D09D-5F2E-42E9-8ED8-A15B3C250B61";
    static NSInteger GiftDetailTag = 1;
    static NSInteger GiftMoneyTag = 2;
    static NSInteger DateTimeTag = 3;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCellIdentifier];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [UIFont systemFontOfSize:12.0f];
        detailLabel.tag = GiftDetailTag;
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:detailLabel];
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.font = [UIFont systemFontOfSize:12.0f];
        moneyLabel.tag = GiftMoneyTag;
        moneyLabel.numberOfLines = 0;
        moneyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:moneyLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.tag = DateTimeTag;
        timeLabel.numberOfLines = 0;
        timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:timeLabel];
        
        // AutoLayout
        [cell.contentView addConstraint:[detailLabel autoSetDimension:ALDimensionWidth toSize:130.0f]];
        [cell.contentView addConstraint:[timeLabel autoSetDimension:ALDimensionWidth toSize:70.0f]];
        [cell.contentView addConstraint:[detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.contentView withOffset:0.0f]];  // 1
        [cell.contentView addConstraint:[detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.contentView withOffset:0.0f]];    // 2
        [cell.contentView addConstraint:[moneyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.contentView withOffset:0.0f]];  // 3
        [cell.contentView addConstraint:[timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.contentView withOffset:0.0f]];  // 4
        [cell.contentView addConstraint:[timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.contentView withOffset:0.0f]]; // 5
        [cell.contentView addConstraint:[timeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.contentView withOffset:0.0f]]; // 6
        [cell.contentView addConstraint:[moneyLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.contentView withOffset:0.0f]];  // 7
        [cell.contentView addConstraint:[detailLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.contentView withOffset:0.0f]];    // 8
        [cell.contentView addConstraint:[detailLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:moneyLabel withOffset:0.0f]];    // 9
        [cell.contentView addConstraint:[moneyLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:timeLabel withOffset:0.0f]]; // 10
    }
    
    //GiftItem *giftItem = [self.giftArray objectAtIndex:[indexPath row]];
    Payments *paymentsItem = [self.paymentsArray objectAtIndex:[indexPath row]];
    
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:GiftDetailTag];
    //Patient *thePatient = [[ContactManager sharedInstance] getContactWithUserID:[NSString stringWithFormat:@"%d", giftItem.userID]];
    //[detailLabel setText:[NSString stringWithFormat:@"接收%@鲜花", [thePatient getDisplayName]]];
    [detailLabel setText:paymentsItem.project];
    
    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:GiftMoneyTag];
    //[moneyLabel setText:[NSString stringWithFormat:@"%d朵花(%.02f元)", giftItem.number, (CGFloat)(giftItem.money / 100.0f)]];
    CGFloat moneyFloatValue = paymentsItem.money / 100.0f;
    [moneyLabel setText:[NSString stringWithFormat:@"%.02f元", moneyFloatValue]];
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:DateTimeTag];
    //[timeLabel setText:giftItem.dateTimeISO];
    [timeLabel setText:paymentsItem.dateTimeISO];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *ReusableHeaderViewIdentifier = @"EF8DDB60-F8E7-4D35-AA1D-A6E361A4CF77";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReusableHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[UIView alloc] init];
        headerView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        headerView.layer.borderColor = [UIColorFromRGB(0xd4d5d7) CGColor];
        headerView.layer.borderWidth = 0.5f;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        [detailLabel setText:@"详情"];
        [headerView addSubview:detailLabel];
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.font = [UIFont systemFontOfSize:14.0f];
        [moneyLabel setText:@"金额"];
        [headerView addSubview:moneyLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [timeLabel setText:@"时间"];
        [headerView addSubview:timeLabel];
        
        // AutoLayout
        [headerView addConstraint:[detailLabel autoSetDimension:ALDimensionWidth toSize:130.0f]];
        [headerView addConstraint:[timeLabel autoSetDimension:ALDimensionWidth toSize:70.0f]];
        
        [headerView addConstraint:[detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:0.0f]];  // 1
        [headerView addConstraint:[detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0.0f]];    // 2
        [headerView addConstraint:[moneyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0.0f]];  // 3
        [headerView addConstraint:[timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0.0f]];  // 4
        [headerView addConstraint:[timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView withOffset:0.0f]]; // 5
        [headerView addConstraint:[timeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headerView withOffset:0.0f]]; // 6
        [headerView addConstraint:[moneyLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headerView withOffset:0.0f]];  // 7
        [headerView addConstraint:[detailLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headerView withOffset:0.0f]];    // 8
        [headerView addConstraint:[detailLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:moneyLabel withOffset:0.0f]];    // 9
        [headerView addConstraint:[moneyLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:timeLabel withOffset:0.0f]]; // 10
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isLoadingPayment) {
        return ;
    }
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
        self.isLoadingPayment = YES;
        NSInteger pageIndex = self.pageIndex;
        pageIndex += 1;
        [[AccountManager sharedInstance] asyncGetPaymentsRecordWithPageIndex:self.pageIndex withCompletionHandler:^(NSArray *recordArray) {
            self.pageIndex += 1;
            [self.paymentsArray addObjectsFromArray:recordArray];
            [self.giftRecordTableView reloadData];
            self.isLoadingPayment = NO;
        } withErrorHandler:^(NSError *error) {
            
        }];
    }
}

#pragma mark - Selector

- (void)withdrawalsButtonClicked:(id)sender
{
    WithdrawalViewControllerStep2 *withdrawalVCStep2 = [[WithdrawalViewControllerStep2 alloc] init];
    [self.navigationController pushViewController:withdrawalVCStep2 animated:YES];
}

@end
