//
//  ContactInfoHeaderView.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "ContactInfoHeaderView.h"
#import "UIView+AutoLayout.h"
#import "Patient.h"
#import <UIImageView+WebCache.h>
#import "SkinManager.h"

@interface ContactInfoHeaderView ()

@property (nonatomic, strong) UIImageView *iconAvatarImageView;
@property (nonatomic, strong) UILabel *contactNameLabel;
@property (nonatomic, strong) UILabel *recordIDLabel;
@property (nonatomic, strong) UIButton *changeNameButton;

@end

@implementation ContactInfoHeaderView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //TODO
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    self.backgroundColor = UIColorFromRGB(0x34d2b4);
    self.iconAvatarImageView.layer.cornerRadius = 54.5f;
    
    [self addSubview:self.iconAvatarImageView];
    [self addSubview:self.contactNameLabel];
    [self addSubview:self.recordIDLabel];
    [self addSubview:self.changeNameButton];
    
    //AutoLayout
    {
        [self addConstraint:[self.iconAvatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25.0f]];
        [self addConstraint:[self.iconAvatarImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraints:[self.iconAvatarImageView autoSetDimensionsToSize:CGSizeMake(109.0f, 109.0f)]];
        
        [self addConstraint:[self.contactNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.iconAvatarImageView withOffset:-15.0f]];
        [self addConstraint:[self.contactNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconAvatarImageView withOffset:15.0f]];
        [self addConstraint:[self.contactNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f]];
        
        [self addConstraint:[self.changeNameButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.contactNameLabel withOffset:15.0f]];
        [self addConstraint:[self.changeNameButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contactNameLabel]];
        
        [self addConstraint:[self.recordIDLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.iconAvatarImageView withOffset:15.0f]];
        [self addConstraint:[self.recordIDLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconAvatarImageView withOffset:15.0f]];
    }
}

#pragma mark interface

- (void)setAvatarWithImage:(UIImage *)image {
    
    [self.iconAvatarImageView setImage:image];
}

- (void)setName:(NSString *)name {
    
    self.contactNameLabel.text = name;
}

- (void)setRecordID:(NSString *)recordID {
    
    self.recordIDLabel.text = [NSString stringWithFormat:@"健康档案编号: %@", recordID];
}

#pragma mark - loadData

- (void)loadDataWithPatient:(Patient *)patient {
    
    [self.iconAvatarImageView sd_setImageWithURL:[NSURL URLWithString:patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];
    
    self.contactNameLabel.text = [patient getDisplayName];
    
    self.recordIDLabel.text = [NSString stringWithFormat:@"健康档案编号: %ld", patient.userID];
}

#pragma mark - selector

- (void)changeNameButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDisplayNameButtonClicked)]) {
        
        [self.delegate changeDisplayNameButtonClicked];
    }
}

#pragma mark - properties

- (UIImageView *)iconAvatarImageView {
    
    if (!_iconAvatarImageView) {
        
        _iconAvatarImageView = [[UIImageView alloc] init];
        _iconAvatarImageView.layer.borderColor = [UIColorFromRGB(0xcaf6ea) CGColor];
        _iconAvatarImageView.layer.borderWidth = 2.0f;
        _iconAvatarImageView.layer.masksToBounds = YES;
    }
    
    return _iconAvatarImageView;
}

- (UILabel *)contactNameLabel {
    
    if(!_contactNameLabel) {
        
        _contactNameLabel = [[UILabel alloc] init];
        _contactNameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _contactNameLabel.textColor = [UIColor whiteColor];
    }
    
    return _contactNameLabel;
}

- (UILabel *)recordIDLabel {
    
    if (!_recordIDLabel) {
        
        _recordIDLabel = [[UILabel alloc] init];
        _recordIDLabel.font = [UIFont systemFontOfSize:14.0f];
        _recordIDLabel.textColor = [UIColor whiteColor];
    }
    
    return _recordIDLabel;
}

- (UIButton *)changeNameButton {
    
    if (!_changeNameButton) {
        
        _changeNameButton = [[UIButton alloc] init];
        [_changeNameButton setTitle:@"(修改备注名)" forState:UIControlStateNormal];
        [_changeNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeNameButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_changeNameButton addTarget:self action:@selector(changeNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeNameButton;
}


@end


















