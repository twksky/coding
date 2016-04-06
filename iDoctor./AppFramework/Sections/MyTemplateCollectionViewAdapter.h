//
//  TemplateSettingMyTemplateCollectionViewDataSource.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemplateModel;
@protocol MyTemplateCollectionViewAdapterDelegate <NSObject>

- (void)moreMyTemplate;

- (void)didSelectedTemplate:(TemplateModel *)templateModel;

@end


@interface MyTemplateCollectionViewAdapter : NSObject
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSArray *templates;
@property (nonatomic, weak) id<MyTemplateCollectionViewAdapterDelegate> delegate;

- (instancetype)initWithReusedIdentifer:(NSString *)reusedIdentifer;

@end
