//
//  TemplateCollectionViewCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/18.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TemplateCategoryCollectionViewCell.h"
#import <PureLayout.h>
#import "TemplateModel.h"
#import <UIImageView+WebCache.h>
#import "SkinManager.h"

@interface TemplateCategoryCollectionViewCell ()

@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;

@end

@implementation TemplateCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];;
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.cellIcon];
    {
        [self addConstraints:[self.cellIcon autoSetDimensionsToSize:CGSizeMake(self.frame.size.width, self.frame.size.width)]];
        [self addConstraint:[self.cellIcon autoPinEdgeToSuperviewEdge:ALEdgeTop]];
    }
    
    [self addSubview:self.cellTitle];
    {
        [self addConstraint:[self.cellTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cellIcon withOffset:10.0f]];
        [self addConstraint:[self.cellTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self addConstraint:[self.cellTitle autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    }
}

#pragma mark - loaddata

- (void)loadDataWithTemplateModel:(TemplateCategoryModel *)templateCategoryModel {
    
    [self.cellIcon sd_setImageWithURL:[NSURL URLWithString:templateCategoryModel.iconUrl] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];//TODO 默认图片
    self.cellTitle.text = [NSString stringWithFormat:@"%@(%ld)", templateCategoryModel.name, templateCategoryModel.count];
}

#pragma mark - properties

- (UIImageView *)cellIcon {
    
    if (!_cellIcon) {
        
        _cellIcon = [[UIImageView alloc] init];
        _cellIcon.layer.cornerRadius = 3.0f;
        _cellIcon.layer.masksToBounds = YES;
    }
    
    return _cellIcon;
}

- (UILabel *)cellTitle {
    
    if (!_cellTitle) {
        
        _cellTitle = [[UILabel alloc] init];
        _cellTitle.numberOfLines = 2;
        _cellTitle.font = [UIFont systemFontOfSize:12.0f];
        _cellTitle.textAlignment = NSTextAlignmentCenter;
        _cellTitle.textColor = UIColorFromRGB(0x737373);
    }
    
    return _cellTitle;
}

@end
