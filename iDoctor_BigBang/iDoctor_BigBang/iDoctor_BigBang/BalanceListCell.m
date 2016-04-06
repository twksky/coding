//
//  BalanceListCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BalanceListCell.h"
#import "BalanceListRowModel.h"

@interface BalanceListCell ()
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *numLabel;
@end
@implementation BalanceListCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    BalanceListRowModel *bm = (BalanceListRowModel *)model;
    self.timeLabel.text = bm.balanceGlide.datetime_iso;
    self.descLabel.text = bm.balanceGlide.project;
    if (bm.balanceGlide.money >= 0)
    {
        self.numLabel.text = [NSString stringWithFormat:@"+%ld",bm.balanceGlide.money];
        self.numLabel.textColor = UIColorFromRGB(0xf29b4d);
    }
    else
    {
        self.numLabel.text = [NSString stringWithFormat:@"%ld",bm.balanceGlide.money];
        self.numLabel.textColor = UIColorFromRGB(0x36cacc);

    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BalanceListCell";
    BalanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BalanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    //    contentView.backgroundColor = GDRandomColor;
    // 竖线
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [contentView addSubview:vLine];
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
        make.width.equalTo(1);
    }];
    
    // 图标
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"integral_list"]];
    
    [contentView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(vLine);
        make.centerY.equalTo(vLine).offset(-10);
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = UIColorFromRGB(0xb0b1b1);
    _timeLabel.text = @"10-20-30";
    _timeLabel.font = GDFont(11);
    
    [contentView addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(iv);
        make.left.equalTo(iv.right).offset(10);
    }];
    
    // 简短描述
    self.descLabel = [[UILabel alloc] init];
    _descLabel.text = @"放假了时法就是了附近的数量看风景飞间分类";
    _descLabel.font = GDFont(15);
    _descLabel.textColor = kDefaultFontColor;
    
    [contentView addSubview:_descLabel];
    [_descLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_timeLabel.bottom).offset(5);
        make.left.equalTo(_timeLabel);
        make.width.lessThanOrEqualTo(App_Frame_Width - 150);
    }];
    
    // 数字
    self.numLabel = [[UILabel alloc] init];
    _numLabel.text = @"+10000000分";
    _numLabel.textColor = GDRandomColor;
    _numLabel.font = GDFont(15);
    
    [contentView addSubview:_numLabel];
    [_numLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_descLabel);
        make.right.equalTo(contentView).offset(-15);
    }];

}

@end
