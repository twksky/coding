//
//  DoctorCreditShopCell.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/25.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorCreditShopCell.h"
#import <UIImageView+WebCache.h>
#import <PureLayout.h>
#import "EXUILabel.h"
#import "GoodsModel.h"
#import "SkinManager.h"

@interface DoctorCreditShopCell ()

@property (nonatomic, strong) UIImageView *goodsIcon;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsValueLabel;
@property (nonatomic, strong) EXUILabel *goodsValueTitle;
@property (nonatomic, strong) UILabel *goodsMarketLabel;
@property (nonatomic, strong) UIButton *exchangeItButton;

@property (nonatomic, strong) GoodsModel *goods;

@end

@implementation DoctorCreditShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self.contentView addSubview:self.goodsIcon];
    {
        [self.contentView addConstraints:[self.goodsIcon autoSetDimensionsToSize:CGSizeMake(60.0f, 60.0f)]];
        [self.contentView addConstraint:[self.goodsIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self.contentView addConstraint:[self.goodsIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [self.contentView addSubview:self.goodsNameLabel];
    {
        [self.contentView addConstraint:[self.goodsNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.goodsIcon]];
        [self.contentView addConstraint:[self.goodsNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.goodsIcon withOffset:10.0f]];
        [self.contentView addConstraint:[self.goodsNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70.0f]];
    }
    
    [self.contentView addSubview:self.goodsValueLabel];
    {
        [self.contentView addConstraint:[self.goodsValueLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self.contentView addConstraint:[self.goodsValueLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.goodsIcon withOffset:10.0f]];
    }
    
    [self.contentView addSubview:self.goodsValueTitle];
    {
        [self.contentView addConstraint:[self.goodsValueTitle autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.goodsValueLabel withOffset:5.0f]];
        [self.contentView addConstraint:[self.goodsValueTitle autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.goodsValueLabel]];
    }
    
    [self.contentView addSubview:self.goodsMarketLabel];
    {
        [self.contentView addConstraint:[self.goodsMarketLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.goodsIcon]];
        [self.contentView addConstraint:[self.goodsMarketLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.goodsIcon withOffset:10.0]];
    }
    
    [self.contentView addSubview:self.exchangeItButton];
    {
        [self.contentView addConstraints:[self.exchangeItButton autoSetDimensionsToSize:CGSizeMake(60.0f, 30.0f)]];
        [self.contentView addConstraint:[self.exchangeItButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [self.contentView addConstraint:[self.exchangeItButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f]];
    }
}

#pragma mark - selector

- (void)exchangeItButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(exchangedWithGoods:)]) {
        
        [self.delegate exchangedWithGoods:self.goods];
    }
}


#pragma mark - loadData

- (void)loadDataWithGoods:(GoodsModel *)goods {
    
    self.goods = goods;
    
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:goods.picUrl] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];
    self.goodsNameLabel.text = goods.name;
    self.goodsValueLabel.text = [NSString stringWithFormat:@"%ld", goods.needScore];
    self.goodsMarketLabel.text = goods.realPrice;
}

#pragma mark - properties

- (UIImageView *)goodsIcon {
    
    if (!_goodsIcon) {
        
        _goodsIcon = [[UIImageView alloc] init];
        _goodsIcon.layer.cornerRadius = 3.0f;
        _goodsIcon.layer.masksToBounds = YES;
    }
    
    return _goodsIcon;
}

- (UILabel *)goodsNameLabel {
    
    if (!_goodsNameLabel) {
        
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return _goodsNameLabel;
}

- (UILabel *)goodsValueLabel {
    
    if (!_goodsValueLabel) {
        
        _goodsValueLabel = [[UILabel alloc] init];
        _goodsValueLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        _goodsValueLabel.textColor = UIColorFromRGB(0x54d0b8);
    }
    
    return _goodsValueLabel;
}

- (EXUILabel *)goodsValueTitle {
    
    if (!_goodsValueTitle) {
        
        _goodsValueTitle = [[EXUILabel alloc] init];
        _goodsValueTitle.font = [UIFont systemFontOfSize:14.0f];
        _goodsValueTitle.textColor = UIColorFromRGB(0x54d0b8);
        _goodsValueTitle.textEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 5.0f, 0.0f);
        _goodsValueTitle.text = @"积分";
    }
    
    return _goodsValueTitle;
}

- (UILabel *)goodsMarketLabel {
    
    if (!_goodsMarketLabel) {
        
        _goodsMarketLabel = [[UILabel alloc] init];
        _goodsMarketLabel.textColor = UIColorFromRGB(0x9a9c9c);
        _goodsMarketLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _goodsMarketLabel;
}

- (UIButton *)exchangeItButton {
    
    if (!_exchangeItButton) {
        
        _exchangeItButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeItButton setTitle:@"兑换" forState:UIControlStateNormal];
        [_exchangeItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exchangeItButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _exchangeItButton.backgroundColor = UIColorFromRGB(0x54d0b8);
        _exchangeItButton.layer.cornerRadius = 15.0f;
        [_exchangeItButton addTarget:self action:@selector(exchangeItButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exchangeItButton;
}

@end
