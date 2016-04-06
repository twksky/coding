//
//  TemplateSettingMyTemplateCollectionViewDataSource.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemplateModel;
@protocol TemplateSettingTemplateCollectionViewAdapterDelegate <NSObject>

- (void)addNewTemplate;

- (void)didSelectedTemplate:(TemplateModel *)templateModel;

@end


@interface TemplateSettingTemplateCollectionViewAdapter : NSObject
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSArray *templates;
@property (nonatomic, weak) id<TemplateSettingTemplateCollectionViewAdapterDelegate> delegate;

- (instancetype)initWithReusedIdentifer:(NSString *)reusedIdentifer;

@end
