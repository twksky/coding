//
//  IDPatientCaseDetailTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/19.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCaseDetailTableViewCell.h"
#import "IDPatientMedicalsModel.h"
#import "IDGetPatientInformation.h"
#import "IDMedicaledModel.h"
#import "IDMedicalDoctorModel.h"
#import "IDPatientMedicalsCommentsModel.h"
#import "Account.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSInteger num = 0;
@interface IDPatientCaseDetailTableViewCell()

#pragma mark - 第0组  第0个元素
// 头像
@property (nonatomic, strong) UIImageView *patientIconImage;
// 名字
@property (nonatomic, strong) UILabel *patientNameLabel;
// 性别标识
@property (nonatomic, strong) UIImageView *patientSexImage;
// 年龄
@property (nonatomic, strong) UILabel *patientAgeLabel;
// 地区
@property (nonatomic, strong) UIButton *patientrRegionButton;


#pragma mark - 第0组  第1个元素
// 主治医生
@property (nonatomic, strong) UILabel *doctorMainDoctorLabel;
// 医生名字
@property (nonatomic, strong) UILabel *doctorNameLabel;
// 医生所在的单位
@property (nonatomic, strong) UILabel *doctorHospitalLabel;
// 医生的职称
@property (nonatomic, strong) UILabel *doctorProfessionalLabel;
// 分割线
@property (nonatomic, strong) UIView *segment;


@end

static CGFloat height = 0;
@implementation IDPatientCaseDetailTableViewCell


- (void)awakeFromNib {
    // Initialization code
}


// webView 的高度
+ (CGFloat)height
{
    return height;
}


- (void)setupUIWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
    
        if (row == 0) { // 患者
            
            [self setupUIPatient];
            
        } else { // 医生
        
            [self setupUIDoctor];
        
        }
        
    } else if (section == 1) {
    
        [self setupUIWebView];
    
    } else if (section == 2) {
        
    
    
    }
 
}


#pragma mark - 方法
- (void)setupUIPatient
{
    // 患者头像
    [self.contentView addSubview:self.patientIconImage];
    [self.patientIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15.0f);
        make.top.equalTo(self.contentView).with.offset(15.0f);
        make.size.equalTo(CGSizeMake(60.0f, 60.0f));
    }];
    
    // 患者名字
    [self.contentView addSubview:self.patientNameLabel];
    [self.patientNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(15 + 12);
        make.left.equalTo(self.patientIconImage.right).with.offset(15.0f);
        
    }];
    
    // 患者的性别
    [self.contentView addSubview:self.patientSexImage];
    [self.patientSexImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.patientNameLabel.right).with.offset(5);
        make.top.equalTo(self.contentView).with.offset(15 + 12);
        make.size.equalTo(CGSizeMake(16, 16));
        
    }];
    
    // 患者年龄
    [self.contentView addSubview:self.patientAgeLabel];
    [self.patientAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.patientSexImage.right).with.offset(20);
        make.top.equalTo(self.contentView).with.offset(15 + 12);
        
    }];
    
    // 患者地区
    [self.contentView addSubview:self.patientrRegionButton];
    [self.patientrRegionButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.patientIconImage.right).with.offset(15);
        make.top.equalTo(self.patientNameLabel.bottom).with.offset(12);
        // make.size.equalTo(CGSizeMake((App_Frame_Width - 15 - 15 - 60) / 2, 17.0));
        
    }];

    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
}


