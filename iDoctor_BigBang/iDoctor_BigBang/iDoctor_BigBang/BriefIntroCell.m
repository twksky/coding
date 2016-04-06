//
//  BriefIntroCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BriefIntroCell.h"
#import "TagView.h"
#import "BriefIntroRowModel.h"
#import "IDDoctorIsGoodAtDiseaseModel.h"
@interface BriefIntroCell ()
/**
 *  头像
 */
@property(nonatomic, strong) UIImageView *avatar;
/**
 *  名字
 */
@property(nonatomic, strong) UILabel *nameLabel;
/**
 *  性别标识
 */
@property(nonatomic, strong) UIImageView *sexView;
/**
 *  性别标识
 */
@property(nonatomic, strong) UIButton *authenBtn;
/**
 *  医院名称
 */
@property(nonatomic, strong) UILabel *hospitalNameLabel;

/**
 *  职称
 */
@property(nonatomic, strong) UILabel *pTitleLabel;

@property (nonatomic, strong) TagView *tagView;

@property (nonatomic, strong) UIButton *jfBtn;
@property (nonatomic, strong) UIButton *yeBtn;

@property (nonatomic,strong) BriefIntroRowModel *briefIntro;
@end
@implementation BriefIntroCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    self.briefIntro = (BriefIntroRowModel *)model;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.briefIntro.accout.avatar_url] placeholderImage:[UIImage imageNamed:@"case_files"]];
    
    if ([self.briefIntro.accout.sex isEqualToString:@"男"]) {
        
        self.sexView.image = [UIImage imageNamed:@"man"];
    }
    if ([self.briefIntro.accout.sex isEqualToString:@"女"]) {
        
        self.sexView.image = [UIImage imageNamed:@"women"];
    }
//    if ([self.briefIntro.accout.sex isEqualToString:@""]) {
//        
//        self.sexView.image = [UIImage imageNamed:@"man"];
//    }

    self.nameLabel.text = self.briefIntro.accout.realname;
    
    NSString *hos = [NSString stringWithFormat:@"%@ | %@",self.briefIntro.accout.hospital, self.briefIntro.accout.department];
    self.hospitalNameLabel.text = hos;
    
    self.pTitleLabel.text = self.briefIntro.accout.title;
    
    NSMutableArray *arrM = [NSMutableArray array];
    [self.briefIntro.accout.skills enumerateObjectsUsingBlock:^(IDDoctorIsGoodAtDiseaseModel *sk, NSUInteger idx, BOOL *stop) {
        
        [arrM addObject:sk.name];
    }];
    [self.tagView setTagsWithTagsArr:arrM wrapWidth:App_Frame_Width - 20];

    [self.jfBtn setTitle:[NSString stringWithFormat:@"余额:%ld元",self.briefIntro.accout.balance/100] forState:UIControlStateNormal];
    [self.yeBtn setTitle:[NSString stringWithFormat:@"积分:%ld分",self.briefIntro.accout.score] forState:UIControlStateNormal];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BriefIntroCell";
    BriefIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BriefIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    UIView *superViwe = self.contentView;
