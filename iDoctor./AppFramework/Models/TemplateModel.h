//
//  TemplateModel.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/18.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "templateCategoryModel.h"

@interface TemplateModel : NSObject

@property (nonatomic, assign) NSInteger templateId;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL last_time;
@property (nonatomic, assign) BOOL age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) BOOL symptomDescription;
@property (nonatomic, assign) BOOL images;
@property (nonatomic, strong) NSArray *fields;
//@property (nonatomic, strong) TemplateCategoryModel *category;//类别暂时木有了

@end
