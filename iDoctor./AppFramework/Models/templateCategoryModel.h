//
//  templateCategoryModel.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateCategoryModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *iconUrl;

@end