//    superViwe.backgroundColor = GDRandomColor;
    // 头像
    self.avatar = [[UIImageView alloc] init];
    
    [superViwe addSubview:_avatar];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(superViwe).offset(15);
        make.left.equalTo(superViwe).offset(15);
        make.width.height.equalTo(65);
    }];
    
    // 姓名
    self.nameLabel = [self createLabelWithTextColor:UIColorFromRGB(0x353d3f) FontSize:15];
    
    [superViwe addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_avatar).offset(5);
        make.left.equalTo(_avatar.right).offset(10);
        make.width.lessThanOrEqualTo(150);
    }];
    
    // 性别标识
    self.sexView = [[UIImageView alloc] init];
    
    [superViwe addSubview:_sexView];
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel).offset(3);
        make.left.equalTo(_nameLabel.right).offset(3);
        make.width.height.equalTo(14);
    }];
    
    
    // 认证信息
    self.authenBtn = [[UIButton alloc] init];
    _authenBtn.backgroundColor = UIColorFromRGB(0xfd914f);
    [_authenBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
    [_authenBtn setTitle:@"认证" forState:UIControlStateNormal];
    _authenBtn.titleLabel.font = GDFont(10);
    _authenBtn.layer.cornerRadius = 6;
    _authenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
   
    
    [superViwe addSubview:_authenBtn];
    [_authenBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_sexView.right).offset(5);
        make.top.equalTo(_sexView);
        make.width.equalTo(40);
        make.height.equalTo(14);
    }];

    if (kAccount.checked == NO) {
        
        self.authenBtn.hidden = YES;
    }
    
    // 医院
    self.hospitalNameLabel = [self createLabelWithTextColor:UIColorFromRGB(0xa8a8aa) FontSize:12];
    
    [superViwe addSubview:_hospitalNameLabel];
    [_hospitalNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.bottom).offset(8);
        make.left.equalTo(_nameLabel);
        make.width.lessThanOrEqualTo(200);
    }];
    
    // 职称
    self.pTitleLabel = [self createLabelWithTextColor:UIColorFromRGB(0xa8a8aa) FontSize:12];
    
    [superViwe addSubview:_pTitleLabel];
    [_pTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_hospitalNameLabel.bottom).offset(1);
        make.left.equalTo(_hospitalNameLabel);
    }];
    
    // 箭头
    UIImageView *nextView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    [superViwe addSubview:nextView];
    [nextView makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(superViwe).offset(-15);
        make.top.equalTo(superViwe).offset(35);
    }];
    
    [self.tagView setTagsWithTagsArr:@[@"fjdslfjd", @"房价打开辣椒粉的啦", @"房价打的啦", @"房价的啦",@"房价辣椒粉的啦",@"房价打开啦"] wrapWidth:App_Frame_Width - 20];
    [superViwe addSubview:self.tagView];
    self.tagView.backgroundColor = GDRandomColor;
    [self.tagView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatar.bottom).offset(17);
        make.left.equalTo(self.avatar);
    }];
    
    // 积分余额
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [superViwe addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(superViwe);
        make.height.equalTo(45);
    }];
    
    self.jfBtn = [self createBtnWithTarget:self action:@selector(jfBtnClick:)];
    [_jfBtn setTitle:@"积分:60" forState:UIControlStateNormal];
    
    [bottomView addSubview:_jfBtn];
    [_jfBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(bottomView).offset(1);
        make.bottom.equalTo(bottomView);
        make.width.equalTo(App_Frame_Width/2 - 1);
    }];
    
    self.yeBtn = [self createBtnWithTarget:self action:@selector(yeBtnClick:)];
    [_yeBtn setTitle:@"余额:500" forState:UIControlStateNormal];
    [bottomView addSubview:_yeBtn];
    [_yeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self.jfBtn);
        make.right.equalTo(bottomView).offset(-1);
        make.left.equalTo(self.jfBtn.right).offset(1);
    }];
}
- (void)jfBtnClick:(UIButton *)btn
{
    if (self.briefIntro.integralBtnClickBlock) {
        self.briefIntro.integralBtnClickBlock();
    }
}
- (void)yeBtnClick:(UIButton *)btn
{
    if (self.briefIntro.balacneBtnClickBlock) {
        self.briefIntro.balacneBtnClickBlock();
    }
}

- (UILabel *)createLabelWithTextColor:(UIColor *)color FontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    return label;
}
- (UIButton *)createBtnWithTarget:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}
- (TagView *)tagView
{
    if (_tagView == nil) {
        _tagView = [[TagView alloc] init];
        _tagView.backgroundColor = [UIColor blueColor];
    }
    return _tagView;
}


@end
