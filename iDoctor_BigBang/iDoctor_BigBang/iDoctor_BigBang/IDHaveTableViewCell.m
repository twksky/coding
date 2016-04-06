//
//  IDHaveTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDHaveTableViewCell.h"

#import "IDGetDoctorPatient.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface IDHaveTableViewCell()

// 姓名
@property (nonatomic, strong) UILabel *nameLabel;

// 病种名显示
@property (nonatomic, strong) UILabel *detailsLabel;

// 记录点击的行和列
@property (nonatomic, strong) NSIndexPath *indexPath;


// 分割线
@property (nonatomic, strong) UIView *segment1;

@end

@implementation IDHaveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

// 创建UI
- (void)setupUI
{
    
    
    // 头像
    [self.contentView addSubview:self.iconImageBtn];
    [self.iconImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(10);
        // make.top.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(51, 51));
        
    }];
    
    
    // 姓名
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImageBtn.right).with.offset(10);
        // make.top.equalTo(self.contentView).with.offset(19);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    // 性别
    [self.contentView addSubview:self.sexImage];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLabel.right).with.offset(5);
        // make.top.equalTo(self.contentView).with.offset(19);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // make.top.equalTo(self.contentView).with.offset(19);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.sexImage.right).with.offset(10);
        make.size.equalTo(CGSizeMake(1, 18));
    }];
    
    // 年龄
    [self.contentView addSubview:self.ageLabel];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(segment.right).with.offset(10);
        // make.top.equalTo(self.contentView).with.offset(19);
        make.centerY.equalTo(self.contentView);
    }];
    
    // 加号
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(27.5f);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.size.equalTo(CGSizeMake(68, 30));
    }];
    
    
    
    
    // 分割线
    self.segment1 = [[UIView alloc] init];
    self.segment1.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:self.segment1];
    [self.segment1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 10, 1));
    }];
    
}

// 进行数据的填写
- (void)getDataWithName:(IDGetDoctorPatient *)model  indexPath:(NSIndexPath *)indexPath isHideSegment:(BOOL)isHide
{
    self.indexPath = indexPath;
    self.iconImageBtn.tag = [model.patient_id intValue];
    UIImageView *imageView =[[UIImageView alloc] init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"fmale"]];
//    [self.iconImageBtn setImage:[UIImage imageNamed:@"fmale"] forState:UIControlStateNormal];
    [self.iconImageBtn setImageWithURL:[NSURL URLWithString:model.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fmale"]];
//    [self.iconImageBtn.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"fmale"]] ;
    
    self.nameLabel.text = model.realname;
    
    if ([model.sex isEqualToString:@"男"]) {
        
        self.sexImage.image = [UIImage imageNamed:@"myHavePatient_male"];
    } else {
        
        self.sexImage.image = [UIImage imageNamed:@"myHavePatient_fmale"];
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",model.age];
    
    self.segment1.hidden = isHide;
    
}

#pragma mark - 懒加载
// 头像
- (UIButton *)iconImageBtn
{
    if (_iconImageBtn == nil) {
        
        _iconImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconImageBtn addTarget:self action:@selector(intoIDPatientMessageVC:) forControlEvents:UIControlEventTouchUpInside];
        _iconImageBtn.layer.masksToBounds = YES;
        _iconImageBtn.layer.cornerRadius = 27.5f;
        
    }
    
    return _iconImageBtn;
}

// 姓名
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = UIColorFromRGB(0x353d3f);
        
    }
    return _nameLabel;
}

// 性别
- (UIImageView *)sexImage
{
    if (_sexImage == nil) {
        
        _sexImage = [[UIImageView alloc] init];
    }
    
    return _sexImage;
}

// 年龄
- (UILabel *)ageLabel
{
    if (_ageLabel == nil) {
        
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.textColor = UIColorFromRGB(0x353d3f);
        _ageLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _ageLabel;
}

// 加号
- (UIButton *)addButton
{
    if (_addButton == nil) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"添加病历" forState:UIControlStateNormal];
        [_addButton setTitleColor:UIColorFromRGB(0x36cacc) forState:UIControlStateNormal];
        _addButton.layer.borderColor = UIColorFromRGB(0x36cacc).CGColor;
        _addButton.layer.borderWidth = 1;
        _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
    
}

- (UILabel *)detailsLabel
{
    if (_detailsLabel == nil) {
        
        _detailsLabel = [[UILabel alloc] init];
        _detailsLabel.textColor = UIColorFromRGB(0xa8a8a8);
        _detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _detailsLabel;
}

- (void)addButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(addPatientButtonClick:index:)]) {
        
        [self.delegate addPatientButtonClick:button index:self.indexPath];
        
    }
    
}

//进详情页
-(void)intoIDPatientMessageVC:(UIButton *)btn{
    
    
    if ([self.intoDetailsDelegate respondsToSelector:@selector(intoIDPatientMessageVC:)]) {
        
        [self.intoDetailsDelegate intoIDPatientMessageVC:btn];
        
    }else if ([self.delegate respondsToSelector:@selector(intoIDPatientMessageVC:)]) {
        
        [self.delegate intoIDPatientMessageVC:btn];
        
    }

}

@end
