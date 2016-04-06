//
//  MedicalRecordCollectionViewCell.m
//  AppFramework
//
//  Created by ABC on 8/24/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "MedicalRecordCollectionViewCell.h"
#import "UIView+AutoLayout.h"

@implementation MedicalRecordCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.imageView];
        // Autolayout
        [self.contentView addConstraints:[self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
