//
//  DoctorInfoViewPriceCellTableViewCell.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorInfoViewPriceCellTableViewCell.h"
#import "UIView+AutoLayout.h"

@interface DoctorInfoViewPriceCellTableViewCell ()

@property (nonatomic, strong) UIImageView *servicePriceIcon;
@property (nonatomic, strong) UILabel *servicePriceLabel;
@property (nonatomic, strong) UIImageView *templateIcon;
@property (nonatomic, strong) UILabel *templateLabel;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation DoctorInfoViewPriceCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    UIView *leftView = self.leftView;
    [leftView addSubview:self.servicePriceIcon];
    [leftView addSubview:self.servicePriceLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    
    UIView *rightView = self.rightView;
    [rightView addSubview:self.templateIcon];
    [rightView addSubview:self.templateLabel];
    
    [self.contentView addSubview:leftView];
    [self.contentView addSubview:line];
    [self.contentView addSubview:rightView];
    
    //AutoLayout
    //TODO 根据5s和6p来调整间距
    {
        [self.contentView addConstraint:[leftView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width / 2 - 0.5]];
        [self.contentView addConstraint:[leftView autoSetDimension:ALDimensionHeight toSize:90.0f]];
        [self.contentView addConstraint:[leftView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [self.contentView addConstraint:[leftView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
         
        
        [leftView addConstraint:[self.servicePriceIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:leftView withOffset:15.0f]];
        [leftView addConstraint:[self.servicePriceIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [leftView addConstraint:[self.servicePriceIcon autoSetDimension:ALDimensionHeight toSize:25.0f]];
        [leftView addConstraint:[self.servicePriceIcon autoSetDimension:ALDimensionWidth toSize:29.0f]];
        [leftView addConstraint:[self.servicePriceIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
        
        
        [leftView addConstraint:[self.servicePriceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.servicePriceIcon withOffset:10.0f]];
        [leftView addConstraint:[self.servicePriceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [self.contentView addConstraint:[line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftView]];
        [self.contentView addConstraint:[line autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView]];
        [self.contentView addConstraint:[line autoSetDimension:ALDimensionWidth toSize:1.0f]];
        [self.contentView addConstraint:[line autoSetDimension:ALDimensionHeight toSize:90.0f]];
        
        [self.contentView addConstraint:[rightView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line]];
        [self.contentView addConstraint:[rightView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width / 2 - 0.5]];
        [self.contentView addConstraint:[rightView autoSetDimension:ALDimensionHeight toSize:90.0f]];
        [self.contentView addConstraint:[rightView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftView]];
        [self.contentView addConstraint:[rightView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
        
        
        [rightView addConstraint:[self.templateIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:rightView withOffset:18.0f]];
        [rightView addConstraint:[self.templateIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [rightView addConstraint:[self.templateIcon autoSetDimension:ALDimensionHeight toSize:29.0f]];
        [rightView addConstraint:[self.templateIcon autoSetDimension:ALDimensionWidth toSize:22.0f]];
        
        [rightView addConstraint:[self.templateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.templateIcon withOffset:10.0f]];
        [rightView addConstraint:[self.templateLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    
}


#pragma mark - set Actions

- (void)setPriceActionWithTarget:(id)target action:(SEL)action {
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    
    self.leftView.userInteractionEnabled = YES;
    [self.leftView addGestureRecognizer:tapGesture];
}

- (void)setTemplateActionWithTarget:(id)target action:(SEL)action {
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    
    self.rightView.userInteractionEnabled = YES;
    [self.rightView addGestureRecognizer:tapGesture];
}


#pragma mark - properties

- (UIImageView *)servicePriceIcon {
    
    if (!_servicePriceIcon) {
        
        _servicePriceIcon = [[UIImageView alloc] init];
        [_servicePriceIcon setImage:[UIImage imageNamed:@"service_icon"]];

    }
    
    return _servicePriceIcon;
}

- (UILabel *)servicePriceLabel {
    
    if (!_servicePriceLabel) {
        
        _servicePriceLabel = [[UILabel alloc] init];
        _servicePriceLabel.textColor = [UIColor blackColor];
        _servicePriceLabel.font = [UIFont systemFontOfSize:17.0f];
        _servicePriceLabel.text = @"服务价格设置";
    }
    
    return _servicePriceLabel;
}

- (UIImageView *)templateIcon {
    
    if (!_templateIcon) {
        
        _templateIcon = [[UIImageView alloc] init];
        [_templateIcon setImage:[UIImage imageNamed:@"template_icon"]];
    }
    
    return _templateIcon;
}

- (UILabel *)templateLabel {
    
    if (!_templateLabel) {
        
        _templateLabel = [[UILabel alloc] init];
        _templateLabel.textColor = [UIColor blackColor];
        _templateLabel.font = [UIFont systemFontOfSize:17.0f];
        _templateLabel.text = @"设置问诊模板";
    }
    
    return _templateLabel;
}

- (UIView *)leftView {
    
    if (!_leftView) {
        
        _leftView = [[UIView alloc] init];
    }
    
    return _leftView;
}

- (UIView *)rightView {
    
    if (!_rightView) {
        
        _rightView = [[UIView alloc] init];
    }
    
    return _rightView;
}

@end






