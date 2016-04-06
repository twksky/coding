//
//  PatientInfoViewController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/1/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "PatientInfoViewController.h"
#import "ZoomHeaderView.h"
#import "GDComposeView.h"
@interface PatientInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation PatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllViews];
}
- (void)setUpAllViews
{
    [self setUpNav];
    self.view.backgroundColor = [UIColor whiteColor];
   // [self setUpTableView];
}
- (void)setUpNav
{
    UIImage *img = [UIImage resizedImageWithImage:[UIImage createImageWithColor:kNavBarColor]];
    [self.navigationController.navigationBar setBackgroundImage:img
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)setUpTableView
{
    [self.view addSubview:self.tableView];

    ZoomHeaderView *headerView = [ZoomHeaderView zoomHeaderViewWithCGSize:CGSizeMake(App_Frame_Width, 185)];

    UIImage *img = [UIImage resizedImageWithImage:[UIImage createImageWithColor:kNavBarColor]];
    headerView.headerImage = img;
    
    self.tableView.tableHeaderView = headerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [(ZoomHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    cell.backgroundColor = GDRandomColor;
    cell.textLabel.text = @"df";
    return cell;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Height) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.barTintColor = UIColorFromRGB(0xeaeaea);
    
    UIButton *lBtn = [self ceratBtnWithImage:[UIImage imageNamed:@"revert_idea"] title:@"回复意见"];
    [lBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:lBtn];
    
    UIButton *rBtn = [self ceratBtnWithImage:[UIImage imageNamed:@"incept_patient"] title:@"接收患者"];
    [rBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    
    NSArray *arr = @[leftItem, rightItem];
    self.toolbarItems = arr;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (UIButton *)ceratBtnWithImage:(UIImage *)image title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    btn.bounds = CGRectMake(0, 0, App_Frame_Width/2-20, 30);
    btn.backgroundColor = kNavBarColor;
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = GDFont(16);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}
- (void)leftBtnClick:(UIButton *)btn
{
    GDComposeView *compose = [[GDComposeView alloc] init];
    [compose setSendBtnClickBlock:^(NSString *text) {
        
        GDLog(@"%@",text);
    }];
    [compose setCancalBtnClickBlock:^(NSString *text) {
        
        GDLog(@"%@",text);
    }];
    [compose show];
}
- (void)rightBtnClick:(UIButton *)btn
{
    GDLog(@"right.....");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你已经接收了患者\n你可以跟他聊天了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
