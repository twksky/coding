//
//  IDTemplateModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDTemplateModel : NSObject

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
