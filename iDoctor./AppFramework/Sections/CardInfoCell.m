//
//  CardInfoCell.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/2.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "CardInfoCell.h"
#import <PureLayout.h>

@interface CardInfoCell ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *titleContent;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CardInfoCell


- (instancetype)initWithTitle:(NSString *)title uiTextField:(UITextField *)uiTextField {
    
    self = [super init];
    if (self) {
        
        self.textField = uiTextField;
        self.titleContent = title;
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    
    [self addConstraint:[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    [self addConstraint:[self.titleLabel autoSetDimension:ALDimensionWidth toSize:110.0f]];
    [self addConstraint:[self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    
    [self addConstraint:[self.textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLabel withOffset:10.0f]];
    [self addConstraint:[self.textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    [self addConstraint:[self.textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
}

#pragma mark - properties

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:19.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = self.titleContent;
//        _titleLabel.backgroundColor = [UIColor greenColor];
//        self.textField.backgroundColor = [UIColor yellowColor];
    }
    
    return _titleLabel;
}


@end
