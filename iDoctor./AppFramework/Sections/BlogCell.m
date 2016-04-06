//
//  BlogCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BlogCell.h"
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "BlogItem.h"
#import "SkinManager.h"

@interface BlogCell ()

@property (nonatomic, strong) UIImageView *blogIconImageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *shortDescLabel;

@end

@implementation BlogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.blogIconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.shortDescLabel];
    
    [self addConstraints:[self.blogIconImageView autoSetDimensionsToSize:CGSizeMake(70.0f, 70.0f)]];
    [self addConstraint:[self.blogIconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    [self addConstraint:[self.blogIconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    
    [self addConstraint:[self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.blogIconImageView withOffset:10.0f]];
    [self addConstraint:[self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.blogIconImageView withOffset:3.0f]];
    [self addConstraint:[self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
#pragma mark - 添加约束
    // 添加约束
    [self addConstraint:[self.titleLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 105]];
    [self addConstraint:[self.shortDescLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.titleLabel]];
    // 约束添加完毕
    
    [self addConstraint:[self.shortDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:5.0f]];
    [self addConstraint:[self.shortDescLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.blogIconImageView withOffset:10.0f]];
    [self addConstraint:[self.shortDescLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
}


#pragma mark - loadData

- (void)loadBlog:(BlogItem *)blogItem {
    
    [self.blogIconImageView sd_setImageWithURL:[NSURL URLWithString:blogItem.bannerUrl] placeholderImage:[SkinManager sharedInstance].defaultImg]; 
    
    self.titleLabel.text = blogItem.title;
    
    self.shortDescLabel.text = blogItem.shortDesc;
}

#pragma mark - properties

- (UIImageView *)blogIconImageView {
    
    if (!_blogIconImageView) {
        
        _blogIconImageView = [[UIImageView alloc] init];
    }
    
    return _blogIconImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    return _titleLabel;
}

- (UILabel *)shortDescLabel {
    
    if (!_shortDescLabel) {
        
        _shortDescLabel = [[UILabel alloc] init];
        _shortDescLabel.numberOfLines = 2;
        _shortDescLabel.textColor = UIColorFromRGB(0x8e8e91);
        _shortDescLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _shortDescLabel;
}


@end











