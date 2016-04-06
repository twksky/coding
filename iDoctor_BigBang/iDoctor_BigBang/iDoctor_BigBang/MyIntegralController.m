//
//  MyIntegralController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyIntegralController.h"
#import "HeaderManger.h"
#import "IntegralHeaderView.h"
#import "ExchangeController.h"
#import "ShopingController.h"
#import "GlideManger.h"
@interface MyIntegralController ()<UIAlertViewDelegate>

@property(nonatomic, strong) IntegralHeaderView *headerView;

@end

@implementation MyIntegralController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopWithExchange:) name:@"shopWithExchange" object:nil];
    
    [GlideManger balanceGlideWithAccountId:kAccount.doctor_id Page:1 size:20 success:^(NSArray *balanceGlideArray) {
        
        GDLog(@"%@", balanceGlideArray);
        
    } failure:^(NSError *error) {
        
         [MBProgressHUD showError:error.localizedDescription];
    }];
}
- (void)setUpData
{
    [self setUpSection1];
    [self.headerView setScore:kAccount.score];
}
- (void)setUpTableView
{
    self.headerView = [[IntegralHeaderView alloc] init];
    __weak typeof(self) wkSelf = self;

    [self.headerView setShopBtnClickBlock:^{
        
        ShopingController *shoping = [[ShopingController alloc] init];
        shoping.title = @"积分商城";
        [wkSelf.navigationController pushViewController:shoping animated:YES];
    }];
    [self.headerView setExchangeBtnClickBlock:^{
        ExchangeController *exchange = [[ExchangeController alloc] init];
        exchange.title = @"积分兑换";
        [wkSelf.navigationController pushViewController:exchange animated:YES];

    }];
    
    self.tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setUpSection1
{
    NSMutableArray *tmpArrM = [NSMutableArray array];
    [GlideManger integralGlideWithAccountId:kAccount.doctor_id Page:1 size:20 success:^(NSArray *integralGlideArray) {
        
//        GDLog(@"%@",integralGlideArray);
        [integralGlideArray enumerateObjectsUsingBlock:^(IntegralGlide *ig, NSUInteger idx, BOOL *stop) {
            
            IntegralListRowModel *m = [IntegralListRowModel integralListRowModelWithIntegralGlide:ig];
            [tmpArrM addObject:m];
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
    lb.text = @"积分记录";
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidNavBarBottomLine];
    [HeaderManger stretchHeaderForTableView:self.tbv withView:self.headerView];

}

//twk
-(void)shopWithExchange:(NSNotification *)notification{
    
    Goods *model = notification.object;
    
    if ([model.need_score intValue] <= kAccount.score ) {
        //兑换
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定兑换该物品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aler show];
    }else{
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"积分不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aler show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }else if (buttonIndex == 1){
        
        [MBProgressHUD showMessage:@"正在兑换..." toView:self.view isDimBackground:NO ];
        
        [GlideManger exchangeGoodsWithGiftID:(int)goodsModel.goods.goods_id success:^(ExchangeGoods *goods) {
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showSuccess:@"兑换成功"];
            
            kAccount.score -= [goodsModel.goods.need_score intValue];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];
        
    }
    
}

@end
