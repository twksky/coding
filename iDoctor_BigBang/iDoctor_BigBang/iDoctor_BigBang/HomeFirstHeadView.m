//
//  HomeFirstHeadView.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/15.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "HomeFirstHeadView.h"
#import "TwkBtn.h"


@interface HomeFirstHeadView()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;//我要患者按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;//我有患者按钮
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLaber;//我要患者
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLaber;//疑难杂症患者
@property (weak, nonatomic) IBOutlet UILabel *rightTopLaber;//我有患者
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLaber;//推荐患者给专家
@property (weak, nonatomic) IBOutlet TwkBtn *btn1;
@property (weak, nonatomic) IBOutlet TwkBtn *btn2;
@property (weak, nonatomic) IBOutlet TwkBtn *btn3;

@end

@implementation HomeFirstHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.line.backgroundColor = UIColorFromRGB(0x44d6d8);
//    self.leftBtn.backgroundColor =[UIColor redColor];
//    self.rightBtn.backgroundColor =[UIColor orangeColor];
    self.leftTopLaber.textColor = UIColorFromRGB(0xd9feff);
    self.rightTopLaber.textColor = UIColorFromRGB(0xd9feff);
    self.leftBottomLaber.textColor = UIColorFromRGB(0xd9feff);
    self.rightBottomLaber.textColor = UIColorFromRGB(0xd9feff);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colorTrick"]];
    imageView.frame = CGRectMake(0, 0, self.bounds.size.width, 498/2);
    [self insertSubview:imageView atIndex:0];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(498/2));
    }];
    
    self.btn1.imageView.contentMode = UIViewContentModeCenter;
    self.btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn2.imageView.contentMode = UIViewContentModeCenter;
    self.btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn3.imageView.contentMode = UIViewContentModeCenter;
    self.btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btn1 titleRectForContentRect:self.btn1.frame];
    [self.btn2 titleRectForContentRect:self.btn2.frame];
    [self.btn3 titleRectForContentRect:self.btn3.frame];
    [self.btn1 imageRectForContentRect:self.btn1.frame];
    [self.btn2 imageRectForContentRect:self.btn2.frame];
    [self.btn3 imageRectForContentRect:self.btn3.frame];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftBtn.fCenter = CGPointMake(self.frame.size.width/4, 43+172/2/2);
    self.rightBtn.fCenter = CGPointMake(self.frame.size.width/4*3, 43+172/2/2);
    
    self.leftTopLaber.fCenter = CGPointMake(self.frame.size.width/4, 43/2);
    self.rightTopLaber.fCenter = CGPointMake(self.frame.size.width/4*3, 43/2);
    
    self.leftBottomLaber.fCenter = CGPointMake(self.frame.size.width/4, 43+172/2+38/2+6);
    self.rightBottomLaber.fCenter = CGPointMake(self.frame.size.width/4*3, 43+172/2+38/2+6);
    
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
}

- (IBAction)cardClick:(id)sender {
    [self.delegate cardClick:sender];
    
}
- (IBAction)selectSite:(id)sender {
    [self.delegate selectSite:sender];
}

- (IBAction)iWantToPatient:(id)sender {
    [self.delegate iWantToPatient:sender];
}

- (IBAction)iHavePatient:(id)sender {
    [self.delegate iHavePatient:sender];
}

- (IBAction)patientRecomment:(id)sender {
    [self.delegate patientRecomment:sender];
}

- (IBAction)toQuickDiagnoseVC:(id)sender {
    
    [self.delegate toQuickDiagnoseVC:sender];
}

- (IBAction)toDiseaseTag:(id)sender {
    
    [self.delegate toDiseaseTag:sender];
    
}



@end
