//
//  RatioView.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/7/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RatioView.h"
#import "CloseButton.h"
#import "IWantPatientDataManger.h"
#define kLineWith 50
#define kOffset 30

@interface RatioView ()
@property(nonatomic, strong) UIButton *topBtn;
@property(nonatomic, strong) UILabel *numLabel;

@property(nonatomic, strong) CloseButton *clB;

@property(nonatomic, strong) RecruitDetail *recruitDetail;
@end

@implementation RatioView

- (void)setDataWithRecruitDetail:(RecruitDetail *)recruitDetail
{
    self.recruitDetail = recruitDetail;
    [self.topBtn setTitle:[NSString stringWithFormat:@"已有%ld人",recruitDetail.patient_count] forState:UIControlStateNormal];
    self.numLabel.text = [NSString stringWithFormat:@"%ld",recruitDetail.need_people];
    self.clB.enabled = !recruitDetail.is_closed;
}
- (void)setCloseBtnClickBlock:(CloseBtnClickBlock)closeBtnClickBlock
{
    _closeBtnClickBlock = closeBtnClickBlock;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self setUpAllViews];
    }
    return self;
}

- (void)setUpAllViews
{
    self.backgroundColor = [UIColor clearColor];
    
    self.topBtn = [[UIButton alloc] init];
//    _topBtn.backgroundColor = GDRandomColor;
    _topBtn.layer.cornerRadius = 3;
    _topBtn.titleLabel.font = GDFont(15);
    [_topBtn setTitle:@"已有500人" forState:UIControlStateNormal];
    _topBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [_topBtn setTintColor:[UIColor whiteColor]];
    [_topBtn setBackgroundImage:[UIImage imageNamed:@"buble"] forState:UIControlStateNormal];
    [self addSubview:_topBtn];
    [_topBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self).offset(24);
        make.top.equalTo(self);
        make.width.equalTo(80);
        make.height.equalTo(30);
    }];
    
    UIView *wrap = [[UIView alloc] init];
//    wrap.backgroundColor = GDRandomColor;
    [self addSubview:wrap];
    [wrap makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-kOffset);
        make.width.equalTo(80);
        make.height.equalTo(40);
    }];
    
    UILabel *topLabel = [[UILabel alloc] init];
//    topLabel.backgroundColor = GDRandomColor;
    topLabel.text = @"需要人数";
    topLabel.font = GDFont(14);
    topLabel.textAlignment = NSTextAlignmentCenter;
    [wrap addSubview:topLabel];
    [topLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(wrap);
    }];
    
    self.numLabel = [[UILabel alloc] init];
//    _numLabel.backgroundColor = GDRandomColor;
    _numLabel.text = @"1000";
    _numLabel.font = [UIFont boldSystemFontOfSize:16];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [wrap addSubview:_numLabel];
    [_numLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topLabel.bottom);
        make.left.bottom.right.equalTo(wrap);
        make.height.equalTo(topLabel);
    }];
    
    
    self.clB = [[CloseButton alloc] init];
//    clB.backgroundColor = GDRandomColor;
    [_clB setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_clB setTitle:@"停止招募" forState:UIControlStateNormal];
    [_clB setTitleColor:kNavBarColor forState:UIControlStateNormal];

    [_clB setImage:[UIImage imageNamed:@"close_enable"] forState:UIControlStateDisabled];
    [_clB setTitle:@"已关闭" forState:UIControlStateDisabled];
        [_clB setTitleColor:UIColorFromRGB(0xdcdcdc) forState:UIControlStateDisabled];
    
    _clB.titleLabel.font = GDFont(15);
    [_clB addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_clB];
    [_clB makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.height.width.equalTo(80);
    }];
}
- (void)closeBtnClick:(UIButton *)btn
{
    if (self.closeBtnClickBlock) {
        self.closeBtnClickBlock(self.recruitDetail.ID);
    }
}




- (void)drawRect:(CGRect)rect
{
    
    CGFloat need_patient = 0.0;
    
    if (self.recruitDetail != nil) {
        
        // 需要的人数
        NSInteger needPeople = self.recruitDetail.need_people;
        
        // 现有的人数
        NSInteger patientCount = self.recruitDetail.patient_count;
        
        // 算出相应的百分比
        need_patient = patientCount/needPeople;
        
    }

    CGSize s = rect.size;
    CGPoint center = CGPointMake(s.width * 0.5, s.height * 0.5 - kOffset);
    CGFloat r = (s.height > s.width) ? s.width * 0.5 : s.height * 0.5;
    r -= (kLineWith * 0.5 + 10);
    
    CGFloat startAng = - M_PI_2;
    CGFloat endAng = 2 * M_PI + startAng;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:startAng endAngle:endAng clockwise:YES];
    // 设置线宽
    path.lineWidth = kLineWith;
    path.lineCapStyle = kCGLineCapButt;
    
    // 设置颜色
    [UIColorFromRGB(0xdae7e7) setStroke];
    
    // 绘制路径
    [path stroke];
 
    // 通过人数的多少  修改相应的值
    endAng = need_patient *2 * M_PI + startAng;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:r+5 startAngle:startAng endAngle:endAng clockwise:YES];
    // 设置线宽
    path2.lineWidth = kLineWith + 10;
    path2.lineCapStyle = kCGLineCapButt;
    
    // 设置颜色
    [UIColorFromRGB(0x36cacc) setStroke];
    
    // 绘制路径
    [path2 stroke];

}

@end
