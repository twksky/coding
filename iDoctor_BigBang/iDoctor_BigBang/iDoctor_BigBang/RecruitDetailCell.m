//
//  RecruitDetailCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/23/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RecruitDetailCell.h"
#import "IWantPatientDataManger.h"
@interface RecruitDetailCell ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *sexLabel;
@property(nonatomic, strong) UILabel *ageLabel;
@property(nonatomic, strong) UILabel *numLabel;
@end
@implementation RecruitDetailCell

- (void)setDataWithRecruitDetail:(RecruitDetail *)recruitDetail
{
    self.titleLabel.text = recruitDetail.title;
    self.descLabel.text = recruitDetail.desc;
    self.sexLabel.text = recruitDetail.sex;
    self.ageLabel.text = recruitDetail.age;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",recruitDetail.need_people];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    RecruitDetailCell *cell = [[RecruitDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
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
    UIView *wrap = [[UIView alloc] init];
    [self.contentView addSubview:wrap];
    [wrap makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = GDRandomColor;
    _titleLabel.text = @"表达法决定开始附近的开始啦";
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    _titleLabel.textColor = kDefaultFontColor;
    
    [wrap addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(wrap);
    }];
    
    // 详细描述
    self.descLabel = [[UILabel alloc] init];
//    _descLabel.backgroundColor = GDRandomColor;
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = kDefaultFontColor;
    _descLabel.font = GDFont(14);
    _descLabel.text = @"交罚款了多少就发了多少卡交罚款了的撒减肥了凯撒";
    
    [wrap addSubview:_descLabel];
    [_descLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.bottom).offset(17);
        make.left.right.equalTo(wrap);
    }];
    
    // 横线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [wrap addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_descLabel.bottom).offset(15);
        make.left.right.equalTo(wrap);
        make.height.equalTo(1);
    }];
    
    // 要求
    UILabel *yq = [[UILabel alloc] init];
//    yq.backgroundColor = GDRandomColor;
    yq.text = @"要求";
    yq.font = [UIFont systemFontOfSize:15];
    
    [wrap addSubview:yq];
    [yq makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.bottom).offset(15);
        make.left.equalTo(wrap);
    }];
    
    // 性别标题
    
    UILabel *xb = [self ceateLabelWithText:@"性别:"];
    
    [wrap addSubview:xb];
    [xb makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(yq.bottom).offset(15);
        make.left.equalTo(wrap);
    }];
    
    //性别
    self.sexLabel = [self ceateLabelWithText:@"男"];
    
    [wrap addSubview:_sexLabel];
    [_sexLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(xb);
        make.left.equalTo(xb.right).offset(10);
    }];
    
    // 年龄标题
    UILabel *nl = [self ceateLabelWithText:@"年龄:"];
    
    [wrap addSubview:nl];
    [nl makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(xb);
        make.left.equalTo(_sexLabel.right).offset(30);
    }];
    
    // 年龄
    self.ageLabel = [self ceateLabelWithText:@"老"];
    
    [wrap addSubview:_ageLabel];
    [_ageLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(xb);
        make.left.equalTo(nl.right).offset(10);
    }];
    
    // 需要人数:
    UILabel *xyrs = [self ceateLabelWithText:@"需要人数:"];
    
    [wrap addSubview:xyrs];
    [xyrs makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(xb);
        make.left.equalTo(_ageLabel.right).offset(30);
    }];
    
    // 需要人数
    self.numLabel = [self ceateLabelWithText:@"1000"];
    
    [wrap addSubview:_numLabel];
    [_numLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(xb);
        make.left.equalTo(xyrs.right).offset(10);
    }];
    
}

+ (CGFloat)height
{
    return 200;
}

- (UILabel *)ceateLabelWithText:(NSString *)text
{
    UILabel *lb = [[UILabel alloc] init];
//    lb.backgroundColor = GDRandomColor;
    lb.textColor = kDefaultFontColor;
    lb.font = GDFont(14);
    lb.text = text;
    
    return lb;
}

@end
