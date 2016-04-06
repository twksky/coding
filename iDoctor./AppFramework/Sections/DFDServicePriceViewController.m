//
//  DFDServicePriceViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDServicePriceViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "DFDSetPriceViewController.h"
#import "AccountManager.h"

@interface DFDServicePriceViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
DFDSetPriceViewControllerDelegate
>

@property (nonatomic, strong) UITableView   *contentTableView;
@property (nonatomic, strong) NSIndexPath   *lastSelectedIndexPath;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation DFDServicePriceViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithTitle:@"服务价格设置" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    self.contentTableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.contentTableView.tableFooterView = view;
    
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Property

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellIdentifier = @"EB8D6DEA-B920-496E-B6C5-BE2F9B92F5C0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusableCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Account *account = [AccountManager sharedInstance].account;
    
//    if (0 == indexPath.row) {
//        [cell.textLabel setText:@"门诊观察期随访报告"];
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld元", (long)(account.outPatientAskPrice / 100)]];
//    } else if (1 == indexPath.row) {
//        [cell.textLabel setText:@"出院观察期随访报告"];
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld元", (long)(account.hospitalAskPrice / 100)]];
//    } else if (2 == indexPath.row) {
//        [cell.textLabel setText:@"紧急电话回呼"];
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld元", (long)(account.urgencyAskPrice / 100)]];
//    }
    
//    if (0 == indexPath.row) {
        [cell.textLabel setText:@"紧急电话回呼"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld元", (long)(account.urgencyAskPrice / 100)]];
//    } else if (1 == indexPath.row) {
//        [cell.textLabel setText:@"出院观察期随访报告"];
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld元", (long)(account.hospitalAskPrice / 100)]];
//    } else if (2 == indexPath.row) {
//        [cell.textLabel setText:@"紧急电话回呼"];
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld元", (long)(account.urgencyAskPrice / 100)]];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastSelectedIndexPath = indexPath;
    DFDSetPriceViewController *setPriceViewController = [[DFDSetPriceViewController alloc] init];
    setPriceViewController.delegate = self;
//    if (0 == indexPath.row) {
//        setPriceViewController.title = @"门诊观察期随访报告";
//    } else if (1 == indexPath.row) {
//        setPriceViewController.title = @"出院观察期随访报告";
//    } else if (2 == indexPath.row) {
        setPriceViewController.title = @"紧急电话回呼";
//    }
    
    [self.navigationController pushViewController:setPriceViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - DFDSetPriceViewControllerDelegate

- (void)setPriceViewController:(DFDSetPriceViewController *)viewController didSelectedPrice:(NSInteger)price
{
    Account *tmpAccount = [[Account alloc] init];
    tmpAccount.hospitalAskPrice = [AccountManager sharedInstance].account.hospitalAskPrice;
    tmpAccount.outPatientAskPrice = [AccountManager sharedInstance].account.outPatientAskPrice;
    tmpAccount.urgencyAskPrice = [AccountManager sharedInstance].account.urgencyAskPrice;
    
    if (0 == self.lastSelectedIndexPath.row) {
//        tmpAccount.outPatientAskPrice = price;
        tmpAccount.urgencyAskPrice = price;
    } else if (1 == self.lastSelectedIndexPath.row) {
//        tmpAccount.hospitalAskPrice = price;
    } else if (2 == self.lastSelectedIndexPath.row) {
//        tmpAccount.urgencyAskPrice = price;
    }
    
    [[AccountManager sharedInstance] asyncUploadAccount:tmpAccount withCompletionHandler:^(Account *account) {
        [self.navigationController popToViewController:self animated:YES];
        [self.contentTableView beginUpdates];
        [self.contentTableView reloadRowsAtIndexPaths:@[self.lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.contentTableView endUpdates];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

@end