- (void)setupUIDoctor
{
    // 字样
    [self.contentView addSubview:self.doctorMainDoctorLabel];
    [self.doctorMainDoctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15.0f);
        make.top.equalTo(self.contentView).with.offset(27.0f);
        
    }];
    
    // 主治医生
    [self.contentView addSubview:self.doctorNameLabel];
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.doctorMainDoctorLabel.right).with.offset(9);
        make.top.equalTo(self.contentView).with.offset(27);
        
    }];
    
    // 医院
    [self.contentView addSubview:self.doctorHospitalLabel];
    [self.doctorHospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15.0f);
        make.top.equalTo(self.doctorMainDoctorLabel.bottom).with.offset(12.0f);
        
    }];
    
    // 分割线
    self.segment = [[UIView alloc] init];
    self.segment.backgroundColor = UIColorFromRGB(0xd3d3d4);
    [self.contentView addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.doctorHospitalLabel.right).with.offset(9);
        make.top.equalTo(self.doctorMainDoctorLabel.bottom).with.offset(12.0f);
        make.size.equalTo(CGSizeMake(1, 17));
        
    }];
    
    // 科室
    [self.contentView addSubview:self.doctorProfessionalLabel];
    [self.doctorProfessionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.segment.right).with.offset(9);
        make.top.equalTo(self.doctorMainDoctorLabel.bottom).with.offset(12.0f);
        
    }];
    
    
}


- (void)setupUIWebView
{
    [self.contentView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.contentView);
        
    }];
}



// 根据不同的行  加载不同的东西
- (void)dataCellWithModel:(IDPatientMedicalsModel *)model indexpath:(NSIndexPath *)indexpath
{
    NSInteger section = indexpath.section;
    NSInteger row = indexpath.row;
    
    if (section == 0) {
        
        if (row == 0) { // 患者
            
            [self dataCellPatientWithModel:model];
            
        } else { // 医生
            
            [self dataCellDoctorWithModel:model];
            
        }
        
    } else if (section == 1) {
        
        [self dataCellWebViewWithModel:model];
        
    } else if (section == 2) {        
    }
}

// 患者
- (void)dataCellPatientWithModel:(IDPatientMedicalsModel *)model
{
    IDGetPatientInformation *infoModel = model.patient_info;
    
    // 头像
    [self.patientIconImage sd_setImageWithURL:[NSURL URLWithString:infoModel.avatar_url] placeholderImage:[UIImage imageNamed:@"fmale"]];
    
    // 名字
    self.patientNameLabel.text = infoModel.realname;
    
    // 性别
    if ([infoModel.sex isEqualToString:@"男"]) {
        
        self.patientSexImage.image = [UIImage imageNamed:@"man"];
        
    } else {
    
        self.patientSexImage.image = [UIImage imageNamed:@"myHavePatient_fmale"];
    }
    
    // 年龄
    self.patientAgeLabel.text = [NSString stringWithFormat:@"%ld岁",infoModel.age];
    
    // 省市
    if (!infoModel.region || [infoModel.region isEqualToString:@""]) {
        
        self.patientrRegionButton.hidden = YES;
    } else {
        
        self.patientrRegionButton.hidden = NO;
        [self.patientrRegionButton setTitle:infoModel.region forState:UIControlStateNormal];
    }

}

// 医生
- (void)dataCellDoctorWithModel:(IDPatientMedicalsModel *)model
{
    IDMedicaledModel *doctorModel = model.patient_medical;
    self.doctorNameLabel.text = doctorModel.creater;
    
    if ([doctorModel.creater isEqualToString:@"患者"]) {
        
        self.segment.hidden = YES;
        
    } else {
    
        self.segment.hidden = NO;
        
    }
    
    
    self.doctorHospitalLabel.text = doctorModel.hospital;
    self.doctorProfessionalLabel.text = doctorModel.doctor.department;
    
}

// webview
- (void)dataCellWebViewWithModel:(IDPatientMedicalsModel *)model
{
    
    NSString *string = [NSString stringWithFormat:@"http://m.ihaoyisheng.com/medical/patient_medicals/%@/result",model.patient_medical.patient_medical_id];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];

}


#pragma mark - 懒加载

#pragma mark - 第0组  第0个元素
// 头像
- (UIImageView *)patientIconImage
{
    if (_patientIconImage == nil) {
       
        _patientIconImage = [[UIImageView alloc] init];
        _patientIconImage.layer.masksToBounds = YES;
        _patientIconImage.layer.cornerRadius = 30.0f;
        
    }
    return _patientIconImage;
}

