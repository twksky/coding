//
//  GoodsDetailController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "GoodsDetailController.h"
#import "HeaderManger.h"
#import "GlideManger.h"

@interface GoodsDetailController ()<UIAlertViewDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *fsLabel;
@property(nonatomic, strong) UILabel *deleteLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIImageView *goodsIV;

@property(nonatomic, strong) NSString *oldPrice;
@end

@implementation GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    [self setupBottomView];
    [self setUpFooterView];
    
    [GlideManger getGoodsDetailWithGoodsId:self.goods_id success:^(GoodsDetail *goodsDetail) {
        
        GDLog(@"%@",goodsDetail);
        [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:goodsDetail.pic_url] placeholderImage:[UIImage imageNamed:@"default_goods"]];
        self.titleLabel.text = goodsDetail.name;
        
        self.fsLabel.text = [NSString stringWithFormat:@"%ld分",goodsDetail.need_score];
        
        self.oldPrice = goodsDetail.real_price;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.oldPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value: UIColorFromRGB(0xa8a8aa) range:NSMakeRange(0, self.oldPrice.length)];
        self.deleteLabel.textColor = UIColorFromRGB(0xa8a8aa);
        [self.deleteLabel setAttributedText:attri];
        
        self.descLabel.text = goodsDetail.desc;

        self.timeLabel.text = [NSString stringWithFormat:@"有效期%@", goodsDetail.validity_period];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
    }];
    
    
}
- (void)setUpHeaderView
{
    self.goodsIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_goods"]];
    _goodsIV.frame = CGRectMake(0, 0, App_Frame_Width, 200);
    _goodsIV.backgroundColor = GDRandomColor;
    self.tbv.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    self.tbv.backgroundColor = [UIColor whiteColor];

    [HeaderManger stretchHeaderForTableView:self.tbv withView:_goodsIV];
}

- (void)setUpFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 500)];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"妓房动乱事件分类附近萨洛房间里的快速减肥的上来看附件克法就是了";
    _titleLabel.font = GDFont(14);
    _titleLabel.numberOfLines = 0;
    
    [footerView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footerView).offset(25);
        make.left.equalTo(footerView).offset(15);
        make.width.lessThanOrEqualTo(App_Frame_Width - 100);
    }];
    
    // 分数
    self.fsLabel = [[UILabel alloc] init];
    _fsLabel.text = @"4000分";
    _fsLabel.textColor = kNavBarColor;
//    _fsLabel.backgroundColor = GDRandomColor;
    
    [footerView addSubview:_fsLabel];
    [_fsLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel);
        make.right.equalTo(footerView).offset(-15);
    }];
    
    // 删除的
    self.deleteLabel = [[UILabel alloc] init];
    _descLabel.backgroundColor = GDRandomColor;
    _descLabel.font = GDFont(12);
    _descLabel.textColor = UIColorFromRGB(0xa8a8aa);
//    self.oldPrice = @"del";
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.oldPrice];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.oldPrice.length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, self.oldPrice.length)];
//    [_deleteLabel setAttributedText:attri];
    
    [footerView addSubview:_deleteLabel];
    [_deleteLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_fsLabel.bottom).offset(5);
        make.right.equalTo(_fsLabel);
//        make.width.lessThanOrEqualTo(80);
    }];
    // 商品介绍
    
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = [UIColor lightGrayColor];
    
    [footerView addSubview:hLine];
    [hLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(footerView);
        make.top.equalTo(_titleLabel.bottom).offset(50);
        make.height.equalTo(1);
    }];
    
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.text = @"商品介绍";
    introLabel.backgroundColor = [UIColor whiteColor];
    introLabel.textColor = [UIColor lightGrayColor];
    
    [footerView addSubview:introLabel];
    [introLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(hLine);
    }];
    
    // 描述
    self.descLabel = [[UILabel alloc] init];
    _descLabel.text = @"附近萨洛克\n附近的拉\n萨发来撒放进\n来撒骄傲了放假啊水立方福建省啦放进来撒";
    _descLabel.numberOfLines = 0;
    _descLabel.textAlignment = NSTextAlignmentCenter;
    
    [footerView addSubview:_descLabel];
    [_descLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(introLabel.bottom).offset(20);
        make.centerX.equalTo(introLabel);
        make.width.lessThanOrEqualTo(App_Frame_Width - 150);
    }];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textColor = UIColorFromRGB(0xa8a8aa);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.descLabel.bottom).offset(21);
        make.centerX.equalTo(introLabel);
        make.width.lessThanOrEqualTo(App_Frame_Width - 150);
        
    }];
    
    self.tbv.tableFooterView = footerView;
}
- (void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(70);
    }];
    
    UIButton *exchangeBtn = [[UIButton alloc] init];
    exchangeBtn.backgroundColor = kNavBarColor;
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:exchangeBtn];
    [exchangeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}
- (void)exchangeBtnClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定兑换？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // 确定兑换
        
        NSInteger needScore = [_need_score integerValue];
        
        if (needScore > kAccount.score) { // 积分不足
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"积分不足!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        
        [MBProgressHUD showMessage:@"正在兑换..." toView:self.view isDimBackground:NO];
        
        [GlideManger exchangeGoodsWithGiftID:(int)_goods_id success:^(ExchangeGoods *goods) {
           
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"兑换成功" toView:self.view];
            
            kAccount.score -= needScore;

            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
            
        }];
        
        
    }
}


@end
