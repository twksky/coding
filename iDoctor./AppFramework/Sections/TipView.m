//
//  TipView.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TipView.h"
#import "UIView+AutoLayout.h"

@implementation TipView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.layer.cornerRadius = 5.0f;
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    
    [self addSubview:self.tipNumberLabel];
    
    [self addConstraint:[self.tipNumberLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [self addConstraint:[self.tipNumberLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [self addConstraint:[self.tipNumberLabel autoSetDimension:ALDimensionWidth toSize:17.0f]];
    [self addConstraint:[self.tipNumberLabel autoSetDimension:ALDimensionHeight toSize:10.0f]];
    
}


- (UILabel *)tipNumberLabel {
    
    if (!_tipNumberLabel) {
        
        _tipNumberLabel = [[UILabel alloc] init];
        _tipNumberLabel.textColor = [UIColor whiteColor];
        _tipNumberLabel.font = [UIFont systemFontOfSize:9.0f];
        _tipNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _tipNumberLabel;
}

@end