// 名字
- (UILabel *)patientNameLabel
{
    if (_patientNameLabel == nil) {
        
        _patientNameLabel = [[UILabel alloc] init];
        _patientNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _patientNameLabel.textColor = UIColorFromRGB(0x353d3f);
        
    }
    
    return _patientNameLabel;
}

// 性别标识
- (UIImageView *)patientSexImage
{
    if (_patientSexImage == nil) {
        
        _patientSexImage = [[UIImageView alloc] init];
    }
    
    return _patientSexImage;
}

// 年龄
- (UILabel *)patientAgeLabel
{
    if (_patientAgeLabel == nil) {
       
        _patientAgeLabel = [[UILabel alloc] init];
        _patientAgeLabel.font = [UIFont systemFontOfSize:14.0f];
        _patientAgeLabel.textColor = UIColorFromRGB(0x353d3f);
        
    }
    
    return _patientAgeLabel;
}


// 地区
- (UIButton *)patientrRegionButton
{
    if (_patientrRegionButton == nil) {
        
        _patientrRegionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _patientrRegionButton.selected = NO;
        [_patientrRegionButton setImage:[UIImage imageNamed:@"pos"] forState:UIControlStateNormal];
        _patientrRegionButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_patientrRegionButton setTitleColor:UIColorFromRGB(0xa8a8aa) forState:UIControlStateNormal];
        _patientrRegionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    }
    
    return _patientrRegionButton;
}


#pragma mark - 第0组  第1个元素
// 主治医生
-(UILabel *)doctorMainDoctorLabel
{
    if (_doctorMainDoctorLabel == nil) {
     
        _doctorMainDoctorLabel = [[UILabel alloc] init];
        _doctorMainDoctorLabel.font = [UIFont systemFontOfSize:15.0f];
        _doctorMainDoctorLabel.textColor = UIColorFromRGB(0x353d3f);
        _doctorMainDoctorLabel.text = @"主治医生:";
        
    }
    return _doctorMainDoctorLabel;
}

// 医生名字
- (UILabel *)doctorNameLabel
{
    if (_doctorNameLabel == nil) {
        _doctorNameLabel = [[UILabel alloc] init];
        _doctorNameLabel.font = [UIFont systemFontOfSize:13.0f];
        _doctorNameLabel.textColor = UIColorFromRGB(0xa8a8aa);
    }
    
    return _doctorNameLabel;
}

// 医生所在的单位
- (UILabel *)doctorHospitalLabel
{
    if (_doctorHospitalLabel == nil) {
       
        _doctorHospitalLabel = [[UILabel alloc] init];
        _doctorHospitalLabel.font = [UIFont systemFontOfSize:13.0f];
        _doctorHospitalLabel.textColor = UIColorFromRGB(0xa8a8aa);
        
    }
    
    return _doctorHospitalLabel;
}

// 医生的职称
- (UILabel *)doctorProfessionalLabel
{
    if (_doctorProfessionalLabel == nil) {
       
        _doctorProfessionalLabel = [[UILabel alloc] init];
        _doctorProfessionalLabel.font = [UIFont systemFontOfSize:13.0f];
        _doctorProfessionalLabel.textColor = UIColorFromRGB(0xa8a8aa);
        
    }
    
    return _doctorProfessionalLabel;
}

#pragma mark - 第1组  每个元素
- (UIWebView *)webView
{
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] init];
        UIScrollView *tempView=(UIScrollView *)[_webView.subviews objectAtIndex:0];
        tempView.scrollEnabled=NO;
        _webView.delegate = self;
    }
    return _webView;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
     height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
   //  height = webView.scrollView.contentSize.height;
    
    if (num == 0) {
        
        _block();
        
        num += 1;
    }
   
    
}

@end
