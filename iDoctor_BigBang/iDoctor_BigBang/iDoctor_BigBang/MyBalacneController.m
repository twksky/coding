//
//  MyBalacneController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBalacneController.h"
#import "HeaderManger.h"
#import "BalanceHeaderView.h"
#import "ChargeController.h"
@interface MyBalacneController ()
@property(nonatomic, strong) BalanceHeaderView *headerView;
@end

@implementation MyBalacneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];

    [self setUpData];
}
- (void)setUpData
{
    [self setUpSection1];
}

- (void)setUpTableView
{
    self.headerView = [[BalanceHeaderView alloc] init];
    __weak typeof(self) wkSelf = self;
    [self.headerView setChargeBtnClickBlock:^{
        
        ChargeController *charge = [[ChargeController alloc] init];
        charge.title = @"提现";
        charge.balance = kAccount.balance;
        [wkSelf.navigationController pushViewController:charge animated:YES];
    }];
}

- (void)setUpSection1
{
    NSMutableArray *tmpArrM = [NSMutableArray array];
    [GlideManger balanceGlideWithAccountId:kAccount.doctor_id Page:1 size:20 success:^(NSArray *balanceGlideArray) {
        
        [balanceGlideArray enumerateObjectsUsingBlock:^(BalanceGlide *bg, NSUInteger idx, BOOL *stop) {
            
            BalanceListRowModel *bl = [BalanceListRowModel balanceListRowModelWithBalanceGlide:bg];
            [tmpArrM addObject:bl];
        }];
        SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
        [self.sectionModelArray addObject:sectionModel];
        [self.tbv reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
    }];
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"交易记录";
    lb.textColor = UIColorFromRGB(0xa8a8aa);
    lb.font = GDFont(12);
    
    [view addSubview:lb];
    [lb makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(15);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidNavBarBottomLine];
    [HeaderManger stretchHeaderForTableView:self.tbv withView:self.headerView];
}

@end
