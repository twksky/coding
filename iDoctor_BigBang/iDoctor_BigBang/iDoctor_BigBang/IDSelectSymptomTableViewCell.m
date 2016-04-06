//
//  IDSelectSymptomTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/13.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDSelectSymptomTableViewCell.h"

#import "IDDoctorIsGoodAtDiseaseModel.h"

@interface IDSelectSymptomTableViewCell()

// 背景
@property (nonatomic, strong) UIView *bgView;

// 疾病  或者  体征 的 名字
@property (nonatomic, strong) UILabel *nameLabel;

// 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;

//
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation IDSelectSymptomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

// 创建病例
- (void)setupUI
{
    UIView *contentView = self.contentView;
    // 背景
    [contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15);
        make.top.equalTo(contentView).with.offset(5);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 40));
        
    }];
    
    
    // 名字
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgView).with.offset(10);
        make.top.equalTo(self.bgView).with.offset(5);
    }];
    
    // 删除按钮
    [self.bgView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.bgView).with.offset(0);
        make.top.equalTo(self.bgView).with.offset(0);
        make.size.equalTo(CGSizeMake(40, 40));
        
    }];
    
}


#pragma mark - 懒加载
- (UIView *)bgView
{
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 3.0f;
        
    }
    
    return _bgView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    
    return _nameLabel;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"regist_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _deleteButton;
}

- (void)deleteButtonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(deleteButtonClicked:indexPath:)]) {
        
        [self.delegate deleteButtonClicked:button indexPath:self.indexPath];
    }
    
}




+ (IDSelectSymptomTableViewCell *)cellWithTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexpath
{
    static NSString *ident = @"SelectSymptomTableViewCell";
    IDSelectSymptomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[IDSelectSymptomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    
    return cell;
    
}


- (void)createCellWithModel:(IDDoctorIsGoodAtDiseaseModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    self.nameLabel.text = model.name;
    
    if (model.type == 1) { // 疾病
        
        self.bgView.backgroundColor = UIColorFromRGB(0x679ae7);
        
    } else if (model.type == 2) { // 体征
        
        self.bgView.backgroundColor = UIColorFromRGB(0x67cae7);
        
    }
    
}


@end
