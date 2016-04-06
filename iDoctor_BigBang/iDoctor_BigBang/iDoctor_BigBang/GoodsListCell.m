//
//  GoodsListCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "GoodsListCell.h"
#import "GoodsListRowModel.h"

@interface GoodsListCell ()
@property(nonatomic, strong) UIImageView *iv;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *exchangeBtn;
@property(nonatomic, strong) UILabel *deleteLabel;
@property(nonatomic, copy) NSString *oldPrice;

@property(nonatomic, strong) UILabel *jfLabel;

@property (nonatomic, strong) GoodsListRowModel *goodsModel;

@end
@implementation GoodsListCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    GoodsListRowModel *gl = (GoodsListRowModel *)model;
    
    self.goodsModel = gl;
    
    self.titleLabel.text = gl.goods.name;
    self.oldPrice = gl.goods.real_price;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.oldPrice.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, self.oldPrice.length)];
    [_deleteLabel setAttributedText:attri];
    [self.iv sd_setImageWithURL:[NSURL URLWithString:gl.goods.pic_url] placeholderImage:[UIImage imageNamed:@"default_card"]];
    self.jfLabel.text = gl.goods.need_score;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"GoodsListCell";
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[GoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self setUpAllViews];
    }
    return self;
}
- (void)setUpAllViews
{
    UIView *contentView = self.contentView;
    
    // 图片
     self.iv = [[UIImageView alloc] init];
     _iv.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [contentView addSubview:_iv];
    [_iv makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.width.equalTo(100);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"发的连接方式附近的快乐房附近的萨洛克发动机是发生了价都是浪费烦死了快";
    _titleLabel.textColor = kDefaultFontColor;
    _titleLabel.font = GDFont(15);
    _titleLabel.numberOfLines = 2;
    
    [contentView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_iv).offset(10);
        make.left.equalTo(_iv.right).offset(5);
        make.right.equalTo(contentView).offset(-15);
    }];
    
    // 兑换按钮
    self.exchangeBtn = [[UIButton alloc] init];
    _exchangeBtn.layer.borderWidth = 0.5;
    _exchangeBtn.layer.borderColor = kNavBarColor.CGColor;
    _exchangeBtn.titleLabel.font = GDFont(14);
    
    [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [_exchangeBtn setTitleColor:kNavBarColor forState:UIControlStateNormal];
    
    [_exchangeBtn addTarget:self action:@selector(exchangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:_exchangeBtn];
    [_exchangeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(contentView).offset(-15);
        make.width.equalTo(60);
        make.height.equalTo(30);
    }];
    
    // 原价
    self.deleteLabel = [[UILabel alloc] init];
    _deleteLabel.font = GDFont(12);
    _deleteLabel.textColor = UIColorFromRGB(0xa8a8aa);
    
    self.oldPrice = @"原价200元";
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.oldPrice.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0xa8a8aa) range:NSMakeRange(0, self.oldPrice.length)];
    [_deleteLabel setAttributedText:attri];
    
    [contentView addSubview:_deleteLabel];
    [_deleteLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_exchangeBtn).offset(-3);
        make.left.equalTo(_titleLabel);
        make.width.lessThanOrEqualTo(120);
    }];
    
    // 积分
    self.jfLabel = [[UILabel alloc] init];
    _jfLabel.font = GDFont(15);
    _jfLabel.textColor = kNavBarColor;
    _jfLabel.text = @"4000分";
    
    [contentView addSubview:_jfLabel];
    [_jfLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_deleteLabel.bottom).offset(-3);
        make.left.equalTo(_deleteLabel);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(contentView);
        make.height.equalTo(1);
    }];
}

- (void)exchangeBtnClick
{
    
    if (_block) {
        
        _block(self.goodsModel);
        
    }
    
    
}
@end
