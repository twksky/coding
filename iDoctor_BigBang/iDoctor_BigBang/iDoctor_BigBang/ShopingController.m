//
//  ShopingController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ShopingController.h"
#import "GoodsDetailController.h"
@interface ShopingController ()

@property(nonatomic, strong) UILabel *integralLabel;
@end

@implementation ShopingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    [self setUpSection0];
}

- (void)setUpHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 110)];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"可用积分";
    tipLabel.textColor = kNavBarColor;
    tipLabel.font = GDFont(14);
    
    [headerView addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView);
        make.centerY.equalTo(headerView).offset(-30);
    }];
    
    self.integralLabel = [[UILabel alloc] init];
    _integralLabel.font = [UIFont boldSystemFontOfSize:50];
    _integralLabel.textColor = kNavBarColor;

    _integralLabel.text = [NSString stringWithFormat:@"%ld",kAccount.score];
    
    [headerView addSubview:_integralLabel];
    [_integralLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView);
        make.centerY.equalTo(headerView).offset(20);
    }];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = kNavBarColor;
    lb.text = @"分";
    
    [headerView addSubview:lb];
    [lb makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_integralLabel.right);
        make.bottom.equalTo(_integralLabel).offset(-10);
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [headerView addSubview:vLine];
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(headerView);
        make.height.equalTo(1);
    }];
    
    self.tbv.backgroundColor = [UIColor whiteColor];
    self.tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbv.tableHeaderView = headerView;
}
- (void)setUpSection0
{
    NSMutableArray *tmpArrM = [NSMutableArray array];
    [GlideManger getGoodsIfSuccess:^(NSArray *goods) {
        
        [goods enumerateObjectsUsingBlock:^(Goods *g, NSUInteger idx, BOOL *stop) {
            
            GoodsListRowModel *gl = [GoodsListRowModel goodsListRowModelWithGoods:g];
            
            [gl setRowSelectedBlock:^(NSIndexPath *indexPath) {
                
                GoodsDetailController *goods = [[GoodsDetailController alloc] init];
                goods.title = @"商品详情";
                goods.goods_id = g.goods_id;
                goods.need_score = g.need_score;
               
                [self.navigationController pushViewController:goods animated:YES];
                
            }];
            
            [tmpArrM addObject:gl];
            
        }];
        
        SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
        [self.sectionModelArray addObject:sectionModel];
        [self.tbv reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
@end
