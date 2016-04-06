//
//  TemplateCollectionViewCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/18.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TemplateCollectionViewCell.h"
#import <PureLayout.h>
#import "TemplateModel.h"
#import <UIImageView+WebCache.h>
#import "SkinManager.h"

@interface TemplateCollectionViewCell ()

@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;

@end

@implementation TemplateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];;
    }
    
    return self;
}

- (void)setupViews {
    
    [self.contentView addSubview:self.cellIcon];
    {
        [self.contentView addConstraints:[self.cellIcon autoSetDimensionsToSize:CGSizeMake(self.frame.size.width, self.frame.size.width)]];
        [self.contentView addConstraint:[self.cellIcon autoPinEdgeToSuperviewEdge:ALEdgeTop]];
        [self.contentView addConstraint:[self.cellIcon autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    }
    
    [self.contentView addSubview:self.cellTitle];
    {
        [self.contentView addConstraint:[self.cellTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cellIcon withOffset:10.0f]];
        [self.contentView addConstraint:[self.cellTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self.contentView addConstraint:[self.cellTitle autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    }
}

#pragma mark - loaddata

- (void)loadDataWithTemplateModel:(TemplateModel *)templateModel {
    
//    [self.cellIcon sd_setImageWithURL:[NSURL URLWithString:templateModel.category.iconUrl] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];//TODO 默认图片
    [self.cellIcon setImage:[UIImage imageNamed:@"icon_templatemodel_default"]];
    self.cellTitle.text = templateModel.name;
}

- (void)setAsAddTemplateCellStyle {
    
    [self.cellIcon setImage:[UIImage imageNamed:@"icon_add_template_collectioonView"]];
    self.cellTitle.text = @"新的模板";
}

- (void)setAsMoreTemplateCellStyle {
    
    [self.cellIcon setImage:[UIImage imageNamed:@"icon_templatesetting_more"]];
    self.cellTitle.text = @"";
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
