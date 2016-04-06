//
//  IDPatientCaseCommentTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCaseCommentTableViewCell.h"
#import "IDPatientMedicalsModel.h"
#import "IDPatientMedicalsCommentsModel.h"

#import "Account.h"

@interface IDPatientCaseCommentTableViewCell()

#pragma mark - 第2组  每个元素 评论
// 头像
@property (nonatomic, strong) UIImageView *commentIconImage;
// 姓名
@property (nonatomic, strong) UILabel *commentNameLabel;
// 评论者等级
@property (nonatomic, strong) UILabel *commentMainLabel;
// 医院
@property (nonatomic, strong) UILabel *commentHospitalLabel;
// 职称
@property (nonatomic, strong) UILabel *commentProfessionalLabel;
// 详情
@property (nonatomic, strong) UILabel *commentDetailLabel;
// 时间
@property (nonatomic, strong) UILabel *commentTimeLabel;

@end

@implementation IDPatientCaseCommentTableViewCell

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
        
        [self setupUIComment];
    }
    
    return self;
}

- (void)setupUIComment
{
    UIView *segment1 = [[UIView alloc] init];
    segment1.backgroundColor = UIColorFromRGB(0xd3d3d4);
    [self.contentView addSubview:segment1];
    [segment1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(0);
        make.top.equalTo(self.contentView).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 0.5));
        
    }];
    
    // 头像
    [self.contentView addSubview:self.commentIconImage];
    [self.commentIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15.0f);
        make.top.equalTo(self.contentView).with.offset(15.0f);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    // 名字
    [self.contentView addSubview:self.commentNameLabel];
    [self.commentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.commentIconImage.right).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(15.0f);
//        make.height.equalTo(15);
    }];
    
    // 什么医生
    [self.contentView addSubview:self.commentMainLabel];
    [self.commentMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.commentNameLabel.right).with.offset(9);
        make.top.equalTo(self.contentView).with.offset(15.0f);
        
    }];
    
    
    // 时间
    [self.contentView addSubview:self.commentTimeLabel];
    [self.commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
    
    
    // 医院
    [self.contentView addSubview:self.commentHospitalLabel];
    [self.commentHospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.commentIconImage.right).with.offset(10.0f);
        make.top.equalTo(self.commentNameLabel.bottom).with.offset(15.0f);
        
    }];
    
    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xd3d3d4);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.commentHospitalLabel.right).with.offset(7);
        make.top.equalTo(self.commentNameLabel.bottom).with.offset(15.0f);
        make.size.equalTo(CGSizeMake(1, 16));
        
    }];

    // 职称
    [self.contentView addSubview:self.commentProfessionalLabel];
    [self.commentProfessionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(segment.right).with.offset(7);
        make.top.equalTo(self.commentNameLabel.bottom).with.offset(15.0f);
    }];
    
    // 评论详情
    [self.contentView addSubview:self.commentDetailLabel];
    [self.commentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.commentIconImage.bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        
    }];
    
    
    
    
}

// 评论
- (void)dataCellCommentWithModel:(IDPatientMedicalsModel *)model row:(NSInteger)row
{
    NSArray *array = model.comments;
    
    IDPatientMedicalsCommentsModel *commentsModel = array[row];
    
    Account *doctorModel = commentsModel.doctor;
    
    // 头像
    [self.commentIconImage sd_setImageWithURL:[NSURL URLWithString:doctorModel.avatar_url] placeholderImage:[UIImage imageNamed:@"wantP_avatar"]];
    
    // 名字
    self.commentNameLabel.text = doctorModel.realname;
    
    // 头衔
    self.commentMainLabel.text = doctorModel.title;
    
    // 医院
    self.commentHospitalLabel.text = doctorModel.hospital;
    
    // 科室
    self.commentProfessionalLabel.text = [NSString stringWithFormat:@" %@",doctorModel.department];
    
    // 评论
    self.commentDetailLabel.text = commentsModel.comment_descreption;
   
}


// 评论
- (void)dataCellCommentWithModel:(IDPatientMedicalsCommentsModel *)model
{

    Account *doctorModel = model.doctor;
    
    // 头像
    [self.commentIconImage sd_setImageWithURL:[NSURL URLWithString:doctorModel.avatar_url] placeholderImage:[UIImage imageNamed:@"wantP_avatar"]];
    
    // 名字
    self.commentNameLabel.text = doctorModel.realname;
    
    // 头衔
    self.commentMainLabel.text = doctorModel.title;
    
    // 医院
    self.commentHospitalLabel.text = doctorModel.hospital;
    
    // 科室
    self.commentProfessionalLabel.text = [NSString stringWithFormat:@" %@",doctorModel.department];
    
    // 评论
    self.commentDetailLabel.text = model.comment_descreption;
    
    // 时间
    NSString *dateString = [model.created_at substringToIndex:16];
    NSArray *array = [dateString componentsSeparatedByString:@"-"];
    self.commentTimeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",array[0],array[1],array[2]];
}


#pragma mark - 第2组  每个元素 评论
// 头像
- (UIImageView *)commentIconImage
{
    if (_commentIconImage == nil) {
        
        _commentIconImage = [[UIImageView alloc] init];
        _commentIconImage.layer.masksToBounds = YES;
        _commentIconImage.layer.cornerRadius = 25.0f;
    }
    
    return _commentIconImage;
}

// 姓名
- (UILabel *)commentNameLabel
{
    if (_commentNameLabel == nil) {
        
        _commentNameLabel = [[UILabel alloc] init];
        _commentNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _commentNameLabel.textColor = UIColorFromRGB(0x353d3f);
        
    }
    
    return _commentNameLabel;
}

// 评论者等级
- (UILabel *)commentMainLabel
{
    if (_commentMainLabel == nil) {
        
        _commentMainLabel = [[UILabel alloc] init];
        _commentMainLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentMainLabel.textColor = UIColorFromRGB(0xa8a8aa);
        
    }
    return _commentMainLabel;
    
}

// 医院
- (UILabel *)commentHospitalLabel
{
    if (_commentHospitalLabel == nil) {
        
        _commentHospitalLabel = [[UILabel alloc] init];
        _commentHospitalLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentHospitalLabel.textColor = UIColorFromRGB(0xa8a8aa);
        
    }
    return _commentHospitalLabel;
    
}

// 职称
- (UILabel *)commentProfessionalLabel
{
    if (_commentProfessionalLabel == nil) {
        
        _commentProfessionalLabel = [[UILabel alloc] init];
        _commentProfessionalLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentProfessionalLabel.textColor = UIColorFromRGB(0xa8a8aa);
        
    }
    return _commentProfessionalLabel;
}

// 详情
- (UILabel *)commentDetailLabel
{
    if (_commentDetailLabel == nil) {
        
        _commentDetailLabel = [[UILabel alloc] init];
        _commentDetailLabel.font = [UIFont systemFontOfSize:14.0f];
        _commentDetailLabel.textColor = UIColorFromRGB(0x353d3f);
        _commentDetailLabel.numberOfLines = 3;
        
    }
    return _commentDetailLabel;
    
}

// 时间
- (UILabel *)commentTimeLabel
{
    if (_commentTimeLabel == nil) {
        
        _commentTimeLabel = [[UILabel alloc] init];
        _commentTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _commentTimeLabel.textColor = UIColorFromRGB(0xc9c9ca);
        
    }
    
    return _commentTimeLabel;
}



@end
