//
//  IWantPatientCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 6/26/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IWantPatientCell.h"
#import "TagView.h"
#import "PatientsModel.h"
#import "IDMedicaledModel.h"

#import "IDMedicalLabelModel.h"
#import "IDMedicalDoctorModel.h"

#define kLineColor UIColorFromRGB(0xeaeaea)
@interface IWantPatientCell ()

@property(nonatomic, strong) UIView *wrapView;

// ** 患病程度 */
@property(nonatomic, strong) UIImageView *illNessLevelView;
// ** 顶部 */
@property(nonatomic, strong) UIView *topView;
// ** 头像 */
@property(nonatomic, strong) UIButton *avatarBtn;
@property(nonatomic, strong) UIButton *posBtn;
// ** 底部横线 */
@property(nonatomic, strong) UIView *bottomLine;

// ** 患者需求 */
@property(nonatomic, strong) UILabel *patientDemandLabel;
// ** 标签 */
@property(nonatomic, strong) TagView *tagView;

// ** 病历来源  */
@property(nonatomic, strong) UIView *caseSourceView;

// ** 病历来自  */
@property(nonatomic, strong) UIButton *caseSourceBtn;
// ** 病历来源中间的分割线 */
@property(nonatomic, strong) UIView *caseLine;
// ** 病历来自医院  */
@property(nonatomic, strong) UIButton *caseSourceHospitalBtn;
// ** 底部 */
@property(nonatomic, strong) UIView *bottomView;
// ** 时间 */
@property(nonatomic, strong) UILabel *timeLabel;
// ** 病名 */
@property(nonatomic, strong) UILabel *illnessName;

// ** 性别 */
@property(nonatomic, strong) UIButton *sexImageBtn;
// ** 年龄 */
@property(nonatomic, strong) UILabel *ageLable;

// ** 医生意见 */
@property(nonatomic, strong) UIButton *docIdeaBtn;

// ** 接洽状态 */
@property(nonatomic, strong) UIButton *inceptStateBtn;

/**
 *  patientModel
 */
@property (nonatomic, strong) PatientModel *patientModel;

/**
 *  medicalModel
 */
@property (nonatomic, strong) IDMedicaledModel *mediacalModel;


@end
static CGFloat tagHeight;
static CGFloat demandHeight;
@implementation IWantPatientCell

+ (CGFloat)height
{
    
    return 190.0 + tagHeight + demandHeight;
}


- (void)setAvatarClickBlock:(AvatarClickBlock)avatarClickBlock
{
    _avatarClickBlock = avatarClickBlock;
}
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = IWantPatientCellMargin;
    frame.origin.y += IWantPatientCellMargin;
    frame.size.width -= IWantPatientCellMargin * 2;
    frame.size.height -= IWantPatientCellMargin;
    [super setFrame:frame];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *reuseId = @"IWantPatientCell";
    
    IWantPatientCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[IWantPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = IWantPatientCellSelectedColor;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.patientModel = nil;
        self.mediacalModel= nil;
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self setUpAllViews];
    }
    return self;
}

- (void)setUpAllViews
{
    // cell基本设置
    [self cellBaseSetting];
    
    // 顶部
    [self setUpTopView];
    
    // 患者需求
    [self setUpPatientDemand];
    
    // 标签
    [_wrapView addSubview:self.tagView];
    //    _tagView.backgroundColor = [UIColor lightGrayColor];
    
    // 病历来源
    [self setUpCaseSourceView];
    
    // 底部
    [self setUpBottomView];
}

- (void)cellBaseSetting
{
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = kLineColor.CGColor;
    
    // 患病程度
    self.illNessLevelView = [[UIImageView alloc] init];
    _illNessLevelView.image = [UIImage imageNamed:@"illNess_Light"];
    _illNessLevelView.layer.cornerRadius = 3;
    
    [self.contentView addSubview:_illNessLevelView];
    [_illNessLevelView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.equalTo(self.contentView);
        make.width.height.equalTo(30);
    }];
    
    // 底部分割线
    self.bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = kLineColor;
    
    [self.contentView addSubview:_bottomLine];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.bottom).offset(-50);
        make.height.equalTo(1);
    }];
    
    // wrapView
    self.wrapView = [[UIView alloc] init];
    [self.contentView addSubview:_wrapView];
    [_wrapView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}
