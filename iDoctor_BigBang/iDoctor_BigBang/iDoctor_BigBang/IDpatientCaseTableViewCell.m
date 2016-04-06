//
//  IDpatientCaseTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDpatientCaseTableViewCell.h"
#import "IDMedicaledModel.h"



@interface IDpatientCaseTableViewCell()

// 名字
@property (nonatomic, strong) UILabel *nameLabel;

// 性别
@property (nonatomic, strong) UIImageView *sexImageView;

// 创建日期
@property (nonatomic, strong) UILabel *dateLabel;

// 是谁创建的
@property (nonatomic, strong) UILabel *whoCreactLabel;

// 详细的信息
@property (nonatomic, strong) UILabel *detailLabels;


@end


@implementation IDpatientCaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}


- (void)setupUI
{
    // 姓名
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        
    }];
    
    // 性别
    [self.contentView addSubview:self.sexImageView];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nameLabel.right).with.offset(5);
        make.top.equalTo(self.contentView).with.offset(15);
        make.size.equalTo(CGSizeMake(17, 17));
    }];
    
    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.sexImageView.right).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(15);
        make.size.equalTo(CGSizeMake(1, 18));
    }];

    // 日期
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(segment.right).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(15);
        
    }];
    
    
    // 谁创建的
    [self.contentView addSubview:self.whoCreactLabel];
    [self.whoCreactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.right).with.offset(8);
        make.top.equalTo(self.contentView).with.offset(15);
        
    }];
    
    // 详情
    [self.contentView addSubview:self.detailLabels];
    [self.detailLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.nameLabel.bottom).with.offset(13);
        make.right.equalTo(self.contentView).with.offset(-5);
    }];
    
    // 分割线
    UIView *segment1 = [[UIView alloc] init];
    segment1.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment1];
    [segment1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];

}


- (void)getCellWithModel:(IDMedicaledModel *)model
{
    self.nameLabel.text = model.patient_name;
    
    if ([model.patient_sex isEqualToString:@"男"]) {
        
        self.sexImageView.image = [UIImage imageNamed:@"myHavePatient_male"];
    } else {
    
        self.sexImageView.image = [UIImage imageNamed:@"myHavePatient_fmale"];
    }
    
    NSArray *array = [model.updated_at componentsSeparatedByString:@"-"];
    
    NSString *day = [array[2] substringToIndex:2];
    
    NSString *year = [array[0] substringFromIndex:2];

    self.dateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",year,array[1],day];
    
    self.whoCreactLabel.text = [NSString stringWithFormat:@"%@创建", model.creater];
    self.detailLabels.text = model.medical_name;
    
}

#pragma mark - 懒加载
// 姓名
-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = UIColorFromRGB(0x353d3f);
    }
    
    return _nameLabel;
}

// 性别
- (UIImageView *)sexImageView
{
    if (_sexImageView == nil) {
        
        _sexImageView = [[UIImageView alloc] init];
        
    }
    
    return _sexImageView;
}


// 日期
- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:13.0f];
        _dateLabel.textColor = UIColorFromRGB(0x72c2ef);
    }
    
    return _dateLabel;
}

// 谁创建的
- (UILabel *)whoCreactLabel
{
    if (_whoCreactLabel == nil) {
        
        _whoCreactLabel = [[UILabel alloc] init];
        _whoCreactLabel.font = [UIFont systemFontOfSize:13.0f];
        _whoCreactLabel.textColor = UIColorFromRGB(0x72c2ef);
    }
    
    return _whoCreactLabel;
}

// 详情
- (UILabel *)detailLabels
{
    if (_detailLabels == nil) {
        
        _detailLabels = [[UILabel alloc] init];
        _detailLabels.font = [UIFont systemFontOfSize:14];
        _detailLabels.textColor = UIColorFromRGB(0xa8a8aa);
    }
    
    return _detailLabels;
}


@end
