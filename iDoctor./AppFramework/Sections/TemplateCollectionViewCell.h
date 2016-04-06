//
//  TemplateCollectionViewCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/18.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TemplateModel;

@interface TemplateCollectionViewCell : UICollectionViewCell

- (void)loadDataWithTemplateModel:(TemplateModel *)templateModel;

- (void)setAsAddTemplateCellStyle;

- (void)setAsMoreTemplateCellStyle;

@end
