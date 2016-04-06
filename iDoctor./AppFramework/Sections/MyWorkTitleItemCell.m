//
//  MyWorkTitleItemCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/11.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MyWorkTitleItemCell.h"
#import "UIView+AutoLayout.h"
#import "TipView.h"

@implementation MyWorkTitleItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.workItemTitle];
    [self addSubview:self.workItemMsg];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    line.userInteractionEnabled = NO;
    [self addSubview:line];
    
    UIView *iconContainer = [[UIView alloc] init];
    [iconContainer addSubview:self.workItemIcon];
    
    [iconContainer addSubview:self.tipView]; //TODO 将tipview设置为类变量
    
    [self addSubview:iconContainer];
    
//    [self bringSubviewToFront:self.workItemIcon];
    
    //AutoLayout
    {
        [self addConstraint:[self.workItemTitle autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
        [self addConstraint:[self.workItemTitle autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [self addConstraint:[line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.workItemTitle withOffset:39.0f]];
        [self addConstraint:[line autoSetDimension:ALDimensionWidth toSize:1.0f]];
        [self addConstraint:[line autoSetDimension:ALDimensionHeight toSize:60.0f]];
        [self addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
        
        [self addConstraint:[iconContainer autoAlignAxis:ALAxisVertical toSameAxisOfView:line]];
        [self addConstraint:[iconContainer autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[iconContainer autoSetDimension:ALDimensionWidth toSize:52.0f]];
        [self addConstraint:[iconContainer autoSetDimension:ALDimensionHeight toSize:45.0f]];
        
        [iconContainer addConstraint:[self.workItemIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [iconContainer addConstraint:[self.workItemIcon autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [iconContainer addConstraint:[self.workItemIcon autoSetDimension:ALDimensionWidth toSize:45.0f]];
        [iconContainer addConstraint:[self.workItemIcon autoSetDimension:ALDimensionHeight toSize:45.0f]];
        
        [iconContainer addConstraint:[self.tipView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:iconContainer withOffset:4.0f]];
        [iconContainer addConstraint:[self.tipView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:iconContainer]];
        [iconContainer addConstraint:[self.tipView autoSetDimension:ALDimensionHeight toSize:10.5f]];
        [iconContainer addConstraint:[self.tipView autoSetDimension:ALDimensionWidth toSize:17.0f]];
        
        [self addConstraint:[self.workItemMsg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.workItemIcon withOffset:20.0f]];
        [self addConstraint:[self.workItemMsg autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
}

#pragma mark - properties

- (UILabel *)workItemTitle {
    
    if (!_workItemTitle) {
        
        _workItemTitle = [[UILabel alloc] init];
        _workItemTitle.textColor = UIColorFromRGB(0x8e8e91);
        _workItemTitle.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _workItemTitle;
}

- (UIImageView *)workItemIcon {
    
    if (!_workItemIcon) {
        
        _workItemIcon = [[UIImageView alloc] init];
    }
    
    return _workItemIcon;
}

- (UILabel *)workItemMsg {
    
    if (!_workItemMsg) {
        
        _workItemMsg = [[UILabel alloc] init];
        _workItemMsg.textColor = [UIColor blackColor];
        _workItemMsg.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _workItemMsg;
}
- (TipView *)tipView {
    
    if (!_tipView) {
        
        _tipView = [[TipView alloc] init];
        _tipView.backgroundColor = UIColorFromRGB(0xfe6761);
        _tipView.tipNumberLabel.text = @"-";
    }
    
    return _tipView;
}

@end