- (void)setUpPatientDemand
{
    // 患者需求
    self.patientDemandLabel = [[UILabel alloc] init];
    _patientDemandLabel.numberOfLines = 2;
    _patientDemandLabel.textColor = UIColorFromRGB(0x353d3f);
    _patientDemandLabel.font = GDFont(16);
    //    _patientDemandLabel.backgroundColor = [UIColor lightGrayColor];
    
    [_wrapView addSubview:_patientDemandLabel];
    [_patientDemandLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView.bottom).offset(15);
        make.left.right.equalTo(_wrapView);
    }];
}
- (void)setUpCaseSourceView
{
    // 病历来源
    self.caseSourceView = [[UIView alloc] init];
    //    _caseSourceView.backgroundColor = GDRandomColor;
    
    [_wrapView addSubview:_caseSourceView];
    [_caseSourceView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_wrapView);
        make.bottom.equalTo(_bottomLine).offset(-15);
        make.height.equalTo(20);
    }];
    
    // 病历来自
    self.caseSourceBtn = [self createBtnWithImage:[UIImage imageNamed:@"case_history"] Title:@"该病例来自患房价打开者"];
    _caseSourceBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    
    //    _caseSourceBtn.backgroundColor = GDRandomColor;
    //    _caseSourceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_caseSourceView addSubview:_caseSourceBtn];
    [_caseSourceBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.equalTo(_caseSourceView);
        make.width.lessThanOrEqualTo((App_Frame_Width - 80)/2);
    }];
    
    // 分割竖线
    self.caseLine = [[UIView alloc] init];
    _caseLine.backgroundColor = kLineColor;
    
    [_caseSourceView addSubview:_caseLine];
    [_caseLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_caseSourceView).offset(5);
        make.bottom.equalTo(_caseSourceView);
        make.left.equalTo(_caseSourceBtn.right).offset(5);
        make.width.equalTo(1);
    }];
    
    // 来自医院
    self.caseSourceHospitalBtn = [self createBtnWithImage:[UIImage imageNamed:@"wantP_Hospital"] Title:@"保定第一医院"];
    //    _caseSourceHospitalBtn.backgroundColor = GDRandomColor;
    _caseSourceHospitalBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    
    [_caseSourceView addSubview:_caseSourceHospitalBtn];
    [_caseSourceHospitalBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(_caseSourceView);
        make.left.equalTo(_caseLine.right).offset(5);
        make.width.lessThanOrEqualTo((App_Frame_Width - 80)/2);
    }];
    
}
- (void)setUpBottomView
{
    self.bottomView = [[UIView alloc] init];
    //    _bottomView.backgroundColor = [UIColor lightGrayColor];
    
    [_wrapView addSubview:_bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(_wrapView);
        make.height.equalTo(20);
    }];
    
    // 右面箭头
    UIButton *next = [[UIButton alloc] init];
    [next setImage:[UIImage imageNamed:@"wantP_next"] forState:UIControlStateNormal];
    [_bottomView addSubview:next];
    
    [next makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.equalTo(_bottomView);
    }];
    
    // 医生意见
    self.docIdeaBtn = [self createBtnWithImage:[UIImage imageNamed:@"wantP_Doctor"]
                                         Title:@"有5个医生意见"];
    
    [_bottomView addSubview:_docIdeaBtn];
    [_docIdeaBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.equalTo(_bottomView);
        make.width.lessThanOrEqualTo((App_Frame_Width - 80)/2);
    }];
    
    // 分割竖线
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = kLineColor;
    
    [_bottomView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_bottomView).offset(3);
        make.bottom.equalTo(_bottomView);
        make.left.equalTo(_docIdeaBtn.right).offset(5);
        make.width.equalTo(1);
    }];
    
    // 接洽状态
    self.inceptStateBtn = [self createBtnWithImage:nil Title:@"尚未接治"];
    
    
    [_bottomView addSubview:_inceptStateBtn];
    [_inceptStateBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(_bottomView);
        make.left.equalTo(lineV.right).offset(5);
        make.width.lessThanOrEqualTo((App_Frame_Width - 80)/2);
    }];
}
- (void)setUpTopView
{
    self.topView = [[UIView alloc] init];
    //    _topView.backgroundColor = [UIColor lightGrayColor];
    
    [_wrapView addSubview:_topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(_wrapView);
        make.right.equalTo(self.illNessLevelView.left).offset(15);
        make.height.equalTo(40);
    }];
    
    // 头像
    self.avatarBtn = [[UIButton alloc] init];
    //    _avatarBtn.backgroundColor = GDRandomColor;
    _avatarBtn.layer.cornerRadius = 20;
    [_avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_avatarBtn setImage:[UIImage imageNamed:@"myHavePatient_myCard"] forState:UIControlStateNormal];
    [_topView addSubview:_avatarBtn];
    [_avatarBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.equalTo(_topView);
        make.width.equalTo(40);
    }];
    
    // 病名
    self.illnessName = [[UILabel alloc] init];
    //    _illnessName.backgroundColor = GDRandomColor;
    _illnessName.font = [UIFont boldSystemFontOfSize:15];
    _illnessName.text = @"水了附近的快乐放假了都是是附近的数量飞";
    
    [_topView addSubview:_illnessName];
    [_illnessName makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView);
        make.left.equalTo(_avatarBtn.right).offset(10);
        make.width.lessThanOrEqualTo(100);
    }];
    
    // 性别
    self.sexImageBtn = [[UIButton alloc] init];
    //    _sexImageBtn.backgroundColor = GDRandomColor;
    //    _sexImageBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    //    [_sexImageBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [_topView addSubview:_sexImageBtn];
    [_sexImageBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView).offset(3);
        make.left.equalTo(_illnessName.right).offset(3);
        make.width.height.equalTo(13);
    }];
    
    // 分割竖线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    
    [_topView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView).offset(3);
        make.left.equalTo(_sexImageBtn.right).offset(5);
        make.width.equalTo(1);
        make.height.equalTo(14);
    }];
    
    // 岁数
    self.ageLable = [[UILabel alloc] init];
    //    _ageLable.backgroundColor = GDRandomColor;
    _ageLable.text = @"36岁";
    _ageLable.font = GDFont(14);
    
    [_topView addSubview:_ageLable];
    [_ageLable makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView).offset(1);
        make.left.equalTo(line.right).offset(5);
    }];
    
    //    // 时间
    self.timeLabel = [[UILabel alloc] init];
    //    _timeLabel.backgroundColor = GDRandomColor;
    _timeLabel.font = GDFont(11);
    _timeLabel.text = @"15/6/19";
    _timeLabel.textColor = UIColorFromRGB(0xa8a8aa);
    [_topView addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_topView);
        make.left.equalTo(_illnessName);
    }];
    
    // 地点
    self.posBtn = [[UIButton alloc] init];
    //    _posBtn.backgroundColor = GDRandomColor;
    [_posBtn setTitle:@"北京北京北京北京北京" forState:UIControlStateNormal];
    [_posBtn setImage:[UIImage imageNamed:@"pos"] forState:UIControlStateNormal];
    _posBtn.titleLabel.font = GDFont(11);
    _posBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [_posBtn setTitleColor:UIColorFromRGB(0xa8a8aa) forState:UIControlStateNormal];
    [_topView addSubview:_posBtn];
    [_posBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_timeLabel.right).offset(10);
        make.bottom.equalTo(_timeLabel);
        make.height.equalTo(15);
    }];
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}
- (void)updateConstraints
{
    [self.tagView updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_patientDemandLabel.bottom).offset(10);
        make.left.right.equalTo(_wrapView);
        make.height.equalTo(self.tagView.fHeight);
    }];
    
    
    [super updateConstraints];
}


