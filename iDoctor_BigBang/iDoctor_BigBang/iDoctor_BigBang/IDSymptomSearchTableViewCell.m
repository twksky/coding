//
//  IDSymptomSearchTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDSymptomSearchTableViewCell.h"

#import "IDDoctorIsGoodAtDiseaseModel.h"

@interface IDSymptomSearchTableViewCell()

// 名字
@property (nonatomic, strong) UILabel *nameLabel;

// 增加的符号
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSIndexPath *indexPath;


@end


@implementation IDSymptomSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

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
    // 名字
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    // 相应的加号
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
    }];
    
}



- (void)createCellWithModel:(IDDoctorIsGoodAtDiseaseModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    // 名字
    self.nameLabel.text = model.name;
    
    // 名字的颜色
    if (model.type == 1) { // 疾病
        
        self.nameLabel.textColor = UIColorFromRGB(0x679ae7);
        
    } else if (model.type == 2) { // 症状
        
        self.nameLabel.textColor = UIColorFromRGB(0x67cae7);
    }
    
    
}




#pragma mark - 懒加载
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        
    }
    
    
    return _nameLabel;
}


- (UIButton *)addButton
{
    if (_addButton == nil) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"add_copy"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _addButton;
}

// 增加相应的信息的按钮
- (void)addButtonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(addButtonClicked:indexPath:)]) {
        
        [self.delegate addButtonClicked:button indexPath:self.indexPath];
    }
}

@end
