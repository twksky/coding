//
//  IDpatientMsgBottomTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//


// 患者个人信息页面的下半部分

#import "IDpatientMsgBottomTableViewCell.h"
#import "TagView.h"

#import "IDMedicaledModel.h"
#import "IDMedicalLabelModel.h"

@interface IDpatientMsgBottomTableViewCell()

// 病历名字的图片
@property (nonatomic, strong) UIImageView *iconImage;

// 病例名字
@property (nonatomic, strong) UILabel *nameLabel;

// 创建日期
@property (nonatomic, strong) UILabel *timeLabel;

// who创建
@property (nonatomic, strong) UILabel *whoLabel;

// 是否存在补充
@property (nonatomic, strong) UILabel *supplement;

// 标签
@property (nonatomic, strong) TagView *tagView;


@end

static CGFloat tagHeight;
@implementation IDpatientMsgBottomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}

// UI搭建
- (void)setupUI
{
    // 图标
    [self.contentView addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(30);
        make.size.equalTo(CGSizeMake(17, 17));
        
    }];
    
    // 名字
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.iconImage.right).with.offset(5);
        make.top.equalTo(self.contentView).with.offset(30);
        make.width.equalTo(App_Frame_Width - 15 - 17 - 5 - 15);
        
    }];
    
    // 时间
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.iconImage.right).with.offset(5);
        make.top.equalTo(self.nameLabel.bottom).with.offset(11);
        
    }];
    
    // 创建者
    [self.contentView addSubview:self.whoLabel];
    [self.whoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.timeLabel.right).with.offset(8);
        make.top.equalTo(self.nameLabel.bottom).with.offset(11);
        
    }];
    
    // 是否有补充
    [self.contentView addSubview:self.supplement];
    [self.supplement mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.whoLabel.right).with.offset(5);
        make.top.equalTo(self.nameLabel.bottom).with.offset(11);
        make.size.equalTo(CGSizeMake(42, 17));
    }];
    
    // 标签
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.iconImage.right).with.offset(5);
        make.top.equalTo(self.timeLabel.bottom).with.offset(15);
        make.width.equalTo(App_Frame_Width - 15 - 17 - 5 - 15);
        
    }];
    
    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        make.left.equalTo(self.contentView).with.offset(37);
        make.bottom.equalTo(self.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 37, 1));
        
        
    }];

}


+ (IDpatientMsgBottomTableViewCell *)cellWithTab:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
{
    static NSString *ident = @"patientMsgBottomTableViewCell";
    
    IDpatientMsgBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[IDpatientMsgBottomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    return cell;
}


- (void)dataWithMedicalDoctorModel:(IDMedicaledModel *)model indexPath:(NSIndexPath *)indexPath
{
    // 病例名字
    self.nameLabel.text = model.medical_name;
    
    // 病例创建的时间

    NSArray *array = [[model.created_at substringToIndex:10] componentsSeparatedByString:@"-"];
    NSString *string =[NSString stringWithFormat:@"%@/%@/%@",array[0],array[1],array[2]];
    self.timeLabel.text = string;
    
    
    // 创建的人
    self.whoLabel.text = [NSString stringWithFormat:@"%@创建",model.creater];
    
    // 是否有补充
    if (model.supplement) { // 有补充
        
        self.supplement.text = @"有补充";
        self.supplement.backgroundColor = UIColorFromRGB(0x72c2ef);
        
    } else { // 没有补充
    
        self.supplement.text = @"无补充";
        self.supplement.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    }
    
    // 标签
    tagHeight = [self.tagView setTagsWithlabelModel:model.medical_label wrapWidth:App_Frame_Width - 15 - 17 - 5 - 15];

}


+ (CGFloat)height
{
    return 88 + tagHeight + 15;
}


#pragma mark - 懒加载
- (UIImageView *)iconImage
{
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"myHavePatient_diseaseCase"];
    }
    
    return _iconImage;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = UIColorFromRGB(0x353d3f);
        
    }
    
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0x72c2ef);
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _timeLabel;
}

// 创建者
- (UILabel *)whoLabel
{
    if (_whoLabel == nil) {
        
        _whoLabel = [[UILabel alloc] init];
        _whoLabel.font = [UIFont systemFontOfSize:13.0f];
        _whoLabel.textColor = UIColorFromRGB(0x72c2ef);
        
    }
    
    return _whoLabel;
}

// 是否有补充
- (UILabel *)supplement
{
    if (_supplement == nil) {
        
        _supplement = [[UILabel alloc] init];
        _supplement.textColor = [UIColor whiteColor];
        _supplement.font = [UIFont systemFontOfSize:11.0f];
        _supplement.layer.masksToBounds = YES;
        _supplement.layer.cornerRadius = 7.0f;
        _supplement.textAlignment = NSTextAlignmentCenter;
    }
    
    return _supplement;
}

- (TagView *)tagView
{
    if (_tagView == nil) {
        
        _tagView = [[TagView alloc] init];
    }
    
    return _tagView;
}


@end