- (void)setDataWithPatientModel:(PatientModel *)patientModel
{
    self.patientModel = patientModel;
    
    tagHeight = [self.tagView setTagsWithlabelModel:patientModel.medical_label wrapWidth:(App_Frame_Width - 60)];
    
    if (patientModel.medical_rank == IllnessTypeLight) {
        
        self.illNessLevelView.image = [UIImage imageNamed:@"illNess_Light"];
    }
    
    if (patientModel.medical_rank == IllnessTypeNormal) {
        
        self.illNessLevelView.image = [UIImage imageNamed:@"illNess_Normal"];
    }

    if (patientModel.medical_rank == IllnessTypeHigh) {
        
        self.illNessLevelView.image = [UIImage imageNamed:@"illNess_High"];
    }

    
    self.patientDemandLabel.text = patientModel.patient_requirement;
    
    CGSize requestmentSize = [patientModel.patient_requirement sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    demandHeight = requestmentSize.height;
    
    self.timeLabel.text = patientModel.updated_at;

    if ([patientModel.patient_sex isEqualToString:@"男"]) {
        [self.sexImageBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    }
    if ([patientModel.patient_sex isEqualToString:@"女"]) {
        [self.sexImageBtn setImage:[UIImage imageNamed:@"women"] forState:UIControlStateNormal];
    }
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:patientModel.patient_avatar_url]
                              forState:UIControlStateNormal
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 if (image) {
                                     
                                     [self.avatarBtn setImage:[UIImage getCircleImageWithImage:image andBorderWidth:0 andBorderCorlor:0] forState:UIControlStateNormal];
                                 } else {
                                     [self.avatarBtn setImage:[UIImage imageNamed:@"myHavePatient_condition"]
                                                     forState:UIControlStateNormal];
                                 }
                             }];
    self.illnessName.text = patientModel.medical_name;
    self.ageLable.text = [NSString stringWithFormat:@"%ld岁",patientModel.patient_age];
    [self.posBtn setTitle:[NSString stringWithFormat:@"%@ %@",patientModel.patient_province, patientModel.patient_city] forState:UIControlStateNormal];
    [self.caseSourceHospitalBtn setTitle:patientModel.hospital forState:UIControlStateNormal];
    [self.caseSourceBtn setTitle:[NSString stringWithFormat:@"病历来自%@",patientModel.creater] forState:UIControlStateNormal];
    [self.docIdeaBtn setTitle:[NSString stringWithFormat:@"已有%ld个意见",patientModel.comment_count] forState:UIControlStateNormal];
    
    if (patientModel.receive_doctor_list.count != 0) { // 医生有医生接治
        
        NSString *strng = [NSString stringWithFormat:@"已有%ld个接诊意愿",patientModel.receive_doctor_list.count];
        
        [self.inceptStateBtn setTitle:strng forState:UIControlStateNormal];
    
        self.inceptStateBtn.enabled = NO;
        
    }

    
    [self updateLayout];
}


