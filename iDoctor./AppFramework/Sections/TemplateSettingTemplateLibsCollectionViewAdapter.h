//
//  TemplateSettingTemplateLibsCollectionViewAdapter.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemplateCategoryModel;

@protocol TemplateSettingTemplateLibsCollectionViewAdapterDelegate <NSObject>

- (void)didSelectedTemplateCategory:(TemplateCategoryModel *)category;

@end

@interface TemplateSettingTemplateLibsCollectionViewAdapter : NSObject
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSArray *templateLibs;
@property (nonatomic, weak) id<TemplateSettingTemplateLibsCollectionViewAdapterDelegate> delegate;

- (instancetype)initWithReusedIdentifer:(NSString *)reusedIdentifer;


@end
