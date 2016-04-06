//
//  QuickQuestionReplyCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/4/23.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "QuickQuestionReplyCell.h"
#import "UIView+AutoLayout.h"

@implementation QuickQuestionReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
     
    return self;
}

- (void)setupSubViews {
    
    [self addSubview:self.replyButton];
    
    //AutoLayout
    {
        [self addConstraint:[self.replyButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
        [self addConstraint:[self.replyButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self addConstraint:[self.replyButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self addConstraint:[self.replyButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
        [self addConstraint:[self.replyButton autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20]];
        [self addConstraint:[self.replyButton autoSetDimension:ALDimensionHeight toSize:55.0 - 10.0]];
    }
    
}

- (void)addReplyButtonAction:(SEL)action withTarget:(id)target {
    
    [self.replyButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}




- (UIButton *)replyButton {
    
    if (nil == _replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        _replyButton.layer.cornerRadius = 3.0f;
        _replyButton.layer.masksToBounds = YES;
        [_replyButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
    }
    
    return _replyButton;
}

@end