- (void)setDataWithMedicaledModel:(IDMedicaledModel *)medicaledModel
{
    self.mediacalModel = medicaledModel;
    
    tagHeight = [self.tagView setTagsWithlabelModel:medicaledModel.medical_label wrapWidth:(App_Frame_Width - 60)];
    
    if (medicaledModel.medical_rank == IllnessTypeLight) {
        
        self.illNessLevelView.image = [UIImage imageNamed:@"illNess_Light"];
    }
    
    if (medicaledModel.medical_rank == IllnessTypeNormal) {
        
        self.illNessLevelView.image = [UIImage imageNamed:@"illNess_Normal"];
    }
    
    if (medicaledModel.medical_rank == IllnessTypeHigh) {
        
        self.illNessLevelView.image = [UIImage imageNamed:@"illNess_High"];
    }
    
    
    self.patientDemandLabel.text = medicaledModel.patient_requirement;
    CGSize requestmentSize = [medicaledModel.patient_requirement sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    demandHeight = requestmentSize.height;
    
    
    self.timeLabel.text = [medicaledModel.updated_at substringToIndex:19];
    // GDLog(@"%@",patientModel.patient_sex);
    if ([medicaledModel.patient_sex isEqualToString:@"男"]) {
        [self.sexImageBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    }
    if ([medicaledModel.patient_sex isEqualToString:@"女"]) {
        [self.sexImageBtn setImage:[UIImage imageNamed:@"women"] forState:UIControlStateNormal];
    }
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:medicaledModel.patient_avatar_url]
                              forState:UIControlStateNormal
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 if (image) {
                                     
                                     [self.avatarBtn setImage:[UIImage getCircleImageWithImage:image andBorderWidth:0 andBorderCorlor:0] forState:UIControlStateNormal];
                                 } else {
                                     [self.avatarBtn setImage:[UIImage imageNamed:@"myHavePatient_condition"]
                                                     forState:UIControlStateNormal];
                                 }
                             }];
    self.illnessName.text = medicaledModel.medical_name;
    self.ageLable.text = [NSString stringWithFormat:@"%ld岁",medicaledModel.patient_age];
    [self.posBtn setTitle:[NSString stringWithFormat:@"%@ %@",medicaledModel.patient_province, medicaledModel.patient_city] forState:UIControlStateNormal];
    [self.caseSourceHospitalBtn setTitle:medicaledModel.hospital forState:UIControlStateNormal];
    [self.caseSourceBtn setTitle:[NSString stringWithFormat:@"病历来自%@",medicaledModel.creater] forState:UIControlStateNormal];
    [self.docIdeaBtn setTitle:[NSString stringWithFormat:@"已有%ld个意见",medicaledModel.comment_count] forState:UIControlStateNormal];
    
    if (medicaledModel.receive_doctor_list.count != 0) { // 医生有医生接治
        
        NSString *strng = [NSString stringWithFormat:@"已有%ld个接诊意愿",medicaledModel.receive_doctor_list.count];
        
        [self.inceptStateBtn setTitle:strng forState:UIControlStateNormal];
        
        self.inceptStateBtn.enabled = NO;
        
    }
    
    [self updateLayout];
    
}


- (void)updateLayout
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
}

- (UIButton *)createBtnWithImage:(UIImage *)image Title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    btn.titleLabel.font = GDFont(15);
    btn.titleEdgeInsets = UIEdgeInsetsMake(5, 2, 0, -2);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x89c997) forState:UIControlStateNormal];
    
    return btn;
}
- (void)avatarBtnClick
{
    if (self.avatarClickBlock) {
        self.avatarClickBlock(self.patientModel, self.mediacalModel);
    }
}
- (TagView *)tagView
{
    if (_tagView == nil) {
        _tagView = [[TagView alloc] init];
        
    }
    return _tagView;
}

@end
